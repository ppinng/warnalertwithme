import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        title: Text(marker.infoWindow.title ?? ''),
                        content: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _deleteMarker(specifyId);
                            getMarkerData();
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      );
                    },
                  );
                }
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

  //Delete marker
  Future<void> _deleteMarker(String specifyId) async {
    final pinIdToDelete = specifyId;
    final url = 'http://10.0.2.2:3000/api/pins/$pinIdToDelete';
    final response = await http.delete(
      Uri.parse(url),
    );

    // Check the response status code
    if (response.statusCode == 200) {
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

  UploadTask? uploadTask;
  PlatformFile? pickedFile;

  void _getImageFromGallery() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
    _buildImageWidget();
  }

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
      return Image.memory(
        file.readAsBytesSync(),
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
                        onTap: () {
                          _getImageFromGallery();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildImageWidget(),
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

  void _addInformation() {
    setState(() {
      _editingMode = false;
      Navigator.pop(context);
    });
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
                      padding: EdgeInsets.fromLTRB(0, 0, 13, 25),
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
        ],
      ),
    );
  }
}
