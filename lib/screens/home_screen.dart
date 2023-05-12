import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FiltersOption {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromRGBO(61, 129, 174, 1),
        //backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "Mening Do'konim",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (ctx) {
              return [
                const PopupMenuItem(
                  child: Text("Barchasi"),
                  value: FiltersOption.All,
                ),
                const PopupMenuItem(
                  child: Text("Sevimli"),
                  value: FiltersOption.Favorites,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, value, child) {
              return Center(
                child: Badge(
                  alignment: AlignmentDirectional(0.5, -0.5),
                  label: Text(
                    cart.itemsCount().toString(),
                  ),
                  child: IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(cartScreen.routeName),
                    icon: Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )),
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
