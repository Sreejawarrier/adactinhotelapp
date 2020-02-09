import 'package:flutter/material.dart';

class Book extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookState();
}

class _BookState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Book'),
      ),
    );
  }
}
