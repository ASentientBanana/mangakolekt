import 'package:flutter/material.dart';

class PermissionPromptBody extends StatelessWidget {
  const PermissionPromptBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Text(
          "In order to access filesystem locations for creating local libraries the app needs filesystem permissions"),
    );
  }
}
