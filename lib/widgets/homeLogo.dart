
import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  String? text = '';
  HomeLogo({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              scale: 2,
            ),
            Text(
              text != null ? text! : "",
              style: const TextStyle(
                color: Color.fromARGB(255, 71, 82, 89),
              ),
            )
          ],
        ),
      ),
    );
  }
}
