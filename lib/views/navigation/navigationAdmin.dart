import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:path/path.dart';
import 'package:masterreads/models/navigation.dart';
import 'package:masterreads/providers/navigation_provider.dart';
import 'package:provider/provider.dart';



class NavigationDrawerWidget extends StatelessWidget {
  static final padding = EdgeInsets.symmetric(horizontal: 20);
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
                      item: NavigationItem.people,
                      text: 'Users',
                      icon: Icons.people,
                    ),

                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.pending,
                      text: 'Pending Requests',
                      icon: Icons.pending_actions,
                    ),


                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.approved,
                      text: 'Accepted Requests',
                      icon: Icons.approval,
                    ),

                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.rejected,
                      text: 'Rejected Requests',
                      icon: Icons.wrong_location,
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
    provider.setNavigationItem(item);
  }
}
