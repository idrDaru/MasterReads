import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/models/book.dart';
import 'package:masterreads/utils/search.dart';
import 'package:masterreads/views/books/bookDetail.dart';
import 'package:masterreads/views/books/searchBook.dart';
import 'package:masterreads/widgets/bottomBar.dart';
import 'package:masterreads/widgets/customTabIndicator.dart';
import 'package:masterreads/views/navigation/navigationBuyer.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final userId = FirebaseAuth.instance.currentUser!;
  List bookList = [];
  // String searchEntry='';
  String searchEntry = '';

  @override
  void initState() {
    super.initState();
    getBookList();
  }

  getBookList() async {
    dynamic data = await Book().getBookList();

    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        bookList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationBuyerDrawerWidget(),
   appBar: AppBar(
     title: Text('MasterEreads'),
     backgroundColor: Colors.white,
   ),

      body: Container(
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Let's Start Reading !",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Discover Latest Book",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 39,
                  margin: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                        onChanged: (value) {
                          searchEntry = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 19,
                            right: 50,
                            bottom: 8,
                          ),
                          border: InputBorder.none,
                          hintText: 'Search book..',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          height: 39,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryColor,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.symmetric(),
                            onPressed: () => showSearch(
                              context: context,
                              delegate: Search(),
                            ),
                            icon: IconButton(
                              onPressed: () => showSearch(
                                context: context,
                                delegate: Search(),
                              ),
                              icon: const Icon(
                                Icons.search,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 25,
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.only(left: 25),
                  child: DefaultTabController(
                    length: 3,
                    child: TabBar(
                      labelPadding: const EdgeInsets.all(0),
                      indicatorPadding: const EdgeInsets.all(0),
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      indicator: RoundedRectangleTabIndicator(
                        weight: 2,
                        width: 10,
                        color: Colors.black,
                      ),
                      tabs: [
                        Tab(
                          child: Container(
                            margin: const EdgeInsets.only(right: 23),
                            child: const Text('New'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            margin: const EdgeInsets.only(right: 23),
                            child: const Text('Trending'),
                          ),
                        ),
                        Tab(
                          child: Container(
                            margin: const EdgeInsets.only(right: 23),
                            child: const Text('Best Seller'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 21,
                  ),
                  height: 210,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 6,
                    ),
                    itemCount: bookList.length,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetail(
                                userId: userId.uid,
                                bookId: bookList[index]['id'],
                                coverUrl: bookList[index]['coverPhotoUrl'],
                                title: bookList[index]['title'],
                                author: bookList[index]['author'],
                                price: bookList[index]['price'].toString(),
                                description: bookList[index]['description'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 19),
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
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25, top: 25),
                  child: Text(
                    "Popular",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 25,
                    right: 25,
                    left: 25,
                  ),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bookList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetail(
                              userId: userId.uid,
                              bookId: bookList[index]['id'],
                              coverUrl: bookList[index]['coverPhotoUrl'],
                              title: bookList[index]['title'],
                              author: bookList[index]['author'],
                              price: bookList[index]['price'].toString(),
                              description: bookList[index]['description'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 19),
                        height: 81,
                        width: MediaQuery.of(context).size.width - 50,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 81,
                              width: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${bookList[index]['coverPhotoUrl']}',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${bookList[index]['title'].length > 30 ? bookList[index]['title'].substring(0, 30) + '...' : bookList[index]['title']}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${bookList[index]['author']}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  bookList[index]['price'] == 0
                                      ? 'FREE'
                                      : '\$' '${bookList[index]['price']}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
            const BottomBar(),
          ],
        ),
      ),
    );
  }

  void searchSellerBooks(String searchEntry, List bookList) {}
}
