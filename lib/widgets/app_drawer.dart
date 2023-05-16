import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/manage_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: const Text(
              "Boshqaruv paneli",
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text("Asosiy sahifa"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.checklist_rtl),
            title: const Text("Buyurtmalar"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text("Mahsulotlarni boshqarish"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: const Text("Chiqish"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
