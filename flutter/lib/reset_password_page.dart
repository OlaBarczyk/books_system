import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
 @override
 _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
 final TextEditingController _emailController = TextEditingController();

 void _sendResetPasswordRequest() {
    final String email = _emailController.text;
    if (email.isEmpty) {
    
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter your email address.'),
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
            title: Text('Succes'),
            content: Text('The password reset request has been sent.'),
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
     
      _emailController.clear();
    }
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please reset your password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter your email address:'),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
              ),
            ),
            ElevatedButton(
              onPressed: _sendResetPasswordRequest,
              child: Text('Send!'),
            ),
          ],
        ),
      ),
    );
 }
}
