import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (cred.user == null) return null;
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(cred.user!.uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String companyName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (cred.user == null) return null;

    final user = UserModel(
      id: cred.user!.uid,
      name: name,
      email: email.trim(),
      phone: phone,
      companyName: companyName,
      createdAt: DateTime.now(),
    );

    await _db
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toMap());
    return user;
  }

  // ← تسجيل الدخول عبر جوجل (يعمل على الويب والموبايل)
  Future<UserModel?> signInWithGoogle() async {
    UserCredential cred;

    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      cred = await _auth.signInWithPopup(googleProvider);
    } else {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // المستخدم ألغى العملية

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      cred = await _auth.signInWithCredential(credential);
    }

    if (cred.user == null) return null;

    final docRef =
        _db.collection(AppConstants.usersCollection).doc(cred.user!.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    } else {
      final newUser = UserModel(
        id: cred.user!.uid,
        name: cred.user!.displayName ?? 'مستخدم',
        email: cred.user!.email ?? '',
        phone: cred.user!.phoneNumber ?? '',
        companyName: '',
        createdAt: DateTime.now(),
      );
      await docRef.set(newUser.toMap());
      return newUser;
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());
}