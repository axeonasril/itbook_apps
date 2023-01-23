import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tugas2_bootcamp/controllers/book_controller.dart';
import 'package:tugas2_bootcamp/models/book_list_response.dart';
import 'package:tugas2_bootcamp/views/detail_book_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Catalogue"),
        centerTitle: true,
      ),
      body: Consumer<BookController>(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        builder: (context, controller, child) => Container(
          child: bookController!.bookList == null
              ? child
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookController!.bookList!.books!.length,
                  itemBuilder: (context, index) {
                    final currentBook = bookController!.bookList!.books![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailBookPage(
                            isbn: currentBook.isbn13!,
                          ),
                        ));
                      },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(
                              currentBook.image!,
                              height: 100,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentBook.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      currentBook.subtitle!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        currentBook.price!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
