import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'select_item_widget.dart';
import 'register.dart';


class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showLoginOptions = false;
  bool _isLoggedIn = false;
  String selectedItem = "Select Item";
  bool showSelectItem = false;

 Future<Map<String, dynamic>> _login(String login, String password) async {
  final url = Uri.parse('http://localhost:8080/login/login');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'login': login,
      'password': password,
    }),
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
      print(errorData);
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 400),
                    _iconWithCircle(),
                    SizedBox(height: 20),
                    _inputField("Login", loginController),
                    SizedBox(height: 20),
                    _inputField("Password", passwordController, isPassword: true),
                    SizedBox(height: 20),
                    _loginButton(),
                    SizedBox(height: 20),
                    _registerButton(),
                    SizedBox(height: 20),
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
  double buttonWidth = MediaQuery.of(context).size.width * 0.32;
  double buttonHeight = 25;

  return SizedBox(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () async {
        try {
          String login = loginController.text;
          String password = passwordController.text;

          final responseData = await _login(login, password);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.zero,
        textStyle: TextStyle(
          fontSize: 18.0,
        ),
      ),
    ),
  );
}



   void _logout() {
    loginController.clear();
    passwordController.clear();
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _handleSuccessfulLogin(Map<String, dynamic> responseData) {
    setState(() {
      _isLoggedIn = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SelectItemWidget()),
      );
  }

  void _handleFailedLogin(Exception exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exception.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
  Widget _registerButton(){
   double buttonWidth = MediaQuery.of(context).size.width * 0.32; 
  double buttonHeight = 25;

  return SizedBox(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () async {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );
      },
      child: Text(
        "If you don't have an account, please register.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.zero,
        textStyle: TextStyle(
          fontSize: 18.0,
        ),
      ),
    ),
  );
  }
}


