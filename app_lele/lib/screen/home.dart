import 'package:app_lele/screen/signin.dart';
import 'package:app_lele/service/product_service.dart';
import 'package:app_lele/widgets/product.dart';
import 'package:app_lele/widgets/useable/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () async {
            await auth.signOut();
            ToastHelper.showSuccess(context: context, message: 'Log Out Berhasil');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ProductService().fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final datas = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    "Top Products",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: datas?.length ?? 0,
                    itemBuilder: (context, index) {
                      final data = datas![index];
                      return ProductCard(data: data);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Failed to fetch data'));
        },
      ),
    );
  }
}