import 'package:app_lele/components/custom_text_field.dart';
import 'package:app_lele/screen/main_screen.dart';
import 'package:app_lele/service/product_service.dart';
import 'package:app_lele/widgets/useable/custom_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:app_lele/model/product.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _imageController = TextEditingController(text: widget.product.image);
  }

  void _deleteProduct() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _productService.deleteProduct(widget.product.id!);

      if (mounted) {
        analytics.logEvent(
            name: 'delete_product',
            parameters: {'product_name': widget.product.name});
        ToastHelper.showSuccess(
            context: context, message: 'Delete successfully');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    }
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = ProductModel(
        id: widget.product.id,
        name: _nameController.text,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
        image: _imageController.text,
      );

      await _productService.updateProduct(widget.product.id!, updatedProduct);

      if (mounted) {
        analytics.logEvent(
            name: 'edit_product',
            parameters: {'product_name': widget.product.name});
        ToastHelper.showSuccess(context: context, message: 'Edit successfully');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProduct,
          ),
        ],
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
                onPressed: _updateProduct,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
