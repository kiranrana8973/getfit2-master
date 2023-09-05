import 'package:flutter/material.dart';
import 'package:getfit2/easy_workout.dart';
import 'package:getfit2/userprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'user_profile/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var currdata = false;
  late String? email;
  void _easyClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EasyWorkout()),
    );
  }

  void _mediumClick() {
    
    Fluttertoast.showToast(
        msg: "Coming Soon...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _hardClick() {
    Fluttertoast.showToast(
        msg: "Coming Soon...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = Provider.of<UserProvider>(context).email;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: const [UserProfile()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Let\'s Get Started!',
                  style: GoogleFonts.getFont(
                    'Lato',
                    textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      // color: Color(0xFF50B0FF),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7DFFF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'images/home.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _easyClick,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7DFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            'images/beginner.png',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 5.0),
                              child: Text(
                                'Beginner',
                                style: GoogleFonts.getFont(
                                  'Lato',
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    // color: Color(0xFF50B0FF),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Fundamental level workout session',
                              style: GoogleFonts.getFont(
                                'Lato',
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _mediumClick,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7DFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.black, BlendMode.srcATop),
                            child: Image.asset(
                              'images/intermediate.png',
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 5.0),
                              child: Text(
                                'Intermediate',
                                style: GoogleFonts.getFont(
                                  'Lato',
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    // color: Color(0xFF50B0FF),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Average level workout session',
                              style: GoogleFonts.getFont(
                                'Lato',
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600
                                    // color: Color(0xFF50B0FF),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7DFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'images/advanced.png',
                          width: 42,
                          height: 42,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 5.0),
                            child: Text(
                              'Advanced',
                              style: GoogleFonts.getFont(
                                'Lato',
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  // color: Color(0xFF50B0FF),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Professional level workout session',
                            style: GoogleFonts.getFont(
                              'Lato',
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600
                                  // color: Color(0xFF50B0FF),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
