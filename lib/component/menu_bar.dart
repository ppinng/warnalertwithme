// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warnalertwithme/page/login.dart';
import 'package:warnalertwithme/screen/pages/gMap.dart';
import '../page/user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DrawerBar extends StatefulWidget {
  const DrawerBar({Key? key}) : super(key: key);

  @override
  State<DrawerBar> createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  SharedPreferences? prefs;
  var myToken;
  var userWhoLoggedIn;
  var userIdlogin;
  String? username;
  String? profileImage;

  Future<void> fetchUserData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/imageuser/$userIdlogin'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          username = data['user']['username'];
          profileImage = data['user']['profile_image'];
        });
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other error
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs?.getString('token');
    myToken = token;
    extractUserIdFromToken();
  }

  void extractUserIdFromToken() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(myToken);

    // Assuming the user ID is stored in the 'user_id' claim of the token
    userWhoLoggedIn = decodedToken['user_id'];
    userIdlogin = decodedToken['user_id'];
    fetchUserData();
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 40, 0, 0),
      child: ListView(
        children: [
          if (profileImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: CircleAvatar(
                maxRadius: 70,
                backgroundImage: NetworkImage(profileImage ?? ''),
              ),
            ),
          if (username != null) // Check if username is available
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                username!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff4D8CFE),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.house),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
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
            title: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
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
              title: const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                logoutUser(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
