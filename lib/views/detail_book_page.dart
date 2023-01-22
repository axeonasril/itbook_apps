import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas2_bootcamp/models/book_detail_response.dart';
import 'package:tugas2_bootcamp/views/image_view_screen.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
  }) : super(key: key);
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;
  fetchDetailBookApi() async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    // ignore: unused_local_variable
    var response = await http.get(url);

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Buku"),
        centerTitle: true,
      ),
      body: detailBook == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageViewScreen(imageUrl: detailBook!.image!),
                          ),
                        );
                      },
                      child: Image.network(
                        detailBook!.image!,
                        height: 100,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(detailBook!.title!),
                            Text(detailBook!.subtitle!),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Text(detailBook!.price!),
                Text(detailBook!.isbn10!),
                Text(detailBook!.isbn13!),
                Text(detailBook!.pages!),
                Text(detailBook!.authors!),
                Text(detailBook!.publisher!),
                Text(detailBook!.desc!),
                Text(detailBook!.rating!),
              ],
            ),
    );
  }
}
