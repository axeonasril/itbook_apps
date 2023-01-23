import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:tugas2_bootcamp/controllers/book_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
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
  bool expanded = false;
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text(
          "DETAIL BOOK",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.share,
          ),
          SizedBox(
            width: 15,
          )
        ],
        elevation: 0,
      ),
      body: Consumer<BookController>(builder: (context, controller, child) {
        return controller.detailBook == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.detailBook!.title!,
                                  maxLines: 1,
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
                                      Icons.star_outlined,
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
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
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
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Year",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff939393),
                              ),
                            ),
                            Text(controller.detailBook!.year!)
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Language",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff939393),
                              ),
                            ),
                            Text(controller.detailBook!.language!)
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Pages",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff939393),
                              ),
                            ),
                            Text(controller.detailBook!.pages!)
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Publisher",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff939393),
                              ),
                            ),
                            Text(controller.detailBook!.publisher!)
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          text: expanded == false
                              ? controller.detailBook!.desc!
                                          .toString()
                                          .replaceAll('<p>', '')
                                          .replaceAll('</p>', ' ')
                                          .length <
                                      20
                                  ? controller.detailBook!.desc!
                                      .toString()
                                      .replaceAll('<p>', '')
                                      .replaceAll('</p>', ' ')
                                  : '${controller.detailBook!.desc!.toString().replaceAll('<p>', '').replaceAll('</p>', '').substring(0, 50)}...'
                              : controller.detailBook!.desc!
                                  .toString()
                                  .replaceAll('<p>', '')
                                  .replaceAll('</p>', ' '),
                          style: const TextStyle(
                              color: Color(0xff939393),
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text:
                                  expanded == false ? 'Read More' : 'Read Less',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    expanded = !expanded;
                                  });
                                },
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.blue[800]),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800]),
                        onPressed: () async {
                          Uri uri = Uri.parse(controller.detailBook!.url!);
                          try {
                            (await canLaunchUrl(uri))
                                ? launchUrl(uri)
                                : debugPrint("Gagal Navigasi");
                          } catch (e) {
                            debugPrint("error");
                          }
                        },
                        child: const Text(
                          "BUY NOW",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ANOTHER BOOK",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        controller.similiarBooks == null
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      controller.similiarBooks!.books!.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final current =
                                        controller.similiarBooks!.books![index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                current.title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
