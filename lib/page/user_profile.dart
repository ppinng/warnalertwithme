import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:warnalertwithme/component/menu_bar.dart';

class UserProfile extends StatefulWidget {
  final dynamic userWhoLoggedIn;
  const UserProfile({Key? key, required this.userWhoLoggedIn})
      : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<Map<String, dynamic>>? _userData;
  Map<String, dynamic>? userData;
  final TextEditingController _usernameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = widget.userWhoLoggedIn;
    final url = Uri.parse('http://10.0.2.2:3000/api/profile/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('user')) {
        setState(() {
          _userData = Future.value(data);
        });
      } else {
        throw Exception('Invalid user data format');
      }
    } else {
      throw Exception(
          'Failed to fetch user data. Status code: ${response.statusCode}');
    }
  }

  void _showEditUsernameModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: 'Enter new username'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                _updateUsername(_usernameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUsername(String newUsername) async {
    final userId = widget.userWhoLoggedIn;
    final url = Uri.parse('http://10.0.2.2:3000/api/profile/$userId');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'username': newUsername,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        setState(() {
          _userData?.then((data) {
            setState(() {
              data['user']['username'] = newUsername;
            });
          });
        });
      } else {
        throw Exception(
            'Failed to update username. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error updating username: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              icon: const FaIcon(FontAwesomeIcons.bars),
              iconSize: 50,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
      ),
      drawer: Drawer(
        child: DrawerBar(),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            userData = snapshot.data!['user'];
            final pins = snapshot.data!['pins'];
            print(pins.length);
            return Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CircleAvatar(
                        maxRadius: 55,
                        backgroundImage:
                            NetworkImage(userData?['profile_image'] ?? ''),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData?['username'] ?? '',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 30, 108, 252),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _showEditUsernameModal,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 25,
                    top: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: pins.length != 0,
                    replacement: const Center(
                        child: Text(
                            'No posts')), //Change to something else, This will show when users did not yet create pins or posts
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: pins.length,
                        itemBuilder: (context, index) {
                          final pin = pins[index];
                          return ListTile(
                            subtitle: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pin['posts'].length,
                              itemBuilder: (context, index) {
                                final post = pin['posts'][index];
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 125,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F4FF),
                                      border: Border.all(
                                        color: Color(0xFF76767676),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              3), // changes the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 17,
                                          left: 15,
                                          child: SizedBox(
                                            width: 120,
                                            height: 91,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: Image.network(
                                                  post[
                                                      'post_image'], // Use post image URL
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      145, 25, 0, 10),
                                              child: Text(
                                                pin['location_name'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      145, 0, 0, 0),
                                              child: Text(
                                                post[
                                                    'post_detail'], // Use post detail
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xFF767676),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No user data found.'));
          }
        },
      ),
    );
  }
}
