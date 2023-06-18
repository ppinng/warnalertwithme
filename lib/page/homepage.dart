import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warnalertwithme/component/menu_bar.dart';
import 'package:warnalertwithme/page/gMap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const MapScreen(),
          Container(
            padding: const EdgeInsets.only(top: 150),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 300,
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(0, 0, 0, 0),
                elevation: 4,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Search',
                    // contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              Positioned(
                                  top: 20,
                                  child: SizedBox(
                                    width: 300,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  )),
                              SizedBox(
                                height: 500,
                                child: ListView(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child:
                                            FaIcon(FontAwesomeIcons.angleDown),
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      height: 150,
                                      color: Colors.green,
                                    ),
                                    Container(
                                      height: 150,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      height: 150,
                                      color: Colors.green,
                                    ),
                                    Container(
                                      height: 150,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      height: 150,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void searchOnMap() {
    String searchText = searchController.text;
    // Implement your search functionality here
    // You can use geocoding services to convert the search text to LatLng coordinates
    // and then move the camera to that location on the map
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
