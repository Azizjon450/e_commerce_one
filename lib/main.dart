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
import '../screens/splash_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProduct) =>
              previousProduct!..setParametrs(auth.token, auth.userId),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) =>
              previousOrders!..setParameters(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: theme,
            home: authData.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: ((contx, autoLoginData) {
                      if (autoLoginData.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    }),
                  ),
            routes: {
              AuthScreen.routName: (context) => const AuthScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              ProductDetailsScreen.routeName: (context) =>
                  const ProductDetailsScreen(),
              cartScreen.routeName: (context) => const cartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              ManageProductScreen.routeName: (context) =>
                  const ManageProductScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
