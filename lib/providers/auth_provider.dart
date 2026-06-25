import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String _errorMessage = '';

  AuthStatus get status      => _status;
  UserModel? get user        => _user;
  String get errorMessage    => _errorMessage;
  bool get isLoading         => _status == AuthStatus.loading;
  bool get isAuthenticated   => _status == AuthStatus.authenticated;

  AuthProvider() {
    _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      _user = await _authService.signIn(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _getErrorMessage(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String companyName,
  }) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      _user = await _authService.register(
        name:        name,
        email:       email,
        password:    password,
        phone:       phone,
        companyName: companyName,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _getErrorMessage(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  String _getErrorMessage(String error) {

    if (error.contains('user-not-found'))     return 'البريد الإلكتروني غير مسجل';
    if (error.contains('wrong-password'))     return 'كلمة المرور غير صحيحة';
    if (error.contains('email-already'))      return 'البريد الإلكتروني مستخدم مسبقاً';
    if (error.contains('weak-password'))      return 'كلمة المرور ضعيفة جداً';
    if (error.contains('invalid-email'))      return 'البريد الإلكتروني غير صحيح';
    if (error.contains('network-request'))    return 'تحقق من اتصال الإنترنت';
    return 'حدث خطأ، حاول مجدداً';
  }


  Future<bool> signInWithGoogle() async {
  try {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final user = await _authService.signInWithGoogle();
    if (user == null) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    _user = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  } catch (e) {
    _status = AuthStatus.error;
    _errorMessage = 'فشل تسجيل الدخول عبر جوجل';
    notifyListeners();
    return false;
  }
}


}