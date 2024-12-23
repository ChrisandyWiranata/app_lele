class ProductModel {
  final String? id;
  final String name;
  final int price;
  final String description;
  final String image;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }
}
