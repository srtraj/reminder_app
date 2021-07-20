import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.width,
      required this.height,
      required this.text,
      required this.color,
      required this.callBack});
  final double width;
  final double height;
  final String text;
  final Color color;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox.expand(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: () {
                callBack();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
