import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/service_model.dart';
import '../core/constants/app_constants.dart';

class ServiceDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  CollectionReference get _collection =>
      _db.collection(AppConstants.servicesCollection);

  // جلب كل الخدمات الخاصة بمستخدم معيّن (Stream لتحديث لحظي)
  Stream<List<ServiceModel>> getServices(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // إضافة خدمة جديدة
  Future<void> addService({
    required String userId,
    required String name,
    required String description,
    required double price,
    required String category,
  }) async {
    final id = _uuid.v4();
    final service = ServiceModel(
      id: id,
      userId: userId,
      name: name,
      description: description,
      price: price,
      category: category,
      createdAt: DateTime.now(),
    );
    await _collection.doc(id).set(service.toMap());
  }

  // تعديل خدمة
  Future<void> updateService(ServiceModel service) async {
    await _collection.doc(service.id).update(service.toMap());
  }

  // حذف خدمة
  Future<void> deleteService(String id) async {
    await _collection.doc(id).delete();
  }

  // تفعيل/تعطيل خدمة
  Future<void> toggleActive(String id, bool isActive) async {
    await _collection.doc(id).update({'isActive': isActive});
  }
}