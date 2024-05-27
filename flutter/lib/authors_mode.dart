import 'package:flutter/material.dart';
import 'author.dart'; 
import 'authors_list_page.dart'; 

class AuthorsMode extends StatefulWidget{
  @override
  _AuthorsModeState createState() => _AuthorsModeState();
}

class _AuthorsModeState extends State<AuthorsMode> {

   void refreshAuthorsList() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.deepPurple, Colors.green],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Authors Mode'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthorsListPage(refreshAuthorsList: refreshAuthorsList)),
              );
            },
            child: Text('Download a list of existing authors'),
          ),
        ),
      ),
    );
  }
}
