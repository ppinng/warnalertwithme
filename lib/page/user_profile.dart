import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  TextEditingController _usernameController = TextEditingController();
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
        _userData?.then((data) {
          setState(() {
            _usernameController = data['user']['username'];
          });
        });
        print(_usernameController.text);
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
          backgroundColor: const Color(0xFFE0F4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text('Edit Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: 'Enter new username'),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0), // Adjust the padding
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffE36571),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style:
                        TextStyle(fontSize: 13.0), // Set the desired font size
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateUsername(_usernameController.text);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0), // Adjust the padding
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xff4D8CFE),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style:
                        TextStyle(fontSize: 13.0), // Set the desired font size
                  ),
                ),
              ],
            ),
          ],
          // title: const Text('Edit Username'),
          // content: TextField(
          //   controller: _usernameController,
          //   decoration: const InputDecoration(hintText: 'Enter new username'),
          // ),
          // actions: [
          //   TextButton(
          //     child: const Text('Cancel'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   TextButton(
          //     child: const Text('Update'),
          //     onPressed: () {
          //       _updateUsername(_usernameController.text);
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
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

  UploadTask? uploadTask;
  PlatformFile? pickedFile;

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      return null;
    }
  }

  void uploadUserImage(PlatformFile? pickedFile) async {
    try {
      final userId = widget.userWhoLoggedIn;
      final url = 'http://10.0.2.2:3000/api/profile/image/$userId';

      if (pickedFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');

        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
        );

        uploadTask = storageRef.putFile(
          File(pickedFile.path!),
          metadata,
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return const AlertDialog(
                  backgroundColor: Color(0xFFE0F4FF),
                  title: Text("Uploading Image"),
                  content: SizedBox(
                    width: 140,
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            );
          },
        );

        uploadTask!.whenComplete(() {
          Navigator.pop(context); // Close the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                backgroundColor: Color(0xFFE0F4FF),
                title: Text("Upload Completed"),
                content: SizedBox(
                  width: 140,
                  height: 100,
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                  ),
                ),
              );
            },
          );
          // Close the completion message after 2 seconds
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        });
        final TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
        final downloadURL = await snapshot.ref.getDownloadURL();

        // Send the PUT request to update the image
        http.Response response = await http.put(
          Uri.parse(url),
          body: {
            'profile_image': downloadURL,
          },
        );

        // Check the response status code
        if (response.statusCode == 200) {
          print('User Image updated successfully');
        } else {
          print(
              'Failed to update the User Image. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      final errorMessage = error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage, // Display the error message received from the server
            style: const TextStyle(color: Colors.red),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
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
      drawer: const Drawer(
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
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            maxRadius: 55,
                            backgroundImage:
                                NetworkImage(userData?['profile_image'] ?? ''),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width:
                                  36, // Adjust the width here (decrease the value)
                              height:
                                  36, // Adjust the height here (decrease the value)
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff767676),
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                iconSize: 17,
                                icon:
                                    const FaIcon(FontAwesomeIcons.penToSquare),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 224, 244, 255),
                                            title:
                                                const Text("Upload Your Image"),
                                            content: SingleChildScrollView(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    if (pickedFile != null)
                                                      SizedBox(
                                                        width: 120,
                                                        height: 120,
                                                        child: Container(
                                                          color:
                                                              Colors.blue[100],
                                                          child: Image.file(
                                                            File(pickedFile!
                                                                .path!),
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Align(
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all<
                                                                        Color>(
                                                                    const Color(
                                                                        0xff4D8CFE)),
                                                          ),
                                                          onPressed: () async {
                                                            await selectFile();
                                                            setState(() {});
                                                          },
                                                          child: const Text(
                                                              '   Select Image   '),
                                                        ),
                                                      ),
                                                    if (pickedFile != null)
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty.all<
                                                                      Color>(
                                                                  const Color(
                                                                      0xff4D8CFE)),
                                                        ),
                                                        onPressed: () async {
                                                          uploadUserImage(
                                                              pickedFile);
                                                          setState(() {
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 1),
                                                                () {
                                                              _fetchUserData();
                                                              setState(() {
                                                                pickedFile =
                                                                    null;
                                                              });
                                                            });
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Upload'),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        pickedFile = null;
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Close',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF4D8CFE)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
                              icon: const Icon(Icons.border_color),
                              onPressed: _showEditUsernameModal,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
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
                                        color: const Color(0xff76767676),
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
                                                style: const TextStyle(
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
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF767676),
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
