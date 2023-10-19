import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_pos/scroll_pos.dart';

class FakeScrollPosController extends ScrollPosController {
  double _offset = 0;
  final double _max;
  final double _inside;

  @override
  double get offset => _offset;

  @override
  double get inside => _inside;

  @override
  double get max => _max;

  FakeScrollPosController(
    this._max,
    this._inside,
    int itemCount,
  ) : super(itemCount: itemCount);

  @override
  void jumpTo(double offset) {
    _offset = offset;
  }

  @override
  Future<void> animateTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async {
    _offset = offset;
  }
}

void main() {
  const max = 200.0;
  const inside = 100.0;
  const itemCount = 15;

  final controller = FakeScrollPosController(max, inside, itemCount);
  final emptyController = FakeScrollPosController(0, 0, 0);

  test('Default values', () {
    expect(controller.animate, true);
    expect(controller.itemCount, itemCount);
  });

  test('Empty list', () {
    expect(emptyController.animate, true);
    expect(emptyController.itemCount, 0);
    expect(emptyController.scrollPerItem, 0);
    expect(emptyController.max, 0);
    expect(emptyController.offset, 0);
    emptyController.scrollToEnd();
    expect(emptyController.offset, 0);
  });

  test('Scroll per item', () {
    expect(controller.scrollPerItem, (max + inside) / itemCount);
  });

  test('Visible items', () {
    expect(controller.visibleItems, inside / controller.scrollPerItem);
  });

  test('ScrollBottom', () {
    controller.scrollToEnd();
    expect(controller.max != 0, true);
    expect(controller.offset, controller.max);
  });

  test('ScrollTop', () {
    controller.scrollToStart();
    expect(controller.offset, 0);
  });

  test('ScrollToItem-FromBottom-top', () {
    controller.scrollToEnd();
    controller.scrollToItem(0);
    expect(controller.offset, 0);
  });

  test('ScrollToItem-FromTop-bottom', () {
    controller.scrollToStart();
    controller.scrollToItem(itemCount - 1);
    expect(controller.offset, max);
  });

  test('ScrollToItem-FromTop-middle', () {
    controller.scrollToStart();
    controller.scrollToItem(itemCount - 2);
    expect(controller.offset, max - controller.scrollPerItem);
  });

  test('ScrollToItem-FromBottom-middle', () {
    controller.scrollToEnd();
    controller.scrollToItem(1);
    expect(controller.offset, controller.scrollPerItem);
  });

  test('ScrollToItem-top', () {
    controller.scrollToStart();
    controller.scrollToItem(0, center: true);
    expect(controller.offset, 0);
  });

  test('ScrollToItem-bottom', () {
    controller.scrollToStart();
    controller.scrollToItem(itemCount - 1, center: true);
    expect(controller.offset, max);
  });

  test('ScrollToItem-center', () {
    controller.scrollToStart();
    final idx = (itemCount / 2).floor();
    controller.scrollToItem(idx, center: true);
    expect(
        controller.offset, (idx + 1) * controller.scrollPerItem - inside / 2);
  });

  test('ScrollForward', () {
    controller.scrollToStart();
    controller.forward();
    final expected = controller.scrollPerItem;
    expect(controller.offset, expected);
  });

  test('ScrollBackward', () {
    controller.scrollToEnd();
    controller.scrollToItem(1);
    controller.backward();
    expect(controller.offset, 0);
  });

  test('Is At Start', (){
    controller.scrollToStart();
    expect(controller.atStart, true);
    controller.scrollToEnd();
    expect(controller.atStart, false);
  });

  test('Is At End', (){
    controller.scrollToStart();
    expect(controller.atEnd, false);
    controller.scrollToEnd();
    expect(controller.atEnd, true);
  });

  test('Can Forward', () {
    controller.scrollToStart();
    expect(controller.canForward, true);
    controller.scrollToEnd();
    expect(controller.canForward, false);
    controller.backward();
    expect(controller.canForward, true);
  });

  test('Can Backward', () {
    controller.scrollToStart();
    expect(controller.canBackward, false);
    controller.scrollToEnd();
    expect(controller.canBackward, true);
    controller.scrollToStart();
    expect(controller.canBackward, false);
    controller.forward();
    expect(controller.canBackward, true);
  });

  test('Page forward aligned', () {
    controller.scrollToStart();
    expect(controller.offset, 0);
    controller.forwardPage();
    expect(controller.offset, controller.visibleItems.floor() * controller.scrollPerItem);
  });

  test('Page backward aligned', () {
    controller.scrollToEnd();
    expect(controller.offset, max);
    controller.backwardPage();
    expect(controller.offset, max - controller.visibleItems.floor() * controller.scrollPerItem);
  });

  test('Page forward not aligned', () {
    controller.scrollToStart();
    expect(controller.offset, 0);
    controller.forwardPage(align: false);
    controller.forwardPage(align: false);
    expect(controller.offset, controller.inside * 2);
  });

  test('Page backward not aligned', () {
    controller.scrollToEnd();
    expect(controller.offset, max);
    controller.backwardPage(align: false);
    controller.backwardPage(align: false);
    expect(controller.offset, max - controller.inside * 2);
  });

  test('Page forward/backward start', () {
    controller.scrollToStart();
    expect(controller.offset, 0);
    controller.forwardPage();
    controller.backwardPage();
    expect(controller.offset, 0);
  });

  test('page forward/backward start', () {
    controller.scrollToEnd();
    expect(controller.offset, max);
    controller.backwardPage();
    controller.forwardPage();
    expect(controller.offset, max);
  });
}
