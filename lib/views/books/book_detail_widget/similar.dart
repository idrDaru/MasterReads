import 'package:flutter/material.dart';
import 'package:masterreads/views/books/bookDetail.dart';

class Similar extends StatelessWidget {
  const Similar({
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
      child: Row(),
    );
  }
}
