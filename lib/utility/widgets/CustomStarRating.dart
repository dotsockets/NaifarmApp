library smooth_star_rating;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef void RatingChangeCallback(double rating);

class CustomStarRating extends StatefulWidget {
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

  @override
  _CustomStarRatingState createState() => _CustomStarRatingState();
}

class _CustomStarRatingState extends State<CustomStarRating> {
  final double halfStarThreshold =
      0.53; //half star value starts from this number

  //tracks for user tapping on this widget
  bool isWidgetTapped = false;
  double currentRating;
  Timer debounceTimer;

  @override
  void initState() {
    currentRating = widget.rating;
    super.initState();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    debounceTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: widget.spacing,
          children: List.generate(
              widget.starCount, (index) => buildStar(context, index))),
    );
  }

  Widget buildStar(BuildContext context, int index) {
    SvgPicture icon;
    if (index >= currentRating) {
      icon = SvgPicture.asset(
        widget.defaultIconData,
        color: Colors.grey.shade500,
        width: widget.size,
        height: widget.size,
      );
    } else if (index >
            currentRating -
                (widget.allowHalfRating ? halfStarThreshold : 1.0) &&
        index < currentRating) {
      icon = icon = SvgPicture.asset(
        widget.halfFilledIconData,
        width: widget.size,
        height: widget.size,
      );
    } else {
      icon = SvgPicture.asset(
        widget.filledIconData,
        width: widget.size,
        height: widget.size,
      );
    }
    final Widget star = widget.isReadOnly
        ? icon
        : identical(0, 0.0)
            ? MouseRegion(
                onExit: (event) {
                  if (widget.onRated != null && !isWidgetTapped) {
                    //reset to zero only if rating is not set by user
                    setState(() {
                      currentRating = 0;
                    });
                  }
                },
                onEnter: (event) {
                  isWidgetTapped = false; //reset
                },
                onHover: (event) {
                  RenderBox box = context.findRenderObject();
                  var _pos = box.globalToLocal(event.position);
                  var i = _pos.dx / widget.size;
                  var newRating =
                      widget.allowHalfRating ? i : i.round().toDouble();
                  if (newRating > widget.starCount) {
                    newRating = widget.starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  setState(() {
                    currentRating = newRating;
                  });
                },
                child: GestureDetector(
                  onTapDown: (detail) {
                    isWidgetTapped = true;

                    RenderBox box = context.findRenderObject();
                    var _pos = box.globalToLocal(detail.globalPosition);
                    var i = ((_pos.dx - widget.spacing) / widget.size);
                    var newRating =
                        widget.allowHalfRating ? i : i.round().toDouble();
                    if (newRating > widget.starCount) {
                      newRating = widget.starCount.toDouble();
                    }
                    if (newRating < 0) {
                      newRating = 0.0;
                    }
                    setState(() {
                      currentRating = newRating;
                    });
                    if (widget.onRated != null) {
                      widget.onRated(normalizeRating(currentRating));
                    }
                  },
                  onHorizontalDragUpdate: (dragDetails) {
                    isWidgetTapped = true;

                    RenderBox box = context.findRenderObject();
                    var _pos = box.globalToLocal(dragDetails.globalPosition);
                    var i = _pos.dx / widget.size;
                    var newRating =
                        widget.allowHalfRating ? i : i.round().toDouble();
                    if (newRating > widget.starCount) {
                      newRating = widget.starCount.toDouble();
                    }
                    if (newRating < 0) {
                      newRating = 0.0;
                    }
                    setState(() {
                      currentRating = newRating;
                    });
                    debounceTimer?.cancel();
                    debounceTimer = Timer(Duration(milliseconds: 100), () {
                      if (widget.onRated != null) {
                        currentRating = normalizeRating(newRating);
                        widget.onRated(currentRating);
                      }
                    });
                  },
                  child: icon,
                ),
              )
            : GestureDetector(
                onTapDown: (detail) {
                  RenderBox box = context.findRenderObject();
                  var _pos = box.globalToLocal(detail.globalPosition);
                  var i = ((_pos.dx - widget.spacing) / widget.size);
                  var newRating =
                      widget.allowHalfRating ? i : i.round().toDouble();
                  if (newRating > widget.starCount) {
                    newRating = widget.starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  newRating = normalizeRating(newRating);
                  setState(() {
                    currentRating = newRating;
                  });
                },
                onTapUp: (e) {
                  if (widget.onRated != null) widget.onRated(currentRating);
                },
                onHorizontalDragUpdate: (dragDetails) {
                  RenderBox box = context.findRenderObject();
                  var _pos = box.globalToLocal(dragDetails.globalPosition);
                  var i = _pos.dx / widget.size;
                  var newRating =
                      widget.allowHalfRating ? i : i.round().toDouble();
                  if (newRating > widget.starCount) {
                    newRating = widget.starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  setState(() {
                    currentRating = newRating;
                  });
                  debounceTimer?.cancel();
                  debounceTimer = Timer(Duration(milliseconds: 100), () {
                    if (widget.onRated != null) {
                      currentRating = normalizeRating(newRating);
                      widget.onRated(currentRating);
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
