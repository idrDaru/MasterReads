import 'package:flutter/material.dart';
import 'package:masterreads/views/books/bookDetail.dart';

class Description extends StatelessWidget {
  const Description({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final BookDetail widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        right: 25,
        bottom: 25,
      ),
      child: Text(
        widget.description,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
