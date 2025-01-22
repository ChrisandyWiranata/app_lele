import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/screen/home/edit_product.dart';
import 'package:app_lele/screen/home/report_product.dart';
import 'package:app_lele/service/auth_service.dart';
import 'package:app_lele/service/product_service.dart';
import 'package:app_lele/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:app_lele/model/product.dart';

class DetailProductScreen extends StatefulWidget {
  final ProductModel product;

  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final user = await AuthService().getCurrentUser();
    if (user?['role'] == 'admin') {
      setState(() {
        isAdmin = true;
      });
    }
  }

  void _reportProduct() async {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report Product'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: 'Enter reason for reporting',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  await ProductService()
                      .reportProduct(widget.product.id!, reason);
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Product reported successfully')),
                    );
                  }
                }
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.icicle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.product.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.curelean.withOpacity(0.7),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Column(
                          children: [
                            if (isAdmin)
                              CircleAvatar(
                                backgroundColor:
                                    AppColors.curelean.withOpacity(0.7),
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProductScreen(
                                          product: widget.product,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  AppColors.curelean.withOpacity(0.7),
                              child: IconButton(
                                  icon: const Icon(Icons.report_problem,
                                      color: Colors.white),
                                  onPressed: () {
                                    isAdmin
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportProductScreen(
                                                      productId:
                                                          widget.product.id!,
                                                    )))
                                        : _reportProduct();
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.curelean,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    CurrencyFormat.format(widget.product.price),
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.bluetopaz,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.bluetopaz.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.curelean,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
