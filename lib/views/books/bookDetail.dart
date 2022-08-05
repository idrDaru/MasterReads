import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/models/book.dart';
import 'package:masterreads/models/bookTags.dart';
import 'package:masterreads/viewModel/bookTagsViewModel.dart';
import 'package:masterreads/viewModel/reviewsViewModel.dart';
import 'package:masterreads/views/books/book_detail_widget/description.dart';
import 'package:masterreads/views/books/book_detail_widget/review.dart';
import 'package:masterreads/views/books/book_detail_widget/similar.dart';
import 'package:masterreads/views/books/edit_book_screen/edit_book_screen.dart';
import 'package:masterreads/widgets/customTabIndicator.dart';
import 'package:share/share.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({
    super.key,
    required this.bookId,
    required this.userId,
    required this.coverUrl,
    required this.title,
    required this.author,
    required this.price,
    required this.description,
  });

  final String bookId, userId, coverUrl, title, author, description, price;

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail>
    with SingleTickerProviderStateMixin {
  int _tabSelected = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tab.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabSelected = _tabController.index;
      });
    });
  }

  getBookDetail() async {
    final data = await Book().getBookDetail(widget.userId, widget.bookId);
    if (data.isNotEmpty == true) {
      return data;
    } else if (data.isNotEmpty == false) {
      return null;
    }
  }

  addToCartDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Add to my cart"),
      onPressed: () async {
        try {
          var add = await BookTagsViewModel.addBookTags(
            BookTags(
                bookId: widget.bookId,
                buyerId: widget.userId,
                isPurchased: false),
          );
          if (add != null) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: "Book successfully added to your cart.",
              toastLength: Toast.LENGTH_LONG,
            );
          } else {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: "The book is already in your cart.",
              toastLength: Toast.LENGTH_LONG,
            );
          }
        } catch (e) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Error occured. Please try again later.",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Would you like to add this book to your cart ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> addToCart() async {
    await BookTagsViewModel.addBookTags(
      BookTags(
          bookId: widget.bookId, buyerId: widget.userId, isPurchased: false),
    );
  }

  List<Widget> tab = [
    Tab(
      child: Container(
        margin: const EdgeInsets.only(right: 39),
        child: const Text('Description'),
      ),
    ),
    Tab(
      child: Container(
        margin: const EdgeInsets.only(right: 39),
        child: const Text('Reviews'),
      ),
    ),
    Tab(
      child: Container(
        margin: const EdgeInsets.only(right: 39),
        child: const Text('Similar'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 25,
        ),
        height: 49,
        color: Colors.transparent,
        child: FutureBuilder(
          future: getBookDetail(),
          builder: ((context, snapshot) {
            return TextButton(
              onPressed: () {
                if (snapshot.data != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditBookScreen(
                        id: widget.bookId,
                      ),
                    ),
                  );
                } else if (snapshot.data == null) {
                  addToCartDialog(context);
                }
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => kPrimaryColor)),
              child: Text(
                snapshot.data == null ? 'Add to cart' : 'Edit Book',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white),
              ),
            );
            // ignore: dead_code
            return TextButton(
              onPressed: () {
                Share.share(
                    'check out master book https://masterreads.page.link/Sohr');
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => kPrimaryColor)),
              child: Text(
                snapshot.data == null ? 'Share The book' : 'Share The book',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white),
              ),
            );
          }),
        ),
        // TextButton(
        //   onPressed: () {},
        //   style: ButtonStyle(
        //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       ),
        //       backgroundColor:
        //           MaterialStateProperty.resolveWith((states) => kPrimaryColor)),
        //   child: const Text(
        //     'Add to library',
        //     style: TextStyle(
        //         fontFamily: 'Poppins',
        //         fontWeight: FontWeight.w600,
        //         fontSize: 14,
        //         color: Colors.white),
        //   ),
        // ),
      ),

      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: kAccentColor,
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: kPrimaryColor,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 62),
                          width: 300,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.coverUrl),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 25,
                    ),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 27,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 25,
                    ),
                    child: Text(
                      widget.author,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 25,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.price == '0' ? '' : '\$',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.price == '0' ? 'FREE' : '${widget.price}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                            padding: EdgeInsets.fromLTRB(240.0, 0, 0, 0),
                            onPressed: () {
                              Share.share(
                                  'check out master book https://masterreads.page.link/Sohr');
                            },
                            icon: const Icon(Icons.share)),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(
                      left: 25,
                    ),
                    child: Scaffold(
                      appBar: TabBar(
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
                          width: 30,
                          color: Colors.black,
                        ),
                        controller: _tabController,
                        onTap: ((index) {}),
                        tabs: tab,
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          Description(widget: widget),
                          Review(widget: widget),
                          Similar(widget: widget),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
