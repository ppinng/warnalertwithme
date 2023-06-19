import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/widgets.dart';


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
  List<Marker> _markers = [];
  Set<Marker> _selectedMarkers = Set<Marker>();


  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
      });
    });
  }

  void _toggleEditingMode() {
    setState(() {
      _editingMode = !_editingMode;
      if (!_editingMode) {
        _markers.clear();
      }
    });
  }

  void _onMapTap(LatLng position) {
    if (_editingMode) {
      setState(() {
        final marker = Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          onTap: () {
            _deleteMarker(MarkerId(position.toString()));
          },
        );
        _markers.add(marker);
        _showMarkerPopup(marker);

        print('Latitude: ${position.latitude}');
        print('Longitude: ${position.longitude}');
      });
    }
  }

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
                        TextFormField(
                          style: TextStyle(fontSize: 29.0),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Name this location..',
                            hintStyle: TextStyle(fontSize: 29.0),
                          ),
                          maxLines: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 110),
                        child: SizedBox(
                          width: 100, // Set the desired width
                          height: 40, // Set the desired height
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close the current AlertDialog
                              _showNextPopup(); // Show the next popup
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

  void _showNextPopup() {
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
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(height: 10.0),
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
                            onPressed: _addInformation,
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
      if (_markers.isNotEmpty) {
        _markers.removeLast();
      }
    });
  }

  void _deleteMarker(MarkerId markerId) {
    if (_editingMode) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: const Color.fromARGB(255, 224, 244, 255),
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
                          setState(() {
                            _markers.removeWhere(
                                (marker) => marker.markerId == markerId);
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 13.0), // Set the desired font size
                        ),
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 45.0), // Adjust the padding
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 13.0), // Set the desired font size
                        ),
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 50.0), // Adjust the padding
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45.0),
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
  }

  void _cancelEditingMode() {
    setState(() {
      _editingMode = false;
    });
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
            markers: Set<Marker>.from(_markers),
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
