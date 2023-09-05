import 'package:flutter/material.dart';

import 'user_profile/user_profile.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [UserProfile()],
      ),
      body: const Text('This is Setting Page'),
    );
  }
}