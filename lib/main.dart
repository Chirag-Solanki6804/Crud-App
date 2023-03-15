// main.dart file
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_pratical/add_book_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AllBookPage(),
    );
  }
}

class AllBookPage extends StatefulWidget {
  const AllBookPage({super.key});

  @override
  State<AllBookPage> createState() => _AllBookPageState();
}

class _AllBookPageState extends State<AllBookPage> {
  bool isLoading = true;
  List Books = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBooksData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Store"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: Visibility(
          visible: Books.isEmpty,
          child: Center(
            child: Text("No Books"),
          ),
          replacement: ListView.builder(
            itemCount: Books.length,
            itemBuilder: (context, index) {
              final book = Books[index] as Map;
              final bookid = book["id"] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text(book["name"]),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == "edit") {
                        print(value);
                        navigateToEditBookPage(book);
                      } else if (value == "delete") {
                        deleteById(bookid);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: "delete",
                        ),
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: "edit",
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddBookPage,
        label: Text("Add Book"),
      ),
    );
  }

  Future<void> navigateToAddBookPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddBookPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchBooksData();
  }

  Future<void> navigateToEditBookPage(Map book) async {
    final route = MaterialPageRoute(
      builder: (context) => AddBookPage(
        book: book,
      ),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchBooksData();
  }

  Future<void> fetchBooksData() async {
    final url = "https://6411fb156e3ca31753037e18.mockapi.io/BookStore";
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      if (json != null) {
        setState(() {
          Books = json;
        });
      } else {
        print("Data is Null");
      }
    } else {
      print("Something Went Wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final url = "https://6411fb156e3ca31753037e18.mockapi.io/BookStore/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      final filtered = Books.where((element) => element["id"] != id).toList();
      setState(() {
        Books = filtered;
      });
    } else {
      print("Deletion Failed");
    }
  }
}
