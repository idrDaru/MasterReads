import 'package:flutter/material.dart';
import 'package:masterreads/views/books/bookDetail.dart';

import '../../constants/colors.dart';

class searchBooks extends StatefulWidget {
  const searchBooks({Key? key}) : super(key: key);

  @override
  State<searchBooks> createState() => _searchBooksState();

  void searchSellerBooks(String searchEntry, List bookList) {}
}

class _searchBooksState extends State<searchBooks> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future searchSellerBooks(String searchEntry, List bookList) async {
    print("Author1:");
    try {
      print("Author1:");
      child:
      Container(
        margin: EdgeInsets.only(
          top: 21,
        ),
        height: 210,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 25,
            right: 6,
          ),
          itemCount: bookList.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            print(bookList[index]['author']);
            if (searchEntry == bookList[index]['author']) {
              print("working");
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetail(
                        bookId: bookList[index]['id'],
                        coverUrl: bookList[index]['coverPhotoUrl'],
                        title: bookList[index]['title'],
                        author: bookList[index]['author'],
                        price: bookList[index]['price'].toString(),
                        description: bookList[index]['description'],
                        userId: bookList[index]['userId'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 19),
                  height: 210,
                  width: 153,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor,
                    image: DecorationImage(
                      image: NetworkImage(
                        '${bookList[index]['coverPhotoUrl']}',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            } else {
              print("problem");
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetail(
                        bookId: bookList[index]['id'],
                        coverUrl: bookList[index]['coverPhotoUrl'],
                        title: bookList[index]['title'],
                        author: bookList[index]['author'],
                        price: bookList[index]['price'].toString(),
                        description: bookList[index]['description'],
                        userId: bookList[index]['userId'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 19),
                  height: 210,
                  width: 153,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor,
                    image: DecorationImage(
                      image: NetworkImage(
                        '${bookList[index]['coverPhotoUrl']}',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
      return bookList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
