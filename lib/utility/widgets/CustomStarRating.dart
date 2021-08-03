library smooth_star_rating;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/subjects.dart';

typedef void RatingChangeCallback(double rating);

class CustomStarRating extends StatelessWidget {


  final int starCount;
  final double rating;
  final RatingChangeCallback onRated;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;
  final String filledIconData;
  final String halfFilledIconData;
  final String
  defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  final bool isReadOnly;

  CustomStarRating({
    this.starCount = 5,
    this.isReadOnly = false,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData = 'assets/images/svg/star_entry.svg',
    this.onRated,
    this.color,
    this.borderColor,
    this.size = 25,
    this.filledIconData,
    this.halfFilledIconData = 'assets/images/svg/star_active.svg',
    this.allowHalfRating = true,
  }) {
    assert(this.rating != null);
  }
  
  final double halfStarThreshold =
      0.53; //half star value starts from this number

  //tracks for user tapping on this widget
  bool isWidgetTapped = false;
  Timer debounceTimer;
  BehaviorSubject<double> currentRating = BehaviorSubject<double>();



  // @override
  // void dispose() {
  //   debounceTimer?.cancel();
  //   debounceTimer = null;
  //   super.dispose();
  // }
  //
  init(){
    currentRating.add(rating);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Material(
      color: Colors.transparent,
      child: StreamBuilder(stream: currentRating.stream,builder: (context,snapshot){
        return Wrap(
            alignment: WrapAlignment.start,
            spacing: spacing,
            children: List.generate(
                starCount, (index) => buildStar(context, index)));
      }),
    );
  }

  Widget buildStar(BuildContext context, int index) {
    SvgPicture icon;
    if (index >= currentRating.value) {
      icon = SvgPicture.asset(
        defaultIconData,
        color: Colors.grey.shade500,
        width: size,
        height: size,
      );
    } else if (index >
            currentRating.value -
                (allowHalfRating ? halfStarThreshold : 1.0) &&
        index < currentRating.value) {
      icon = icon = SvgPicture.asset(
        halfFilledIconData,
        width: size,
        height: size,
      );
    } else {
      icon = SvgPicture.asset(
        filledIconData,
        width: size,
        height: size,
      );
    }
    final Widget star = isReadOnly
        ? icon
        : identical(0, 0.0)
            ? MouseRegion(
                onExit: (event) {
                  if (onRated != null && !isWidgetTapped) {
                    //reset to zero only if rating is not set by user
                    // setState(() {
                    //   currentRating = 0;
                    // });
                    currentRating.add(0);
                  }
                },
                onEnter: (event) {
                  isWidgetTapped = false; //reset
                },
                onHover: (event) {
                  RenderBox box = context.findRenderObject();
                  var _pos = box.globalToLocal(event.position);
                  var i = _pos.dx / size;
                  var newRating =
                      allowHalfRating ? i : i.round().toDouble();
                  if (newRating > starCount) {
                    newRating = starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  // setState(() {
                  //   currentRating = newRating;
                  // });
                  currentRating.add(newRating);
                },
                child: GestureDetector(
                  onTapDown: (detail) {
                    isWidgetTapped = true;

                    RenderBox box = context.findRenderObject();
                    var _pos = box.globalToLocal(detail.globalPosition);
                    var i = ((_pos.dx - spacing) / size);
                    var newRating =
                        allowHalfRating ? i : i.round().toDouble();
                    if (newRating > starCount) {
                      newRating = starCount.toDouble();
                    }
                    if (newRating < 0) {
                      newRating = 0.0;
                    }
                    // setState(() {
                    //   currentRating = newRating;
                    // });
                    currentRating.add(newRating);
                    if (onRated != null) {
                      onRated(normalizeRating(currentRating.value));
                    }
                  },
                  onHorizontalDragUpdate: (dragDetails) {
                    isWidgetTapped = true;

                    RenderBox box = context.findRenderObject();
                    var _pos = box.globalToLocal(dragDetails.globalPosition);
                    var i = _pos.dx / size;
                    var newRating =
                        allowHalfRating ? i : i.round().toDouble();
                    if (newRating > starCount) {
                      newRating = starCount.toDouble();
                    }
                    if (newRating < 0) {
                      newRating = 0.0;
                    }
                    // setState(() {
                    //   currentRating = newRating;
                    // });
                    currentRating.add(newRating);
                    if (onRated != null) {
                      currentRating = normalizeRating(newRating) as BehaviorSubject<double>;
                      onRated(currentRating.value);
                    }
                  },
                  child: icon,
                ),
              )
            : GestureDetector(
                onTapDown: (detail) {
                  RenderBox box = context.findRenderObject();
                  var _pos = box.globalToLocal(detail.globalPosition);
                  var i = ((_pos.dx - spacing) / size);
                  var newRating =
                      allowHalfRating ? i : i.round().toDouble();
                  if (newRating > starCount) {
                    newRating = starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  newRating = normalizeRating(newRating);
                  // setState(() {
                  //   currentRating = newRating;
                  // });
                  currentRating.add(newRating);
                },
                onTapUp: (e) {
                  if (onRated != null) onRated(currentRating.value);
                },
                onHorizontalDragUpdate: (dragDetails) {
                  RenderBox box = context.findRenderObject();
                  var _pos = box.globalToLocal(dragDetails.globalPosition);
                  var i = _pos.dx / size;
                  var newRating =
                      allowHalfRating ? i : i.round().toDouble();
                  if (newRating > starCount) {
                    newRating = starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  // setState(() {
                  //   currentRating = newRating;
                  // });
                  currentRating.add(newRating);
                  debounceTimer?.cancel();
                  debounceTimer = Timer(Duration(milliseconds: 100), () {
                    if (onRated != null) {
                      currentRating = normalizeRating(newRating) as BehaviorSubject<double>;
                      onRated(currentRating.value);
                    }

                  });
                },
                child: icon,
              );

    return star;
  }

  double normalizeRating(double newRating) {
    var k = newRating - newRating.floor();
    if (k != 0) {
      //half stars
      if (k >= halfStarThreshold) {
        newRating = newRating.floor() + 1.0;
      } else {
        newRating = newRating.floor() + 0.5;
      }
    }
    return newRating;
  }
}
