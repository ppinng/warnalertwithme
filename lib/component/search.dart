import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 7) {
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  result['location_name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: result['posts'].length,
                  itemBuilder: (context, index) {
                    var post = result['posts'][index];
                    var formattedPostedAt =
                        DateTime.parse(post['posted_at_formatted']);
                    var now = DateTime.now();
                    var difference = now.difference(formattedPostedAt);
                    var formattedDifference = _formatDuration(difference);

                    return Card(
                      child: ListTile(
                        leading: Image.network(post['post_image']),
                        title: Text(post['post_detail']),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDifference),
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(post['profile_image']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                  return Stack(
                    children: [
                      Positioned(
                        top: 20,
                        child: SizedBox(
                          width: 300,
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            var result = _searchResults[index];
                            return ListTile(
                              title: Text(result['location_name']),
                              subtitle: Text(
                                  'Number of posts: ${result['post_count']} ${result['latitude']}'),
                              onTap: () {
                                _showPostDetails(context, result);
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
