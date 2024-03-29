// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warnalertwithme/constant.dart';
import 'package:warnalertwithme/page/register.dart';
import 'package:warnalertwithme/page/resetpassword.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:warnalertwithme/screen/pages/gMap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (_usernameController.text.isNotEmpty &&
        _passController.text.isNotEmpty) {
      var reqBody = {
        "username": _usernameController.text,
        "pass": _passController.text
      };

      String url = 'http://10.0.2.2:3000/api/auth/login';

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );
      final BuildContext dialogContext =
          context; // Store the context in a local variable
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        print('Token: $myToken');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
      } else {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(
            content: Text(
              jsonResponse[
                  'message'], // Display the error message received from the server
              style: const TextStyle(color: Colors.red),
            ),
            duration: const Duration(seconds: 3),
          ),
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
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 70, bottom: 90, left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/Logo.png',
                    width: 200,
                    height: 200,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Text(
                      'WarnAlert',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Please sign in to continue',
                      style: TextStyle(fontSize: 16, color: kFontGrey1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 291,
                      height: 55,
                      decoration: blueBoxDecoration,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.key,
                              color: kFontGrey3,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _passController,
                              obscureText: true,
                              decoration: customInputDecoration.copyWith(
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 25,
                        right: 20,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Reset password?',
                          style: TextStyle(
                            color: kFontGrey1,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 130,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_usernameController.text.isEmpty &&
                                _passController.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter your username",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (_usernameController.text.isNotEmpty &&
                                _passController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter password",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (_isNotValidate) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter username and password",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              loginUser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor:
                                kButtonColorBlue, // Set the button's background color
                          ),
                          child: const Text(
                            'Login',
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: kFontGrey1,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
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
