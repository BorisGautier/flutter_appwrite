/*
* File : Custom On boarding wizard
* Version : 1.0.0
* */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_theme_x/widgets/onBoarding/Animation_Gesture/page_dragger.dart';
import 'package:flutter_theme_x/widgets/onBoarding/Animation_Gesture/page_reveal.dart';
import 'package:flutter_theme_x/widgets/onBoarding/UI/pager_indicator.dart';
import 'package:flutter_theme_x/widgets/onBoarding/UI/pages.dart';

class CustomOnBoardingWidget extends StatefulWidget {
  final List<PageViewModel> pages;
  final Color selectedIndicatorColor;
  final Color unSelectedIndicatorColor;
  final Widget skipWidget, doneWidget;

  const CustomOnBoardingWidget(
      {Key? key,
      required this.pages,
      required this.selectedIndicatorColor,
      required this.unSelectedIndicatorColor,
      required this.skipWidget,
      required this.doneWidget})
      : super(key: key);

  @override
  _CustomOnBoardingWidgetState createState() =>
      new _CustomOnBoardingWidgetState();
}

class _CustomOnBoardingWidgetState extends State<CustomOnBoardingWidget>
    with TickerProviderStateMixin {
  // ignore: close_sinks
  StreamController<SlideUpdate>? slideUpdateStream;
  AnimatedPageDragger? animatedPageDragger;

  int activeIndex = 0;

  SlideDirection? slideDirection = SlideDirection.none;
  int nextPageIndex = 0;

  double? slidePercent = 0.0;

  _CustomOnBoardingWidgetState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream!.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent! > 0.5) {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          }

          animatedPageDragger!.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          if (animatedPageDragger?.transitionGoal == TransitionGoal.open) {
            activeIndex = nextPageIndex;
          }
          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger!.dispose();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    slideUpdateStream!.close();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        children: [
          FTxSinglePage(
            viewModel: widget.pages[activeIndex],
            percentVisible: 1.0,
          ),
          new FTxPageReveal(
            revealPercent: slidePercent,
            child: new FTxSinglePage(
              viewModel: widget.pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          new FTxPagerIndicator(
            viewModel: new PagerIndicatorViewModel(
                widget.pages,
                activeIndex,
                slideDirection,
                slidePercent,
                widget.selectedIndicatorColor,
                widget.unSelectedIndicatorColor,
                widget.skipWidget,
                widget.doneWidget),
          ),
          new FTxPageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < widget.pages.length - 1,
            slideUpdateStream: this.slideUpdateStream,
          )
        ],
      ),
    );
  }
}
