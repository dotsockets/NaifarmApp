

import 'package:flutter/material.dart';

class FlipWidget extends StatelessWidget {
  Widget child;

  FlipWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.5,
              child: child,
            )),
        Padding(
          padding: EdgeInsets.only(top: 2.0),
        ),
        ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.5,
              child: child,
            )),
      ],
    );
  }
}