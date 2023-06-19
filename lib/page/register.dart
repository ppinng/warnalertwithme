import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:warnalertwithme/constant.dart';
import 'package:warnalertwithme/page/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final String _errorMessage = '';
  bool _isNotValidate = false;
  void _registerUser() async {
    if (_emailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passController.text.isNotEmpty) {
      final String username = _usernameController.text;
      final String email = _emailController.text;
      final String pass = _passController.text;
      Map<String, dynamic> requestBody = {
        'username': username,
        'email': email,
        'pass': pass,
      };
      String url = 'http://10.0.2.2:3000/api/auth/register';

      final BuildContext dialogContext =
          context; // Store the context in a local variable

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Registration successful, navigate to the login page
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          dialogContext, // Use the stored context instead of 'context'
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Registration failed, display an error message
        // ignore: use_build_context_synchronously
        showDialog(
          context: dialogContext, // Use the stored context instead of 'context'
          builder: (context) {
            return AlertDialog(
              title: const Text('Registration Failed'),
              content: const Text('An error occurred during registration.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blueBoxDecoration = BoxDecoration(
      color: kButtonColorLightBlue,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: kFontGrey3,
        width: 1,
      ),
    );

    const customInputDecoration = InputDecoration(
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.grey),
    );

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20),
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Let’s get started !',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Create an account to avail all the features',
                    style: TextStyle(fontSize: 16, color: kFontGrey1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 291,
                        height: 55,
                        decoration: blueBoxDecoration,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.person,
                                color: kFontGrey3,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _usernameController,
                                decoration: customInputDecoration.copyWith(
                                  hintText: 'Username',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          _isNotValidate ? "Please enter your username" : "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 291,
                        height: 55,
                        decoration: blueBoxDecoration,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.email,
                                color: kFontGrey3,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                decoration: customInputDecoration.copyWith(
                                  hintText: 'E-mail',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          _isNotValidate ? "Please enter your Email" : "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 291,
                        height: 55,
                        decoration: blueBoxDecoration,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.email,
                                color: kFontGrey3,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _passController,
                                decoration: customInputDecoration.copyWith(
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          _isNotValidate ? "Please enter your password" : "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 20),
                  child: Container(
                    width: 291,
                    height: 55,
                    decoration: blueBoxDecoration,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.lock,
                            color: kFontGrey3,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            obscureText: true,
                            decoration: customInputDecoration.copyWith(
                              hintText: 'Confirm Password',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                SizedBox(
                  height: 50,
                  width: 130,
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: kButtonColorBlue,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(95.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: kFontGrey1,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign in',
                      style: const TextStyle(
                        fontSize: 13,
                        color: kButtonColorBlue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
