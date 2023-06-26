import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      appBar: AppBar(
        title: const Text('User Profile'),
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
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(userData?['profile_image'] ?? ''),
                  ),
                  title: Row(
                    children: [
                      Text(userData?['username'] ?? ''),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _showEditUsernameModal,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: pins.length != 0,
                    replacement: const Center(
                        child: Text(
                            'No posts')), //Change to something else, This will show when users did not yet create pins or posts
                    child: ListView.builder(
                      itemCount: pins.length,
                      itemBuilder: (context, index) {
                        final pin = pins[index];
                        return ListTile(
                          title: Text(pin['location_name']),
                          subtitle: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pin['posts'].length,
                            itemBuilder: (context, index) {
                              final post = pin['posts'][index];
                              return ListTile(
                                leading: Image.network(post['post_image']),
                                title: Text(post['post_detail']),
                              );
                            },
                          ),
                        );
                      },
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
