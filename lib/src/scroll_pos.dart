import 'package:flutter/widgets.dart';

const _kDefaultAnimationDuration = Duration(milliseconds: 300);
const _kDefaultAnimationCurve = Curves.ease;

class ScrollPosController extends ScrollController {
  int itemCount;
  bool animate;
  Duration animationDuration;
  Curve animationCurve;

  ScrollPosController({
    this.itemCount = 0,
    this.animate = true,
    this.animationDuration = _kDefaultAnimationDuration,
    this.animationCurve = _kDefaultAnimationCurve,
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) : super(
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
          debugLabel: debugLabel,
        );

  double get inside => position.extentInside;

  double get max => position.maxScrollExtent;

  double get total => inside + max;

  double get scrollPerItem => total / itemCount;

  double get visibleItems => inside / scrollPerItem;

  void scrollTop({bool? animate}) {
    _scrollToPos(0, animate: animate);
  }

  void scrollBottom({bool? animate}) {
    _scrollToPos(max, animate: animate);
  }

  void scrollToItem(int index, {bool? animate, bool center = false}) {
    _scrollOffItem(index, animate: animate, center: center);
  }

  void _scrollToPos(double offset, {bool? animate}) {
    if (this.animate ||
        (animate ?? false) && animationDuration != Duration.zero) {
      animateTo(
        offset.clamp(0, max),
        duration: animationDuration,
        curve: animationCurve,
      );
    } else {
      jumpTo(offset.clamp(0, max));
    }
  }

  void _scrollOffItem(int index, {bool? animate, bool center = false}) {
    final centerVal = _scrollOffItemCenter(index);
    final bottomVal = _scrollOffItemBottom(index);
    final topVal = _scrollOffItemTop(index);

    if (center) {
      _scrollToPos(centerVal, animate: animate);
    } else if (offset < bottomVal) {
      _scrollToPos(bottomVal, animate: animate);
    } else if (offset > topVal) {
      _scrollToPos(topVal, animate: animate);
    }
  }

  double _scrollOffItemCenter(int index) {
    return (index + 1) * scrollPerItem - inside / 2;
  }

  double _scrollOffItemBottom(int index) {
    return (index + 1) * scrollPerItem - inside;
  }

  double _scrollOffItemTop(int index) {
    return index * scrollPerItem;
  }
}
