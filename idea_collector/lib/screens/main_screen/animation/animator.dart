import 'package:flutter/material.dart';

class MainScreenAnimator {
  final AnimationController controller;
  final BuildContext context;
  Curve myCurve = Curves.decelerate;
  MainScreenAnimator(this.context, this.controller);
  late Animation<double> iconOpacity;
  late Animation<double> textOpacity;
  late Animation<double> bannertranslation;
  late Animation<double> addRowtranslation;
  late Animation<double> tileScale;
  late Animation<double> tileOpacity;
  void initAnimations() {
    iconOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.4,
          curve: myCurve,
        ),
      ),
    );
    textOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.4,
          0.7,
          curve: myCurve,
        ),
      ),
    );
    bannertranslation = Tween(
      begin: MediaQuery.of(context).size.height -
          70 -
          MediaQuery.of(context).padding.top,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.4,
          0.7,
          curve: myCurve,
        ),
      ),
    );
    tileScale = Tween(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.8,
          1.0,
          curve: myCurve,
        ),
      ),
    );
    tileOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.8,
          1.0,
          curve: myCurve,
        ),
      ),
    );
    addRowtranslation = Tween(
      begin: MediaQuery.of(context).size.width,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.7,
          0.8,
          curve: myCurve,
        ),
      ),
    );
  }

  Animation<double> getIconOpacity() {
    return iconOpacity;
  }

  Animation<double> getTextOpacity() {
    return textOpacity;
  }

  Animation<double> getBannertranslation() {
    return bannertranslation;
  }

  Animation<double> getAddRowtranslation() {
    return addRowtranslation;
  }

  Animation<double> getTileScale() {
    return tileScale;
  }

  Animation<double> getTileOpacity() {
    return tileOpacity;
  }
}
