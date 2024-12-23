// import 'package:app_lele/model/product.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;

//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'ternak_lele.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE products(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         price INTEGER,
//         image TEXT
//       )
//     ''');
    
//     await _insertInitialProducts(db);
//   }

//    Future _insertInitialProducts(Database db) async {
//     List<ProductModel> initialProducts = [
//       ProductModel(name: 'Bibit Lele Sangkuriang', price: 50000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEEE_o8anmLQvblXBXO_Hgony_2WolnHna7g&s'),
//       ProductModel(name: 'Pakan Lele Premium', price: 75000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSz5B8JNZJvAFfHr4tbjXyKESER22rNNyJiJw&s'),
//       ProductModel(name: 'Probiotik Lele', price: 45000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSY2dzNxOzqTs4ZgRRezrVDIoBDpybOT4FWA&s'),
//       ProductModel(name: 'Vitamin Lele', price: 35000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZMV41n4lJ7H98GTWR94qfxNwdOZ0fFHmDiA&s'),
//       ProductModel(name: 'Pelet Lele Starter', price: 60000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQutQgmRmUMmfH2XLFQz4P3pqpHgAmcGOAwbQ&s'),
//       ProductModel(name: 'Obat Lele', price: 25000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqS6n97nDmETm4OtwYUr0cQPcOEY_odS5CBA&s'),
//       ProductModel(name: 'Bibit Lele Dumbo', price: 55000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYb0UO6ZxwNFNC24NKRAd8yrt-PFY9lsOgfQ&s'),
//       ProductModel(name: 'Pakan Organik', price: 80000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRr4gDjpH5wCRWbDRD1xuXzHJ2D2H-KVMWQ0Q&s'),
//       ProductModel(name: 'Aerator Kolam', price: 150000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdo3_Y_b1p6ir3c8j2x7FNvutW3KUSApBK1A&s'),
//       ProductModel(name: 'pH Meter', price: 120000, 
//         image: 'https://m.media-amazon.com/images/I/51uM4uYmLrL._AC_UF894,1000_QL80_.jpg'),
//       ProductModel(name: 'Jaring Lele', price: 95000, 
//         image: 'https://images.tokopedia.net/img/cache/250-square/VqbcmM/2024/1/17/b206ba4b-8cd5-4db9-a439-66d4cd631032.png?ect=4g'),
//       ProductModel(name: 'Terpal Kolam', price: 200000, 
//         image: 'https://images.tokopedia.net/img/cache/500-square/VqbcmM/2020/10/17/10f6e185-9849-427e-9bab-a7b6cf31996f.jpg'),
//       ProductModel(name: 'Filter Air', price: 175000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_cNpiaZUbbgzmjbZgxbLvXU7YhEdBiYJ3kQ&s'),
//       ProductModel(name: 'Pompa Air', price: 250000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDQ6uvr5A7o_7fCu5omLxAH6X-QOUO-LWsKg&s'),
//       ProductModel(name: 'Test Kit Air', price: 85000, 
//         image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKO-gmmv5RKIcQyaVSVCt1bIKePFYPawJppQ&s'),
//     ];

//     for (var product in initialProducts) {
//       await db.insert('products', product.toMap());
//     }
//   }

//   Future<int> insertProduct(ProductModel product) async {
//     Database db = await database;
//     return await db.insert('products', product.toMap());
//   }

//   Future<List<ProductModel>> getAllProducts() async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('products');
//     return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
//   }

//   Future<ProductModel?> getProduct(int id) async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query(
//       'products',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (maps.isNotEmpty) {
//       return ProductModel.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<int> updateProduct(ProductModel product) async {
//     Database db = await database;
//     return await db.update(
//       'products',
//       product.toMap(),
//       where: 'id = ?',
//       whereArgs: [product.id],
//     );
//   }

//   Future<int> deleteProduct(int id) async {
//     Database db = await database;
//     return await db.delete(
//       'products',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
