class ProductModel {
  final int? id;
  final String name;
  final int price;
  final String image;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    };
  }
}
