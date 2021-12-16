import 'package:flutter/widgets.dart';

const _kDefaultAnimationDuration = Duration(milliseconds: 300);
const _kDefaultAnimationCurve = Curves.ease;

class ScrollPosController {
  late final ScrollController scrollController;
  int itemCount;
  bool animate;
  Duration animationDuration;
  Curve animationCurve;

  ScrollPosController({
    ScrollController? scrollController,
    this.itemCount = 0,
    this.animate = true,
    this.animationDuration = _kDefaultAnimationDuration,
    this.animationCurve = _kDefaultAnimationCurve,
  }) {
    this.scrollController = scrollController ?? ScrollController();
  }

  double get offset => scrollController.offset;

  double get inside => scrollController.position.extentInside;

  double get max => scrollController.position.maxScrollExtent;

  double get total => inside + max;

  double get scrollPerItem => total / itemCount;

  double get visibleItems => inside / scrollPerItem;

  void scrollTop({bool? animate}) {
    _scrollToPos(0, animate: animate);
  }

  void scrollBottom({bool? animate}) {
    _scrollToPos(scrollController.position.maxScrollExtent, animate: animate);
  }

  void scrollToItem(int index, {bool? animate, bool center = false}) {
    _scrollOffItem(index, animate: animate, center: center);
  }

  void _scrollToPos(double offset, {bool? animate}) {
    if (offset < 0) {
      offset = 0;
    }
    if (offset > scrollController.position.maxScrollExtent) {
      offset = scrollController.position.maxScrollExtent;
    }

    if (this.animate ||
        (animate ?? false) && animationDuration != Duration.zero) {
      scrollController.animateTo(
        offset,
        duration: animationDuration,
        curve: animationCurve,
      );
    } else {
      scrollController.jumpTo(offset);
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
