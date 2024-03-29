import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchBarForMap extends StatefulWidget {
  const SearchBarForMap({Key? key}) : super(key: key);

  @override
  State<SearchBarForMap> createState() => _SearchBarForMapState();
}

class _SearchBarForMapState extends State<SearchBarForMap> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays >= 7) {
      var weeks = (duration.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''} ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _performSearch(String searchTerm) async {
    if (_searchController.text.isNotEmpty) {
      var queryParameters = {
        'term': searchTerm,
      };
      var uri = Uri.http('10.0.2.2:3000', '/api/search', queryParameters);

      var response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    }
  }

  void _showPostDetails(BuildContext context, Map<String, dynamic> result) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const FaIcon(FontAwesomeIcons.angleDown),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        result['location_name'],
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4D8CFE)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 350,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: result['posts'].length,
                        itemBuilder: (context, index) {
                          var post = result['posts'][index];
                          var timeAgo = '';

                          if (post['time_ago'].containsKey('days') &&
                              post['time_ago']['days'] != null &&
                              post['time_ago']['days'] >= 1) {
                            var days = post['time_ago']['days'];
                            var hours = post['time_ago']['hours'] ?? 0;
                            var minutes = post['time_ago']['minutes'] ?? 0;
                            timeAgo = _formatDuration(Duration(
                                days: days, hours: hours, minutes: minutes));
                            // Display timeAgo with days, hours, and minutes
                          } else if (post['time_ago'].containsKey('hours') &&
                              post['time_ago']['hours'] != null &&
                              post['time_ago']['hours'] >= 1) {
                            var hours = post['time_ago']['hours'];
                            var minutes = post['time_ago']['minutes'] ?? 0;
                            timeAgo = _formatDuration(
                                Duration(hours: hours, minutes: minutes));
                            // Display timeAgo with hours and minutes
                          } else {
                            var minutes = post['time_ago']['minutes'] ?? 0;
                            timeAgo =
                                _formatDuration(Duration(minutes: minutes));
                            // Display timeAgo with minutes
                          }

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 100,
                              height: 125,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 224, 244, 255),
                                border: Border.all(
                                  color: const Color(0xFF767676),
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          145, 20, 0, 20),
                                      child: Text(
                                        post['post_detail'], // Use post detail
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF767676),
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: NetworkImage(
                                                post['profile_image']),
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
                                        decoration: const BoxDecoration(),
                                        child: Text(
                                          timeAgo, // Use post time
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF767676),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: queryData.size.height / 6),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 300,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(0, 0, 0, 0),
          elevation: 4,
          child: TextField(
            controller: _searchController,
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
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onSubmitted: (value) {
              _performSearch(value);
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(4, 20, 4, 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const FaIcon(FontAwesomeIcons.angleDown),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                var result = _searchResults[index];
                                return GestureDetector(
                                  onTap: () {
                                    _showPostDetails(context, result);
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
                                          color: const Color(0xFF767676),
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, left: 20),
                                            child: Text(
                                              result['location_name'],
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF4D8CFE)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                                'Number of posts: ${result['post_count']}',
                                                style: const TextStyle(
                                                  color: Color(0xFF767676),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
