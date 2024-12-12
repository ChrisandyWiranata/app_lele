import 'package:app_lele/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
