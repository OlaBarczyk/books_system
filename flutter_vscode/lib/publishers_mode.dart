import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'publisher.dart';
import 'publishers_list_page.dart';

class PublishersMode extends StatefulWidget {
  @override
  _PublishersModeState createState() => _PublishersModeState();
}

class _PublishersModeState extends State<PublishersMode> {

  Future<void> refreshPublishersList() async {
    final String url = 'http://localhost:8080/getPublishers';
    final String basicAuth = 'test:123456'; // Basic Auth credentials
    final String token = "Basic dGVzdDoxMjM0NTY=";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        List<dynamic> publishersJson = json.decode(response.body);
        List<Publisher> publishers = publishersJson.map((json) => Publisher.fromJson(json)).toList();

        // Navigate to PublishersListPage with the required parameters
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PublishersListPage(
            refreshPublishersList: refreshPublishersList,
            onPublisherSelected: (Publisher publisher) {}, // Provide a function if needed
            //publishers: publishers, // Pass the list of publishers
          )),
        );
      } else {
        throw Exception('Failed to load publishers, ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
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
              refreshPublishersList(); 
            },
            child: Text('Download a list of existing publishers'),
          ),
        ),
      ),
    );
  }
}
