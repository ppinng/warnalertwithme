import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warnalertwithme/component/menu_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(130),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        repeat: ImageRepeat.repeat,
                        image: AssetImage('images/randomppl.png'),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                padding: const EdgeInsets.all(10),
                                color: Colors.blue,
                                icon: const FaIcon(FontAwesomeIcons.bars),
                                iconSize: 50,
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                tooltip: MaterialLocalizations.of(context)
                                    .openAppDrawerTooltip,
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: MaterialButton(
                                height: 30,
                                color: Colors.white,
                                shape: const CircleBorder(),
                                child: const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    color: Colors.black,
                                    size: 15),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AboutDialog();
                                      });
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    left: 20,
                    bottom: -80,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 55,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(35, 50, 0, 0),
                          child:
                              Text(style: TextStyle(fontSize: 35), 'Username.'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: FaIcon(FontAwesomeIcons.pen, size: 16),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        left: 70,
                        bottom: -80,
                        child: MaterialButton(
                          elevation: 3,
                          height: 30,
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const FaIcon(FontAwesomeIcons.penToSquare,
                              color: Colors.black, size: 15),
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AboutDialog();
                            //   },
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            drawer: const Drawer(
              child: DrawerBar(),
            ),
            body: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  top: 20,
                  left: 35,
                  child: MaterialButton(
                    elevation: 3,
                    height: 30,
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: const FaIcon(FontAwesomeIcons.penToSquare,
                        color: Colors.black, size: 15),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AboutDialog();
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 26.5,
                  right: 6,
                  child: MaterialButton(
                    child: const FaIcon(FontAwesomeIcons.pen, size: 16),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog();
                          });
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 100),
                                child: Text(
                                  'Post',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: 150,
                                color: Colors.blue,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 150,
                                color: Colors.green,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 150,
                                color: Colors.orange,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 150,
                                color: Colors.yellow,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 150,
                                color: Colors.orange,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 150,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
