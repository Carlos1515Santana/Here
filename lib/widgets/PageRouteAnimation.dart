import 'package:flutter/cupertino.dart';

class PageRouteAnimation extends PageRouteBuilder {
  final Widget widget;

  PageRouteAnimation({this.widget}) :super(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);

        return ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: child,
        );
      },
      pageBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      }
  );
}