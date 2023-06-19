import 'package:flutter/material.dart';
import 'package:warnalertwithme/constant.dart';
import 'package:warnalertwithme/page/login.dart';

class CreatePasswordPage extends StatelessWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

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
            padding: const EdgeInsets.only(top: 60, left: 20),
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
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Create new password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Your new password must be different \n from previously used passwords.',
                        style: TextStyle(fontSize: 16, color: kFontGrey1),
                        textAlign: TextAlign.center,
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
                    padding: const EdgeInsets.only(top: 20, bottom: 0),
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
                                hintText: 'ConfirmPassword',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Reduced space here
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
                                builder: (context) => const LoginPage(),
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
                            'Confirm',
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
        ],
      ),
    );
  }
}
