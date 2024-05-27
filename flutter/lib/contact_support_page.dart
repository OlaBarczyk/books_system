import 'package:flutter/material.dart';

class ContactSupportPage extends StatefulWidget {
 @override
 _ContactSupportPageState createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
 final TextEditingController _messageController = TextEditingController();

 void _sendMessage() {
    final String message = _messageController.text;
    if (message.isEmpty) {
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter your message.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                 Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Message was sent.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                 Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
     
      _messageController.clear();
    }
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact customer service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Send a message:'),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message',
              ),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
 }
}
