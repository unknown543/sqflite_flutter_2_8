import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  const Button({Key? key, required this.title, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 50.0,
      margin: const EdgeInsets.only(top: 30.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xffFFB500)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          elevation: MaterialStateProperty.all(0.0),
        ),
        onPressed: onClick,
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
