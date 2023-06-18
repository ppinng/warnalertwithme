import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../page/homepage.dart';
import '../page/userProfile.dart';

class DrawerBar extends StatefulWidget {
  const DrawerBar({super.key});

  @override
  State<DrawerBar> createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const CircleAvatar(),
      ListTile(
        leading: const FaIcon(FontAwesomeIcons.home),
        title: const Text('Home'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
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
              builder: (context) => const UserProfile(),
            ),
          );
        },
      ),
      const ListTile(
          leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
          title: Text('Log out')),
    ]);
  }
}
