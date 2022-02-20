import 'package:flutter/material.dart';

class CommonOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  final bool? fullWidth;
  const CommonOutlinedButton({
    Key? key,
    required this.title,
    this.onClick,
    this.fullWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ?? false ? double.infinity : null,
      height: 50.0,
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          elevation: MaterialStateProperty.all(0.0),
        ),
        onPressed: onClick,
        child: Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
