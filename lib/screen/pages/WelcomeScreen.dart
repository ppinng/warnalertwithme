import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPageIndex > 0
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  // shadows: [],
                  color: Colors.black,
                ),
                // highlightColor: Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
        actions: [
          if (_currentPageIndex < 2)
            InkWell(
              onTap: () {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
              child: const TextButton(
                onPressed: null,
                child: Text(
                  'Skip',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBM Plex Sans',
                      color: Colors.black),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50.0),
                    Image.asset(
                      'assets/images/logo_map.png',
                      alignment: Alignment.topCenter,
                      width: 400.0,
                      // height: 400.0,
                    ),
                    const SizedBox(height: 60.0),
                    const Text(
                      'Check the area around',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'you at any time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'See location pins that other',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'people have already pinned.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 151.5),
                    Positioned(
                      bottom: 20, // Adjust the bottom position as needed
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 78, 134, 255),
                              elevation: 4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 82, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBM Plex Sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                // padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50.0),
                    Image.asset(
                      'assets/images/logo_phone.png',
                      alignment: Alignment.topCenter,
                      width: 400.0,
                      // height: 400.0,
                    ),
                    const SizedBox(height: 60.0),
                    const Text(
                      'Post to add information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'to others',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Pin more to spread the',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'news to others.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 151.5),
                    Positioned(
                      bottom: 20, // Adjust the bottom position as needed
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 78, 134, 255),
                              elevation: 4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 82, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBM Plex Sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 35.0),
                    Image.asset(
                      'assets/images/logo_heart.png',
                      alignment: Alignment.topCenter,
                      width: 400.0,
                      // height: 400.0,
                    ),
                    const SizedBox(height: 80.0),
                    const Text(
                      'Welcome!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Join with us & enjoy safe life',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'IBM Plex Sans',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 180.0),
                    Positioned(
                      bottom: 20, // Adjust the bottom position as needed
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 78, 134, 255),
                              elevation: 4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 65, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Get Start',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBM Plex Sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            // bottom: 40.0,
            top: 290,
            left: 158.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color.fromARGB(255, 78, 134, 255),
                  dotColor: Color.fromARGB(255, 173, 198, 252),
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                  spacing: 5.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
