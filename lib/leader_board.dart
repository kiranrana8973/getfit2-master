import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'user_profile/user_profile.dart';

class LeaderBoard extends StatelessWidget {
  LeaderBoard({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> users = [
    {'name': 'User 1', 'calories': 1000},
    {'name': 'User 2', 'calories': 900},
    {'name': 'User 3', 'calories': 800},
    {'name': 'User 4', 'calories': 700},
    {'name': 'User 5', 'calories': 600},
    {'name': 'User 6', 'calories': 500},
    {'name': 'User 7', 'calories': 400},
    {'name': 'User 8', 'calories': 300},
    {'name': 'User 9', 'calories': 200},
    {'name': 'User 10', 'calories': 100},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: const [UserProfile()],
      ),
      body: DefaultTextStyle(
        style: GoogleFonts.getFont(
          'Lato',
          textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopUser(2, 60.0),
                    _buildTopUser(0, 100.0),
                    _buildTopUser(1, 80.0),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DefaultTextStyle(
                        style: GoogleFonts.getFont(
                          'Lato',
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF000000)),
                        ),
                        child: SingleChildScrollView(
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(60.0),
                              1: FlexColumnWidth(),
                              2: FixedColumnWidth(60.0),
                            },
                            children: const [
                              TableRow(
                                children: [
                                  Text('#Rank'),
                                  Text('User'),
                                  Text('Calories'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 30.0,
                      thickness: 1.0,
                      color: Color(0xFF000000),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(60.0),
                            1: FlexColumnWidth(),
                            2: FixedColumnWidth(90.0),
                          },
                          children: [
                            for (int i = 3; i < users.length; i++)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: i == 3
                                        ? const EdgeInsets.only(
                                            left: 15.0, bottom: 15.0)
                                        : const EdgeInsets.all(15.0),
                                    child:
                                        Text('${users.indexOf(users[i]) + 1}'),
                                  ),
                                  Padding(
                                    padding: i == 3
                                        ? const EdgeInsets.only(
                                            left: 15.0, bottom: 15.0)
                                        : const EdgeInsets.all(15.0),
                                    child: Text(users[i]['name']),
                                  ),
                                  Padding(
                                    padding: i == 3
                                        ? const EdgeInsets.only(
                                            left: 15.0, bottom: 15.0)
                                        : const EdgeInsets.all(15.0),
                                    child: Text('${users[i]['calories']} cal'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopUser(int index, double h) {
    final user = users[index];
    return Expanded(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.end, // Align column content to the bottom
        children: [
          const ClipOval(
            child: Image(
              width: 60.0,
              height: 60.0,
              color: Color.fromARGB(255, 68, 171, 255),
              image: AssetImage('images/avatar.png'),
            ),
          ),
          const SizedBox(height: 8.0),
          Stack(
            children: [
              Container(
                width: 60.0,
                height: h,
                decoration: BoxDecoration(
                  color: const Color(0xFFB7DFFF),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text('${user['calories']} cal'),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text('${index + 1}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
