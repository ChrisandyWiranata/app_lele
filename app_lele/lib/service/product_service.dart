import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/products'));
    final json = jsonDecode(response.body);
    return json;
  }
}
