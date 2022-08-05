import 'package:flutter/material.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/routes/routes.dart';

import '../utils/search.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 15,
      left: 15,
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.4),
            ),
          ],
          borderRadius: BorderRadius.circular(45),
        ),
        height: 75,
        alignment: Alignment.center,
        child: Material(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.routeBookList);
                },
                icon: Icon(
                  Icons.home_rounded,
                  size: 36,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                onPressed: () => showSearch(
                  context: context,
                  delegate: Search(),
                ),
                icon: Icon(
                  Icons.search,
                  size: 36,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 36,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.routeProfilePage);
                },
                icon: Icon(
                  Icons.person,
                  size: 36,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
