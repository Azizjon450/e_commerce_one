import 'package:e_commerse_one/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  static const routeName = '/manage-product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProductsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Maxsulotlarni boshqarish"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productProvider.list.length,
          itemBuilder: (ctx, i) {
            final product = productProvider.list[i];
            return ChangeNotifierProvider.value(
              value: product,
              child: const UserProductItem(),
            );
          },
        ),
      ),
    );
  }
}
