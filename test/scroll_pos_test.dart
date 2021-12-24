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

  test('Default values', () {
    expect(controller.animate, true);
    expect(controller.itemCount, itemCount);
  });

  test('Scroll per item', () {
    expect(controller.scrollPerItem, (max + inside) / itemCount);
  });

  test('Visible items', () {
    expect(controller.visibleItems, inside / controller.scrollPerItem);
  });

  test('ScrollBottom', () {
    controller.scrollBottom();
    expect(controller.max != 0, true);
    expect(controller.offset, controller.max);
  });

  test('ScrollTop', () {
    controller.scrollTop();
    expect(controller.offset, 0);
  });

  test('ScrollToItem-FromBottom-top', () {
    controller.scrollBottom();
    controller.scrollToItem(0);
    expect(controller.offset, 0);
  });

  test('ScrollToItem-FromTop-bottom', () {
    controller.scrollTop();
    controller.scrollToItem(itemCount - 1);
    expect(controller.offset, max);
  });

  test('ScrollToItem-FromTop-middle', () {
    controller.scrollTop();
    controller.scrollToItem(itemCount - 2);
    expect(controller.offset, max - controller.scrollPerItem);
  });

  test('ScrollToItem-FromBottom-middle', () {
    controller.scrollBottom();
    controller.scrollToItem(1);
    expect(controller.offset, controller.scrollPerItem);
  });

  test('ScrollToItem-top', () {
    controller.scrollTop();
    controller.scrollToItem(0, center: true);
    expect(controller.offset, 0);
  });

  test('ScrollToItem-bottom', () {
    controller.scrollTop();
    controller.scrollToItem(itemCount - 1, center: true);
    expect(controller.offset, max);
  });

  test('ScrollToItem-center', () {
    controller.scrollTop();
    final idx = (itemCount / 2).floor();
    controller.scrollToItem(idx, center: true);
    expect(
        controller.offset, (idx + 1) * controller.scrollPerItem - inside / 2);
  });

  test('ScrollForward', () {
    controller.scrollTop();
    controller.forward();
    final expected = controller.scrollPerItem;
    expect(controller.offset, expected);
  });

  test('ScrollBackward', () {
    controller.scrollBottom();
    controller.scrollToItem(1);
    controller.backward();
    expect(controller.offset, 0);
  });
}
