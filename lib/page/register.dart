import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:warnalertwithme/constant.dart';

class RegisterPage extends StatelessWidget {
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 10),
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
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
                            Icons.email,
                            color: kFontGrey3,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            obscureText: true,
                            decoration: customInputDecoration.copyWith(
                              hintText: 'E-mail',
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
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 50,
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement login functionality
                      },
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
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
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Implement sign-in navigation
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
