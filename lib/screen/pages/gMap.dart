// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warnalertwithme/component/search.dart';

// Define a Post model class to represent the structure of a post
class Post {
  final String postId;
  final String userId;
  final String pinId;
  final String detail;
  final String image;
  final String postedAt;
  final String timeAgo;

  Post({
    required this.postId,
    required this.userId,
    required this.pinId,
    required this.detail,
    required this.image,
    required this.postedAt,
    required this.timeAgo,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      userId: json['user_id'],
      pinId: json['pin_id'],
      detail: json['post_detail'],
      image: json['post_image'],
      postedAt: json['posted_at'],
      timeAgo: json['time_ago'].toString(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LocationData? _currentLocation;
  bool _editingMode = false;
  Set<Marker> _markers = {};
  Set<Marker> _selectedMarkers = Set<Marker>();
  Set<Marker> _addMarkers = {};
  late SharedPreferences prefs;
  var myToken;
  var userWhoLoggedIn;

  @override
  void initState() {
    initSharedPref();
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
      });
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    getMarkerData();
    Timer.periodic(const Duration(seconds: 30), (_) {
      getMarkerData();
    });
    // extractUserIdFromToken();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    myToken = token;
  }

  void getMarkerData() async {
    final url = 'http://10.0.2.2:3000/api/pins';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pins = data['data'];

      // Create a set to store the new markers
      Set<Marker> newMarkers = {};

      for (var pin in pins) {
        final specify = {
          'latitude': pin['latitude'],
          'longitude': pin['longitude'],
          'address': pin['location_name'],
        };

        final specifyId = pin['pin_id'].toString();

        final markerId = MarkerId(specifyId);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(
            specify['latitude'],
            specify['longitude'],
          ),
          infoWindow: InfoWindow(
            snippet: _editingMode ? 'Click to Delete' : null,
            title: specify['address'],
            onTap: () {
              if (_editingMode) {
                // Find the corresponding marker
                Marker? marker = _markers
                    .firstWhere((marker) => marker.markerId == markerId);

                if (marker != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 224, 244, 255),
                        content: Container(
                          width: 383.0, // Set the desired width
                          height: 90.0, // Set the desired height
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10.0), // Add padding to the bottom
                                child: Text(
                                  'Confirm to remove the marker ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0, // Set the desired font size
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteMarker(specifyId);
                                      getMarkerData();
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal:
                                                45.0), // Adjust the padding
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 33, 150, 243)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize:
                                              13.0), // Set the desired font size
                                    ),
                                  ),
                                  const SizedBox(width: 30.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal:
                                                50.0), // Adjust the padding
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45.0),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                          fontSize:
                                              13.0), // Set the desired font size
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              } else {
                // Find the corresponding marker
                Marker? marker = _markers
                    .firstWhere((marker) => marker.markerId == markerId);
                // fetchPostsByPinId(specifyId);
                print('Retrieved pins id: $specifyId');
                _slidePopup(specifyId, specify['address']);
              }
            },
          ),
          // icon: markerbitmap,
        );

        newMarkers.add(marker);
      }

      setState(() {
        _markers = newMarkers;
      });

      print('Retrieved pins data: $pins');
    } else {
      throw Exception('Failed to retrieve pins data');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController postDetailCon = TextEditingController();

  void _createPostPopup(String desiredPinId, String locationName) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: 350.0,
            height: 455.0,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Positioned(
                  top: -10,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 50.0,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _cancelCreatePosts();
                    },
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Text(
                          locationName,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Divider(
                        thickness: 1.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 224, 244, 255),
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.fromLTRB(70, 25, 70, 25),
                        child: GestureDetector(
                          onTap: () {
                            _getImageFromGallery();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pickedFile == null ? "Picture is required" : "",
                                style: TextStyle(
                                  fontSize: pickedFile == null ? 14.0 : 14.0,
                                ),
                              ),
                              _buildImageWidget(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: postDetailCon,
                            decoration: InputDecoration(
                              labelText: 'Description (require)',
                              helperText: '    ',
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 224, 244, 255),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: 'Tell us about this location..',
                              hintStyle: const TextStyle(fontSize: 12.0),
                            ),
                            maxLines: null,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Description is required.';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 0.0),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: SizedBox(
                            width: 100, // Set the desired width
                            height: 40, // Set the desired height
                            child: ElevatedButton(
                              onPressed: () {
                                if ((_formKey.currentState?.validate() ??
                                        false) &&
                                    pickedFile != null) {
                                  String postDetail = postDetailCon.text;
                                  _addPosts(
                                      desiredPinId, pickedFile, postDetail);
                                  Navigator.pop(context);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    _slidePopup(desiredPinId, locationName);
                                  });
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(99999.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Add Post',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _addPosts(
      String pinId, PlatformFile? pickedFile, String postDetail) async {
    try {
      final postsUrl = 'http://10.0.2.2:3000/api/posts';

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

        final TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
        final downloadURL = await snapshot.ref.getDownloadURL();
        final postResponse = await http.post(
          Uri.parse(postsUrl),
          headers: {'authorization': 'Bearer $myToken'},
          body: {
            'pin_id': pinId,
            'post_detail': postDetail,
            'post_image': downloadURL,
          },
        );

        if (postResponse.statusCode == 200) {
          // Post created successfully
          print('Post created successfully');
          Navigator.pop(context);
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  //Delete marker
  Future<void> _deleteMarker(String specifyId) async {
    final pinIdToDelete = specifyId;
    final url = 'http://10.0.2.2:3000/api/pins/$pinIdToDelete';
    final response = await http.delete(
      Uri.parse(url),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      getMarkerData();
      print('Pin successfully deleted');
    } else if (response.statusCode == 404) {
      print('Pin not found');
    } else {
      print('Error deleting pin');
      print('Response body: ${response.body}');
    }
  }

  void _toggleEditingMode() {
    setState(() {
      _editingMode = !_editingMode;
      if (!_editingMode) {
        _markers.clear();
      }
    });
    getMarkerData();
  }

//When click on screen(Editing)
  void _onMapTap(LatLng position) {
    if (_editingMode && _addMarkers.isEmpty) {
      setState(() {
        final marker = Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        );
        _addMarkers.add(marker);
        _showMarkerPopup(marker);

        print('Latitude: ${position.latitude}');
        print('Longitude: ${position.longitude}');
      });
    }
  }

//Pick Image
  UploadTask? uploadTask;
  PlatformFile? pickedFile;

  Future _getImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      return null;
    }
  }

//Add Pin and Post at the same time
  // final pinId = 'a126f427-608f-4c6a-ac5a-f5198396f645';
  void _addMarkerWithPost(String locationName, double latitude,
      double longitude, PlatformFile? pickedFile, String postDetail) async {
    try {
      final pinsUrl = 'http://10.0.2.2:3000/api/pins';
      final postsUrl = 'http://10.0.2.2:3000/api/posts';

      // Step 1: Add a new pin
      final pinResponse = await http.post(
        Uri.parse(pinsUrl),
        headers: {'authorization': 'Bearer $myToken'},
        body: {
          'location_name': locationName,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      if (pinResponse.statusCode == 200) {
        // Pin added successfully

        // Extract the pin ID from the pin response
        final responseData = jsonDecode(pinResponse.body);
        final data = responseData['data'];
        final pinId = data['pin_id'].toString();

        print(responseData);
        // if (pinId != null) {
        // Step 2: Upload the file to Firebase Storage
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

          final TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
          final downloadURL = await snapshot.ref.getDownloadURL();

          // Step 3: Create a new post with the download URL
          final postResponse = await http.post(
            Uri.parse(postsUrl),
            headers: {'authorization': 'Bearer $myToken'},
            body: {
              'pin_id': pinId,
              'post_detail': postDetail,
              'post_image': downloadURL,
            },
          );

          if (postResponse.statusCode == 200) {
            // Post created successfully
            print('Post created successfully');
            // Update the markers list with the new marker
            setState(() {
              final marker = Marker(
                markerId: MarkerId(DateTime.now().toString()),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: locationName,
                ),
              );
              _markers.add(marker);
            });
          } else {
            // Error creating post
            print('Error creating post');
          }
        }
      } else {
        print('Error: pinId is null');
      }
      // } else {
      //   // Error adding pin
      //   print('Error adding pin');
      // }
    } catch (error) {
      print('Error: $error');
    }
  }

// Define a function to fetch posts by pin_id from the backend API
  Future<List<Post>> fetchPostsByPinId(specifyId) async {
    final pinId = specifyId;
    final url = 'http://10.0.2.2:3000/api/posts/$pinId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<Post> posts = [];
        final responseData = data['data'];

        if (responseData != null && responseData is List) {
          posts.addAll(responseData.map((postJson) => Post.fromJson(postJson)));
        }
        return posts;
      } else {
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void extractUserIdFromToken() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(myToken);

    // Assuming the user ID is stored in the 'user_id' claim of the token
    userWhoLoggedIn = decodedToken['user_id'];
  }

  void _showCannotEditMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text("Cannot Edit Post"),
          content: const Text("You do not have permission to edit this post."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Post> posts = [];
  void _slidePopup(String specifyId, String location_name) async {
    final desiredPinId = specifyId;
    print(desiredPinId);
    setState(() {
      extractUserIdFromToken();
      _editingMode = false;
    });

    posts = await fetchPostsByPinId(desiredPinId);

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            SizedBox(
              height: 500,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const FaIcon(FontAwesomeIcons.angleDown)),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              location_name,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 33, 150, 243),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5, // Adjust the top padding as needed
                      left: 20, // Adjust the left padding as needed
                      right: 20, // Adjust the right padding as needed
                      bottom: 25, // Adjust the bottom padding as needed
                    ),
                    child: SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Check if the current post has the same pin_id
                          if (posts[index].pinId == desiredPinId) {
                            return GestureDetector(
                              onTap: () {
                                if (userWhoLoggedIn == posts[index].userId) {
                                  _showPostPopup(posts[index], location_name);
                                } else {
                                  print(userWhoLoggedIn);
                                  _showCannotEditMessage();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  width: 100,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 224, 244, 255),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.0,
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
                                                posts[index]
                                                    .image, // Use post image URL
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              145, 0, 0, 20),
                                          child: Text(
                                            posts[index]
                                                .detail, // Use post detail
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                  147, 118, 118, 229),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 90,
                                        right: 4,
                                        child: SizedBox(
                                          width: 33,
                                          height: 30,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
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
                                            child: const ClipOval(
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'images/randomppl.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 41, 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  blurRadius: 1,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              posts[index].timeAgo,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Color.fromARGB(
                                                    147, 118, 118, 229),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              right: 23,
              child: Container(
                width: 39,
                height: 39,
                child: FloatingActionButton(
                  onPressed: () {
                    _createPostPopup(desiredPinId, location_name);
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPostPopup(Post post, String locationName) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        TextEditingController descriptionController =
            TextEditingController(text: post.detail);

        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: 350.0,
            height: 507.77,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Positioned(
                  top: -10,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 50.0,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _cancelCreatePosts();
                    },
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Text(
                          locationName,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Divider(
                        thickness: 1.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 224, 244, 255),
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.fromLTRB(70, 25, 70, 25),
                        child: GestureDetector(
                          onTap: _getImageFromGallery,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (pickedFile != null)
                                SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Image.file(
                                    File(pickedFile!.path!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Image.network(
                                  post.image,
                                  width: 100.0,
                                  height: 100.0,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description (require)',
                              helperText: '    ',
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 224, 244, 255),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: 'Tell us about this location..',
                              hintStyle: const TextStyle(fontSize: 12.0),
                            ),
                            maxLines: null,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Description is required.';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 13.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              String updatedDescription =
                                  descriptionController.text;
                              // Perform the update operation
                              if (pickedFile != null) {
                                updatePostWithNewImage(post.postId,
                                    updatedDescription, pickedFile);
                              } else {
                                updatePostWithOutImage(
                                    post.postId, updatedDescription);
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Future.delayed(const Duration(seconds: 1), () {
                                _slidePopup(post.pinId, locationName);
                              });
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 35.0), // Adjust the padding
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 33, 150, 243)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 13.0), // Set the desired font size
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          ElevatedButton(
                            onPressed: () async {
                              // Perform the delete operation
                              await deletePost(post.postId);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Future.delayed(const Duration(seconds: 1), () {
                                _slidePopup(post.pinId, locationName);
                              });
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 35.0), // Adjust the padding
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 13.0), // Set the desired font size
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updatePostWithOutImage(String postId, String postDetail) async {
    try {
      // Prepare the request URL with the postId
      String url = 'http://10.0.2.2:3000/api/posts/$postId';
      Map<String, String> body = {
        'post_detail': postDetail,
      };

      // Send the PUT request to update the post
      http.Response response = await http.put(
        headers: {'authorization': 'Bearer $myToken'},
        Uri.parse(url),
        body: body,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Post updated successfully
        print('Post updated successfully');
      } else {
        // Failed to update the post
        print('Failed to update the post. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Error occurred while updating the post
      print('Error updating the post: $error');
    }
  }

  Future<void> updatePostWithNewImage(
      String postId, String postDetail, PlatformFile? pickedFile) async {
    try {
      // Prepare the request URL with the postId
      String url = 'http://10.0.2.2:3000/api/posts/$postId';

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

        final TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
        final downloadURL = await snapshot.ref.getDownloadURL();
        // Prepare the request body with the updated postDetail and postImage
        Map<String, String> body = {
          'post_detail': postDetail,
          'post_image': downloadURL,
        };

        // Send the PUT request to update the post
        http.Response response = await http.put(
          headers: {'authorization': 'Bearer $myToken'},
          Uri.parse(url),
          body: body,
        );

        // Check the response status code
        if (response.statusCode == 200) {
          // Post updated successfully
          print('Post updated successfully');
        } else {
          // Failed to update the post
          print(
              'Failed to update the post. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      // Error occurred while updating the post
      print('Error updating the post: $error');
    }
  }

// Function to delete the post
  Future<void> deletePost(String postId) async {
    final url = 'http://10.0.2.2:3000/api/posts/$postId';
    final response = await http.delete(
      Uri.parse(url),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      print('Post successfully deleted');
    } else if (response.statusCode == 404) {
      print('Post not found');
    } else {
      print('Error deleting Post');
      print('Response body: ${response.body}');
    }
  }

  TextEditingController locationController = TextEditingController();
  TextEditingController postDetailController = TextEditingController();

  void _showMarkerPopup(Marker marker) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: 350.0,
            height: 420.0,
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 50.0,
                      color: Colors.blue,
                    ),
                    onPressed: _cancelCreatePin,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(
                        'What is this location?',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100.0),
                        Container(
                          width: 290,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(240, 240, 240, 240),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            controller: locationController,
                            style: const TextStyle(
                              fontSize: 25.0,
                              color: Color.fromARGB(
                                  255, 0, 0, 0), // Set the desired color
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Name this location..',
                              hintStyle: TextStyle(
                                fontSize: 25.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 128, 128,
                                    128), // Set the desired hint color
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 85),
                        child: SizedBox(
                          width: 100, // Set the desired width
                          height: 40, // Set the desired height
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close the current AlertDialog
                              _showNextPopup(marker); // Show the next popup
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99999.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageWidget() {
    if (pickedFile == null) {
      return Image.asset(
        'assets/images/upload pic.png',
        width: 100.0,
        height: 100.0,
      );
    } else {
      final file = File(pickedFile!.path!);
      return Image.file(
        file,
        width: 100.0,
        height: 100.0,
      );
    }
  }

  void _showNextPopup(Marker marker) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: 350.0,
            height: 420.0,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Positioned(
                  top: -10,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 50.0,
                      color: Colors.blue,
                    ),
                    onPressed: _cancelCreatePin,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(
                        'Photo & Description',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 244, 255),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.fromLTRB(70, 25, 70, 25),
                      child: GestureDetector(
                        onTap: _getImageFromGallery,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (pickedFile != null)
                              SizedBox(
                                width: 100.0,
                                height: 100.0,
                                child: Image.file(
                                  File(pickedFile!.path!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Image.asset(
                                'assets/images/upload pic.png',
                                width: 100.0,
                                height: 100.0,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      width: 244,
                      height: 67,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 244, 255),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.fromLTRB(19, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description (require)',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF4D8CFE),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: postDetailController,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Tell us about this location..',
                                hintStyle: TextStyle(fontSize: 12.0),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: 100, // Set the desired width
                          height: 40, // Set the desired height
                          child: ElevatedButton(
                            onPressed: () {
                              String locationName = locationController.text;
                              double latitude = marker.position.latitude;
                              double longitude = marker.position.longitude;
                              String postDetail = postDetailController.text;
                              _addMarkerWithPost(locationName, latitude,
                                  longitude, pickedFile, postDetail);
                              Navigator.pop(context);
                              _cancelEditingMode();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99999.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Create Pin',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
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
    );
  }

  void _cancelCreatePosts() {
    setState(() {
      Navigator.pop(context);
      postDetailCon.clear();
      pickedFile = null;
    });
  }

  void _cancelCreatePin() {
    setState(() {
      Navigator.pop(context);
      _addMarkers.clear();
      locationController.clear();
      postDetailController.clear();
      pickedFile = null;
    });
  }

  void _cancelEditingMode() {
    setState(() {
      _editingMode = false;
      _addMarkers.clear();
      locationController.clear();
      postDetailController.clear();
      pickedFile = null;
    });
    getMarkerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentLocation!.latitude!,
                _currentLocation!.longitude!,
              ),
              zoom: 19.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: _onMapTap,
            markers: _markers,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: _editingMode
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 30),
                          child: SizedBox(
                            height: 44.0,
                            width: 44.0,
                            child: RawMaterialButton(
                              onPressed: _cancelEditingMode,
                              elevation: 2.0,
                              fillColor: Colors.white,
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.close,
                                size: 45,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 13, 25),
                          child: SizedBox(
                            width: 118,
                            height: 60,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(99999.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Editing',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'IBM Plex Sans',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 13, 25),
                      child: SizedBox(
                        width: 57.0,
                        height: 58.0,
                        child: FloatingActionButton(
                          onPressed: _toggleEditingMode,
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    ),
            ),
          ),
          const SearchBar(),
        ],
      ),
    );
  }
}
