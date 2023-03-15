import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBookPage extends StatefulWidget {
  final Map? book;
  const AddBookPage({super.key, this.book});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController bookNameController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final book = widget.book;
    if (book != null) {
      isEdit = true;
      final bookName = book["name"];
      bookNameController.text = bookName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Book Page" : "Add book Page"),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          TextField(
            controller: bookNameController,
            decoration: InputDecoration(hintText: "Enter Book Name"),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? editBook : addBook,
            child: Text(isEdit ? "Edit Book" : "Add New Book"),
          ),
        ],
      ),
    );
  }

  Future<void> addBook() async {
    final bookname = bookNameController.text;

    final body = {
      "name": bookname,
    };

    print(bookname);

    final url = "https://6411fb156e3ca31753037e18.mockapi.io/BookStore/";
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      bookNameController.text = "";
      print("data Creation sucess");
      print(response.body);
    } else {
      print("data Creation Failed");
      print(response.body);
    }
  }

  Future<void> editBook() async {
    final book = widget.book;
    if (book == null) {
      print("You cannot call Updated method without book");
      return;
    }
    final id = book["id"];

    final name = bookNameController.text;

    final body = {
      "name": name,
    };

    final url = "https://6411fb156e3ca31753037e18.mockapi.io/BookStore/$id";
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      bookNameController.text = "";
      print("Updation Success");
      print(response.body);
    } else {
      print("Updation Failed");
      print(response.body);
    }
  }
}
