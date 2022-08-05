import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:masterreads/views/Library/index.dart';
import 'package:masterreads/views/Library/library.dart';
import 'package:masterreads/views/Sales/salesView.dart';
import 'package:masterreads/views/books/bookList.dart';
import 'package:masterreads/views/user/buyerCart.dart';
import 'package:masterreads/views/user/profilePage.dart';
import 'package:path/path.dart';
import 'package:masterreads/models/navigation.dart';
import 'package:masterreads/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:masterreads/Service/authentication.dart';

import '../books/sellerHome.dart';



class NavigationSellerDrawerWidget extends StatelessWidget {
  static final padding = const EdgeInsets.symmetric(horizontal: 20);
  final name = 'Sarah Abs';
  final email = 'sarah@abs.com';
  final urlImage =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';


  @override
  Widget build(BuildContext context) =>
      Drawer(
        child: Container(
          color: Colors.purple[700],
          child: ListView(
            children: <Widget>[
              // buildHeader(
              //   context,
              //   urlImage: urlImage,
              //   name: name,
              //   email: email,
              // ),
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.profile,
                      text: 'Profile',
                      icon: Icons.person,
                    ),

                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.home,
                      text: 'Home',
                      icon: Icons.home,
                    ),

                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.sales,
                      text: 'Sales',
                      icon: Icons.sell,
                    ),


                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.cart,
                      text: 'Shopping Cart',
                      icon: Icons.library_add,
                    ),

                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.history,
                      text: 'History',
                      icon: Icons.history,
                    ),

                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.signout,
                      text: 'Signout ',
                      icon: Icons.exit_to_app,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem(
      BuildContext context, {
        required NavigationItem item,
        required String text,
        required IconData icon,
      }) {
    final provider = Provider.of<NavigationProvider>(context);
    final currentItem = provider.navigationItem;
    final isSelected = item == currentItem;

    final color = isSelected ? Colors.orangeAccent : Colors.white;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.white24,
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color, fontSize: 16)),
        onTap: () => selectItem(context, item),
      ),
    );
  }

  void selectItem(BuildContext context, NavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    print(item);
    provider.setNavigationItem(item);
    if(item.toString()=="NavigationItem.profile")
    {
      navigateNext(const ProfilePage(), context);
    }

    if(item.toString()=="NavigationItem.home")
    {
      navigateNext(const sellerHome(), context);
    }

    if(item.toString()=="NavigationItem.sales")
    {
      navigateNext( SalesView(), context);
    }


    if(item.toString()=="NavigationItem.signout")
    {
      context.read<AuthService>().signOut();
    }



    if(item.toString()=="NavigationItem.history")
    {
      navigateNext( eLibrary(), context);
    }


    if(item.toString()=="NavigationItem.cart")
    {
      navigateNext(const Cart(), context);
    }


    if(item.toString()=="NavigationItem.people")
    {

      navigateNext(const ProfilePage(), context);
    }
    if (item.toString() == "NavigationItem.books") {
      navigateNext(const Library(), context);
    }
  }

  void navigateNext(Widget route, context)
  {

    // Navigator.pushNamed(context, AppRoutes.routeBookDetail);

    Navigator.push(context, MaterialPageRoute(builder: (_) => route));
  }
}
