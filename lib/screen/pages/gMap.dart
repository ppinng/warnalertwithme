import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
    if (_editingMode && _markers.isEmpty) {
      setState(() {
        final marker = Marker(
          markerId: MarkerId(position.toString()),
          position: position,
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
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 50.0,
                color: Colors.red,
              ),
              onPressed: _cancelCreatePin,
            ),
          ),
          content: Container(
            width: 500.0,
            height: 300.0,
          ),
        );
      },
    );
  }

  void _cancelCreatePin() {
    setState(() {
      Navigator.pop(context);
      _markers.clear();
    });
  }

  void _deleteMarker(MarkerId markerId) {
    if (_editingMode) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId == markerId);
      });
    }
  }

  void _cancelEditingMode() {
    setState(() {
      _editingMode = false;
      _markers.clear();
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
                                    borderRadius: BorderRadius.circular(99999.0),
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 27),
                      child: SizedBox(
                        height: 58,
                        width: 57.11,
                        child: RawMaterialButton(
                          onPressed: _toggleEditingMode,
                          elevation: 2.0,
                          fillColor: Colors.blue,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            size: 35,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
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
