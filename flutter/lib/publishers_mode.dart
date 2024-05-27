import 'package:flutter/material.dart';
import 'publisher.dart'; 
import 'publishers_list_page.dart'; 

class PublishersMode extends StatefulWidget{
 @override
 _PublishersModeState createState() => _PublishersModeState();
}

class _PublishersModeState extends State<PublishersMode> {

   void refreshPublishersList() {
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
          title: Text('Publishers Mode'),
          backgroundColor: Colors.transparent, 
          elevation: 0.0,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => PublishersListPage(
                  refreshPublishersList: refreshPublishersList,
                 )),
               );
            },
            child: Text('Download a list of existing publishers'),
          ),
        ),
      ),
    );
 }
}
