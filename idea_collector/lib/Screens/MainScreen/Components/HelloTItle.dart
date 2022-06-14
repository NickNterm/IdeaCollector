import 'package:flutter/material.dart';

class HelloTitle extends StatelessWidget {
  const HelloTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 70,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Hello Creator",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    );
  }
}
