import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press; //final void Function()  press
  final Color color, textColor;
  const RoundedButton({
    super.key,
    this.text = "",
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        width: size.width * 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: TextButton(
            onPressed: press,
            style: ButtonStyle(
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
              backgroundColor: MaterialStatePropertyAll(color),
            ),
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
