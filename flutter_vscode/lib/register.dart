import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';


class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  bool _showRegisterOptions = false;
  bool _isRegistered = false;
  String selectedItem = "Select Item";
  bool showSelectItem = false;

  Future<Map<String, dynamic>> _register(String login, String password, String role) async {
    final url = Uri.parse('http://localhost:8080/register');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "login": login,
        "password": password,
        "role": role
      })
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 400),
                    _iconWithCircle(),
                    SizedBox(height: 20),
                    _inputField("Username", usernameController),
                    SizedBox(height: 20),
                    _inputField("Password", passwordController, isPassword: true),
                    SizedBox(height: 20),
                    _inputField("Role", roleController),
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




 Widget _registerButton() {
  double buttonWidth = MediaQuery.of(context).size.width * 0.32;
  double buttonHeight = 25;

  return SizedBox(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () async {
        try {
          String username = usernameController.text;
          String password = passwordController.text;
          String role = roleController.text;

          final responseData = await _register(username, password, role);

          if (responseData.containsKey('error')) {
            _handleFailedRegister(Exception('Register failed'));
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

          _handleSuccessfulRegister(responseData);
        } on Exception catch (e) {
          _handleFailedRegister(e);
        }
      },
      child: Text(
        "Register",
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


  void _handleSuccessfulRegister(Map<String, dynamic> responseData) {
    setState(() {
      _isRegistered = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
  }

  void _handleFailedRegister(Exception exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exception.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}
