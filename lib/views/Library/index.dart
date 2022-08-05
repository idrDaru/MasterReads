import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/models/book.dart';
import 'package:masterreads/viewModel/reviewsViewModel.dart';
import 'package:masterreads/views/navigation/navigationBuyer.dart';
import 'package:masterreads/views/review/AddReview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final buyerId = FirebaseAuth.instance.currentUser!;
  List bookList = [];
  bool isRated = false;

  @override
  void initState() {
    super.initState();
    getBookList();
  }

  getBookList() async {
    dynamic data = await Book().getLibrary(buyerId.uid);

    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        bookList = data;
      });
    }
    print(bookList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationBuyerDrawerWidget(),
      appBar: AppBar(
        title: const Text('MasterEreads'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'My Books',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: const Divider(
                thickness: 2.5,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: bookList.length,
              itemBuilder: ((context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 50,
                    right: 50,
                  ),
                  height: 100,
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 71,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(
                                '${bookList[index]['coverPhotoUrl']}',
                              ),
                              fit: BoxFit.fill),
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${bookList[index]['title'].length > 27 ? bookList[index]['title'].substring(0, 27) + '...' : bookList[index]['title']}',
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: (() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) => AddReview(
                                              bookId: bookList[index]['id'],
                                              userId: buyerId.uid,
                                              coverUrl: bookList[index]
                                                  ['coverPhotoUrl'],
                                              title: bookList[index]['title'],
                                              author: bookList[index]['author'],
                                            )),
                                      ),
                                    );
                                  }),
                                  child: Text(
                                    'My Review',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: (() => openFile(
                                        url: '${bookList[index]['pdfUrl']}',
                                        fileName:
                                            '${bookList[index]['title']}.pdf',
                                      )),
                                  child: const Text(
                                    'Open Book',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final fileStorage = await getApplicationDocumentsDirectory();
    final file = File('${fileStorage.path}/$name');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
