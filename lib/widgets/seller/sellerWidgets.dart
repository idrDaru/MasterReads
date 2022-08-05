import 'package:flutter/material.dart';
import 'package:masterreads/constants/colors.dart';

Widget sellerBooksCount(List sellerBooks) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
          Text(
            'Published',
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Poppins',
              fontSize: 21,
            ),
          ),
          Text(
            '${sellerBooks.where((element) => element['isVerified'] == true).toList().length}',
            style: const TextStyle(
              color: kPrimaryColor,
              fontFamily: 'Poppins',
              fontSize: 21,
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 8,
        ),
        child: Container(
          height: 40,
          width: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey,
          ),
        ),
      ),
      Column(
        children: [
          Text(
            'On Review',
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Poppins',
              fontSize: 21,
            ),
          ),
          Text(
            '${sellerBooks.where((element) => element['isVerified'] == false).toList().length}',
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
