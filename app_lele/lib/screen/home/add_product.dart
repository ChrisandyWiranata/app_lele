import 'package:app_lele/components/custom_text_field.dart';
import 'package:app_lele/screen/main_screen.dart';
import 'package:app_lele/service/product_service.dart';
import 'package:app_lele/components/custom_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:app_lele/model/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ProductService _productService = ProductService();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
        image: _imageController.text,
      );

      await _productService.addProduct(product);
      if (mounted) {
        analytics.logEvent(
            name: 'add_product', parameters: {'product_name': product.name});
        ToastHelper.showSuccess(
            context: context, message: 'Product added successfully');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'Product Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                label: 'Price',
                hint: 'Rp ',
                isInputNumber: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description Product',
                hint: 'Description Product',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description product';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _imageController,
                label: 'Image URL',
                hint: 'Image URL',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
