import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../page/register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
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
            ? InkWell(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              )
            : null,
        actions: [
          if (_currentPageIndex < 2)
            InkWell(
              borderRadius: BorderRadius.circular(25.0),
              highlightColor: Colors.transparent,
              onTap: () {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBM Plex Sans',
                    color: Colors.black,
                  ),
                ),
              ),
            )
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
                    _buildImageWithLoadingIndicator(
                      'assets/images/logo_map_bg.png',
                      width: 400.0,
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
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    const SizedBox(height: 50.0),
                    _buildImageWithLoadingIndicator(
                      'assets/images/logo_phone_bg.png',
                      width: 400.0,
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
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 35.0),
                    _buildImageWithLoadingIndicator(
                      'assets/images/logo_heart_bg.png',
                      width: 400.0,
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
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
          Positioned(
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

  Widget _buildImageWithLoadingIndicator(
    String imagePath, {
    double width = 200.0,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          imagePath,
          width: width,
        ),
        FutureBuilder(
          future: precacheImage(AssetImage(imagePath), context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Icon(
                Icons.error_rounded,
                color: Colors.blue,
                size: width / 2,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
