import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/models/users.dart';
import 'package:masterreads/viewModel/reviewsViewModel.dart';
import 'package:masterreads/views/books/bookDetail.dart';
import 'package:shimmer/shimmer.dart';

class Review extends StatefulWidget {
  Review({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final BookDetail widget;

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  List reviews = [], user = [];
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    getReview();
  }

  Future getReview() async {
    dynamic data = await ReviewsViewModel().getReview(widget.widget.bookId);

    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        reviews = data;
      });
    }
    dynamic users = await eUserModel().getUserReview(reviews);

    if (users == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        user = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        right: 25,
        bottom: 25,
      ),
      child: Container(
        child: Stack(
          children: [
            _isLoading == true ? loader() : Container(),
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _isLoading ? 0 : reviews.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${user[index]['firstName']} ${user[index]['secondName']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBarIndicator(
                              rating: reviews[index]['rating'].toDouble(),
                              itemBuilder: (index, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 25,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              '${reviews[index]['rating'].toDouble()}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          '${reviews[index]['review']}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loader() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Name',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
