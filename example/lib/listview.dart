import 'package:scroll_pos/scroll_pos.dart';
import 'package:flutter/material.dart';

class ExampleListView extends StatefulWidget {
  const ExampleListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExampleListViewState();
}

class _ExampleListViewState extends State<ExampleListView> {
  static const itemCount = 50;
  final controller = ScrollPosController(itemCount: itemCount);
  int selected = 0;
  bool center = false;

  void rebuild() => setState((){});

  @override
  void initState() {
    controller.addListener(rebuild);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(rebuild);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controls(context),
        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return ListTile(
                selected: selected == index,
                leading: Text('$index'),
                title: const Text('Tile'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _controls(BuildContext context) {
    Widget child;
    final items = _controlItems(context);
    if (MediaQuery.of(context).size.width > 700) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      );
    } else {
      child = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.getRange(0, 4).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.getRange(4, items.length).toList(),
          ),
        ],
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  List<Widget> _controlItems(BuildContext context) {
    return [
      _bt('Top', () {
        selected = 0;
        controller.scrollToStart();
      }),
      _bt('Bottom', () {
        selected = itemCount - 1;
        controller.scrollToEnd();
      }),
      _bt('Previous', () {
        if (selected > 0) {
          selected--;
        }
        controller.scrollToItem(selected, center: center);
      }),
      _bt('Next', () {
        if (selected < itemCount - 1) {
          selected++;
        }
        controller.scrollToItem(selected, center: center);
      }),
      _bt('Forward', () {
        controller.forward();
      }, enabled: controller.canForward),
      _bt('Backward', () {
        controller.backward();
      }, enabled: controller.canBackward),
      Row(
        children: [
          const Text('Animation:'),
          Switch(
            value: controller.animate,
            onChanged: (v) {
              setState(() {
                controller.animate = v;
              });
            },
          ),
        ],
      ),
      Row(
        children: [
          const Text('Center:'),
          Switch(
            value: center,
            onChanged: (v) {
              setState(() {
                center = v;
              });
            },
          ),
        ],
      ),
    ];
  }

  Widget _bt(String text, VoidCallback onPressed, {bool enabled = true}) {
    return TextButton(
      child: Text(text),
      onPressed: enabled ? () {
        setState(() {
          onPressed();
        });
      } : null,
    );
  }
}
