import 'package:flutter/material.dart';

class CommonWidget {
  moveToNextPage(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  snackBarShow(context, scaffoldKey, msg, msgColor, btnName, btnFun) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: msgColor, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 5),
      action: SnackBarAction(label: btnName, onPressed: btnFun),
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  cardWidget(wt, ht, give, get) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        height: ht * 20,
        width: wt * 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: ht * 5,
              left: wt * 10,
              child:
                  balanceWidget(give, Colors.green, "You'll Give", '\u{25B2}'),
            ),
            Positioned(
              top: ht * 5,
              right: wt * 10,
              child: balanceWidget(get, Colors.red, "You'll Get", '\u{25BC}'),
            ),
            Positioned(
              bottom: ht * 2,
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "View Report",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  balanceWidget(str, textColor, hintText, upDownIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$upDownIcon \u{20B9}$str',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(hintText)
      ],
    );
  }

  Route createRoute(page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
