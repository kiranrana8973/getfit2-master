import 'package:flutter/material.dart';

import 'user_profile_content.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: CircleAvatar(
        child: IconButton(
          onPressed: () {
            Navigator.of(context).push(_userIconPressed());
          },
          icon: const Icon(Icons.person),
        ),
      ),
    );
  }

  //when user icon button is pressed
  PageRouteBuilder _userIconPressed() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => const UserProfileContent(),
      transitionsBuilder:
          (BuildContext context, Animation<double> animation, _, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
