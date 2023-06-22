import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class searchBar extends StatefulWidget {
  const searchBar({super.key});

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onSubmitted: (value) {
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
          );
  }
}