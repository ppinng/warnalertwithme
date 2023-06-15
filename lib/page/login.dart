import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:warnalertwithme/constant.dart';
import 'package:warnalertwithme/page/register.dart';
import 'package:warnalertwithme/page/resetpassword.dart';
//import 'package:warnalertwithme/page/home_screen.dart';

class LoginPage extends StatelessWidget {

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
      body: Container(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      'images/Logo.png',
                      width: 200,
                      height: 200,
                    ),
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
                      padding: const EdgeInsets.only(top: 5, bottom: 15, right: 20), // Adjust the padding here
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(),
                              
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                            //actually have to link to homescreenpage
                          ),
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement login functionality
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
                      ),
                    ),
                  ),
                ],
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
                                builder: (context) => RegisterPage(),
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
      ),
    );
  }
}
