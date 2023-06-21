import 'package:flutter/material.dart';
import 'package:warnalertwithme/constant.dart';
import 'package:warnalertwithme/page/createpassword.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

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
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Fill in an Email to reset password',
                      style: TextStyle(fontSize: 16, color: kFontGrey1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                  SizedBox(
                    height: 50,
                    width: 130,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreatePasswordPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor:
                                kButtonColorBlue, // Set the button's background color
                          ),
                          child: const Text(
                            'Next',
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
          // Padding(
          //   padding: const EdgeInsets.all(30.0),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: RichText(
          //       text: TextSpan(
          //         text: 'Don\'t have an account? ',
          //         style: const TextStyle(
          //           fontSize: 13,
          //           color: kFontGrey1,
          //         ),
          //         children: <TextSpan>[
          //           TextSpan(
          //             text: 'Sign in',
          //             style: const TextStyle(
          //               fontSize: 13,
          //               color: Colors.blue,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             recognizer: TapGestureRecognizer()
          //               ..onTap = () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => LoginPage(),
          //                   ),
          //                 );
          //               },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}