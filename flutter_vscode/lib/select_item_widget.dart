import 'package:books_app/authors_list_page.dart';
import 'package:books_app/books_list_page.dart';
import 'package:books_app/genre_list_page.dart';
import 'package:books_app/publishers_list_page.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'author.dart';
import 'publisher.dart';
import 'genre.dart';
import 'book.dart';

class SelectItemWidget extends StatefulWidget {
  @override
  _SelectItemWidgetState createState() => _SelectItemWidgetState();
}

class _SelectItemWidgetState extends State<SelectItemWidget> {
  String selectedItem = "";
  final List<String> options = [
    "Manage Authors",
    "Manage Publishers",
    "Manage Genres",
    "Manage Books"
  ];

  void navigateToAuthorsList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthorsListPage(
        refreshAuthorsList: () {},
        onAuthorSelected: (Author author) {},
      )),
    );
  }

  void navigateToPublishersListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PublishersListPage(
        refreshPublishersList: () {},
        onPublisherSelected: (Publisher publisher) {}
      )),
    );
  }

  void navigateToGenreListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GenreListPage(
       refreshGenresList: () {},
       onGenreSelected: (Genre genre) {}
      )),
    );
  }

  void navigateToBooksListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BooksListPage(
        refreshBooksList: () {},
        onBookSelected: (Book book) {}
      )),
    );
  }

  Future<bool> showLogoutDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to logout?'),
          content: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    )?? false;
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Select Item',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  wordSpacing: 2,
                  letterSpacing: 2,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: options.map((option) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = option;
                  });
                  switch (selectedItem) {
                    case "Manage Authors":
                      navigateToAuthorsList();
                      break;
                    case "Manage Publishers":
                      navigateToPublishersListPage();
                      break;
                    case "Manage Genres":
                      navigateToGenreListPage();
                      break;
                    case "Manage Books":
                      navigateToBooksListPage();
                      break;
                  }
                },
                child: Container(
                  height: 50,
                  color: selectedItem == option? Colors.blue[700] : Colors.grey[600],
                  child: Center(child: Text(option)),
                ),
              )).toList(),
            ),
          ),
        ),
        Positioned(
  top: 10,
  right: 10,
  child: FloatingActionButton(
    onPressed: () async {
      bool shouldLogout = await showLogoutDialog();
      if (shouldLogout) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    },
    tooltip: 'Logout',
    child: Text('Log out'),
  ),
),
    ],
    ),
  );
}
}
