import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas2_bootcamp/controllers/book_controller.dart';
import 'package:tugas2_bootcamp/views/book_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BookListPage(),
      ),
    );
  }
}
