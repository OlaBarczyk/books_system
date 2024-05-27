import 'package:flutter/material.dart';
import 'genre.dart'; 
import 'genre_list_page.dart'; 

class GenresMode extends StatefulWidget{
 @override
 _GenresModeState createState() => _GenresModeState();
}

class _GenresModeState extends State<GenresMode> {

   void refreshGenresList() {
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
          title: Text('Genres Mode'),
          backgroundColor: Colors.transparent, 
          elevation: 0.0,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => GenreListPage(
                  refreshGenresList: refreshGenresList,
                 )),
               );
            },
            child: Text('Download a list of existing genres'),
          ),
        ),
      ),
    );
 }
}
