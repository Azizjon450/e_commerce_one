import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './styles/my_shop_styles.dart';
import './screens/home_screen.dart';
import './screens/product_details_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/manage_product_screen.dart';
import './screens/auth_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../providers/orders.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData theme = MyShopStyle.theme;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme,
          home: AuthScreen(),
          routes: {
            AuthScreen.routName: (context) => const AuthScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            ProductDetailsScreen.routeName: (context) =>
                const ProductDetailsScreen(),
            cartScreen.routeName: (context) => const cartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            ManageProductScreen.routeName: (context) =>
                const ManageProductScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          }),
    );
  }
}
