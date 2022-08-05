import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/models/reviews.dart';
import 'package:masterreads/viewModel/reviewsViewModel.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class AddReview extends StatefulWidget {
  const AddReview({
    super.key,
    required this.bookId,
    required this.userId,
    required this.coverUrl,
    required this.title,
    required this.author,
  });

  final String bookId, userId, coverUrl, title, author;

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final _reviewController = TextEditingController();
  double rating = 0, rated = 0;
  bool isRated = false;
  late bool _isLoading;
  List review = [];

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    getSingleReview();
  }

  Future getSingleReview() async {
    dynamic data =
        await ReviewsViewModel().getSingleRate(widget.bookId, widget.userId);

    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        review = data;
        rating = data[0]['rating'].toDouble();
        isRated = true;
      });
    }
    print(data);
  }

  Future<bool> addReview() async {
    var add = await ReviewsViewModel().addReview(
      Reviews(
        id: FirebaseFirestore.instance.collection('reviews').doc().id,
        bookId: widget.bookId,
        rating: rating,
        userId: widget.userId,
        review: _reviewController.text.toString(),
      ),
    );
    if (add == true) {
      setState(() {
        rating = rating;
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Review has been sent! Thank you.",
        toastLength: Toast.LENGTH_LONG,
      );
      return true;
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Cannot Review. You Already Reviewed this book.",
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

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
        child: _isLoading == true
            ? Container()
            : isRated == true
                ? Container()
                : submitReviewButton(),
      ),
      body: SafeArea(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      padding: const EdgeInsets.fromLTRB(25, 24, 0, 0),
                      onPressed: () {
                        Share.share(
                            'check out master book https://masterreads.page.link/Sohr');
                      },
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
                _isLoading == true ? loader() : Container(),
                Container(
                  height: 28,
                  margin: const EdgeInsets.only(
                    top: 23,
                    bottom: 36,
                  ),
                  padding: const EdgeInsets.only(
                    left: 25,
                  ),
                  child: Text(
                    _isLoading == true
                        ? ''
                        : isRated == false
                            ? 'Add Review'
                            : 'My Review',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLoading == true ? '' : 'Rating: $rating',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    _isLoading == true ? Container() : starRate(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  _isLoading == true
                                      ? ''
                                      : isRated == false
                                          ? 'Enter Review'
                                          : 'Review',
                                ),
                              ),
                              const SizedBox(height: 6),
                              _isLoading == true ? Container() : reviewField(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget starRate() {
    if (isRated == true) {
      return RatingBarIndicator(
        rating: rating,
        itemBuilder: (index, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemCount: 5,
      );
    } else {
      return RatingBar.builder(
        minRating: 1,
        itemBuilder: ((context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            )),
        updateOnDrag: true,
        glow: false,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
      );
    }
  }

  Widget reviewField() {
    if (isRated == true) {
      return TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: review[0]['review'].toString(),
          hintStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        minLines: 10,
        maxLines: 10,
      );
    } else {
      return TextFormField(
        initialValue: _reviewController.text,
        decoration: InputDecoration(
          hintText: 'Review',
          hintStyle: TextStyle(fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        minLines: 10,
        maxLines: 10,
        onChanged: (value) {
          setState(() {
            _reviewController.text = value;
          });
        },
      );
    }
  }

  Widget submitReviewButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          addReview();
        } catch (e) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Error occured. Please try again later.",
              toastLength: Toast.LENGTH_LONG);
        }
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => kPrimaryColor)),
      child: const Text(
        'Send Review',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white),
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
          margin: const EdgeInsets.only(
            top: 23,
            bottom: 36,
          ),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'My Review',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
