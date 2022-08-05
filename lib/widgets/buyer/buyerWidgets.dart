import 'package:flutter/material.dart';
import 'package:masterreads/constants/colors.dart';

Widget buyerBooksCount(List buyerBooks) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
          Text(
            'Books Owned',
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Poppins',
              fontSize: 21,
            ),
          ),
          Text(
            '${buyerBooks.where((element) => element['isVerified'] == true).toList().length}',
            style: const TextStyle(
              color: kPrimaryColor,
              fontFamily: 'Poppins',
              fontSize: 21,
            ),
          ),
        ],
      ),
    ],
  );
}
