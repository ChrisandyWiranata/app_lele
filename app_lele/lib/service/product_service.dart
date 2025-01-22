import 'package:app_lele/model/product.dart';
import 'package:app_lele/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  final productsCollection = FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot> getProducts() {
    return productsCollection.snapshots();
  }

  Future<void> addProduct(ProductModel product) {
    return productsCollection.add(product.toMap());
  }

  Future<void> updateProduct(String id, ProductModel product) {
    return productsCollection.doc(id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return productsCollection.doc(id).delete();
  }

  Future<void> reportProduct(String productId, String reason) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userCur = await AuthService().getCurrentUser();
    if (userCur == null) return;

    final reportCollection = FirebaseFirestore.instance.collection('reports');
    await reportCollection.add({
      'productId': productId,
      'reason': reason,
      'reportedBy': userCur['username'],
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getReportsForProduct(String productId) {
    return FirebaseFirestore.instance
        .collection('reports')
        .where('productId', isEqualTo: productId)
        .snapshots();
  }
}
