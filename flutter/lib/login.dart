import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Importy dla stron
import 'author.dart'; 
import 'add_author_page.dart'; 
import 'authors_list_page.dart'; 
import 'publisher.dart';
import 'add_publisher_page.dart';
import 'publishers_list_page.dart';
import 'genre.dart';
import 'add_genre_page.dart';
import 'genre_list_page.dart';
import 'contact_support_page.dart';
import'reset_password_page.dart';
import 'book.dart';
import 'books_list_page.dart';
import 'add_book_page.dart';
import 'authors_mode.dart';
import 'publishers_mode.dart';
import 'genres_mode.dart';
import 'books_mode.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showLoginOptions = false;
  bool _isLoggedIn = false;
  String selectedItem = "Select Item";

  Future<Map<String, dynamic>> _login(String username, String password) async {
    final url = Uri.parse('http://localhost:8080/login');
    final String credentials = '$username:$password';
    final String basicAuth = 'Basic '+ base64Encode(utf8.encode(credentials));

    final response = await http.post(
      url,
      headers: {"Authorization": basicAuth},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('message')) {
        return responseData;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      if (errorData.containsKey('message')) {
        String errorMessage = errorData['message'];
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error');
      }
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.deepPurple, Colors.green],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconWithCircle(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    _inputField("Username", usernameController),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    _inputField("Password", passwordController, isPassword: true),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    _loginButton(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    if (_isLoggedIn)
                    _afterLoginOptions(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _iconWithCircle() {
  return DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 8.0, style: BorderStyle.solid),
      shape: BoxShape.circle,
      color: Colors.transparent, 
    ),
    child: Padding(  
      padding: EdgeInsets.all(20.0), 
      child: Icon(Icons.person_outline, color: Colors.white, size: 32.0),
    ),
  );
}



Widget _icon(double circleRadius) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 2.0),
      shape: BoxShape.circle,
    ),
    child: SizedBox(
      width: circleRadius + 40.0, 
      height: circleRadius + 40.0, 
      child: Icon(Icons.person_2, color: Colors.white, size: circleRadius * 0.7),
    ),
  );
}





Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(19),
    borderSide: const BorderSide(color: Colors.white),
  );

  return FittedBox(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.03),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.02),
          enabledBorder: border,
          focusedBorder: border,
          contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.002, horizontal: MediaQuery.of(context).size.width * 0.035),
          isDense: true,
        ),
        obscureText: isPassword,
      ),
    ),
  );
}




 Widget _loginButton() {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.25,
    child: ElevatedButton(
      onPressed: () async {
        try {
          String username = usernameController.text;
          String password = passwordController.text;

          final responseData = await _login(username, password);

          if (responseData.containsKey('error')) {
            _handleFailedLogin(Exception('Login failed'));
            return;
          }

          final message = responseData['message'];
          final backgroundColor = Colors.green;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: backgroundColor,
            ),
          );

          _handleSuccessfulLogin(responseData);
        } on Exception catch (e) {
          _handleFailedLogin(e);
        }
      },
      child: Text(
        "Login",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        textStyle: TextStyle(
          fontSize: 18.0,
        ),
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      ),
    ),
  );
}



Widget _afterLoginOptions() {
  List<String> listItems = [
    "Manage Authors",
    "Manage Publishers",
    "Manage Genres",
    "Manage Books"
  ];

  List<String> dropdownListItems = ["Select Item"]..addAll(listItems);

  List<DropdownMenuItem<String>> dropdownItems = dropdownListItems
     .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Container(
              alignment: Alignment.center,
              child: Text(item, style: TextStyle(color: Colors.blue[800])),
            ),
          ))
     .toList();

  String selectedItem = "";

  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: 200,
                      maxWidth: 350,
                      minHeight: 40,
                      maxHeight: 50),
                  width: 200,
                  height: 40,
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
                    hint: Text("Select Item",
                        style: TextStyle(color: Colors.blue[800])),
                    onChanged: (String? newValue) {
                      if (newValue!= null && newValue!= "Select Item") {
                        setState(() {
                          selectedItem = newValue;
                        });
                        switch (selectedItem) {
                          case "Manage Authors":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AuthorsMode()),
                            );
                            break;
                          case "Manage Publishers":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PublishersMode()),
                            );
                            break;
                          case "Manage Genres":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GenresMode()),
                            );
                            break;
                          case "Manage Books":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BooksMode()),
                            );
                            break;
                        }
                      }
                    },
                    items: dropdownItems,
                  ),
                ),
              ),
            ),
          ),
          if (_showLoginOptions)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _logout,
                child: Text('Log out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}


   void _logout() {
    usernameController.clear();
    passwordController.clear();
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _handleSuccessfulLogin(Map<String, dynamic> responseData) {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleFailedLogin(Exception exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exception.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}
