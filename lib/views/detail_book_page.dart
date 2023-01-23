import 'package:provider/provider.dart';
import 'package:tugas2_bootcamp/controllers/book_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas2_bootcamp/models/book_detail_response.dart';
import 'package:tugas2_bootcamp/models/book_list_response.dart';
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
  BookController? controller;
  @override
  void initState() {
    super.initState();
    controller = Provider.of<BookController>(context, listen: false);
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Book"),
        centerTitle: true,
      ),
      body: Consumer<BookController>(builder: (context, controller, child) {
        return controller.detailBook == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                      imageUrl: controller.detailBook!.image!),
                                ),
                              );
                            },
                            child: Image.network(
                              controller.detailBook!.image!,
                              height: 150,
                              fit: BoxFit.cover,
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
                                  Text(
                                    controller.detailBook!.title!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    controller.detailBook!.authors!,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        color: index <
                                                int.parse(controller
                                                    .detailBook!.rating!)
                                            ? Colors.yellow
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    controller.detailBook!.subtitle!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    controller.detailBook!.price!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () async {
                            print("url");
                            Uri uri = Uri.parse(controller.detailBook!.url!);
                            try {
                              (await canLaunchUrl(uri))
                                  ? launchUrl(uri)
                                  : print("Gagal Navigasi");
                            } catch (e) {
                              print("error");
                              print(e);
                            }
                          },
                          child: const Text("BUY"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(controller.detailBook!.desc!),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Year: ${controller.detailBook!.year!}"),
                          Text(controller.detailBook!.isbn13!),
                          Text("${controller.detailBook!.pages!} Pages"),
                          Text(
                              "Publisher: ${controller.detailBook!.publisher!}"),
                          Text("Language: ${controller.detailBook!.language!}"),

                          // Text(detailBook!.rating!),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      controller.similiarBooks == null
                          ? CircularProgressIndicator()
                          : Container(
                              height: 150,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    controller.similiarBooks!.books!.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  final current =
                                      controller.similiarBooks!.books![index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: 150,
                                    child: Card(
                                      elevation: 4,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            current.image!,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              current.title!,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ],
                  ),
                ]),
              );
      }),
    );
  }
}
