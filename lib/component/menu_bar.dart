// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warnalertwithme/page/login.dart';
import 'package:warnalertwithme/screen/pages/gMap.dart';
import '../page/user_profile.dart';

class DrawerBar extends StatefulWidget {
  const DrawerBar({Key? key}) : super(key: key);

  @override
  State<DrawerBar> createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  SharedPreferences? prefs;
  var myToken;
  var userWhoLoggedIn;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    Future.delayed(const Duration(seconds: 1), () {
      extractUserIdFromToken();
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs?.getString('token');
    myToken = token;
  }

  void extractUserIdFromToken() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(myToken);

    // Assuming the user ID is stored in the 'user_id' claim of the token
    userWhoLoggedIn = decodedToken['user_id'];
  }

  void logoutUser(BuildContext context) async {
    if (mounted && prefs != null) {
      // Remove the token from shared preferences or any other storage
      prefs!.remove('token');

      // Navigate to the login screen or any other desired screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CircleAvatar(),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MapScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.user),
          title: const Text('Profile'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  userWhoLoggedIn: userWhoLoggedIn,
                ),
              ),
            );
            //print('User id: $userWhoLoggedIn');
          },
        ),
        Builder(
          builder: (context) => ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            title: const Text('Log out'),
            onTap: () {
              logoutUser(context);
            },
          ),
        ),
      ],
    );
  }
}
