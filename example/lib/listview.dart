import 'package:extended_listview/extended_listview.dart';
import 'package:flutter/material.dart';

class ExampleAppContent extends StatefulWidget {
  const ExampleAppContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExampleAppContentState();
}

class _ExampleAppContentState extends State<ExampleAppContent> {
  static const itemCount = 100;
  final scrollPosController = ScrollPosController(itemCount: itemCount);
  int selected = 0;
  bool center = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controls(context),
        Expanded(
          child: ExtendedListView.builder(
            scrollPosController: scrollPosController,
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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bt('Top', () {
              selected = 0;
              scrollPosController.scrollTop();
            }),
            _bt('Bottom', () {
              selected = itemCount - 1;
              scrollPosController.scrollBottom();
            }),
            _bt('Previous', () {
              if (selected > 0) {
                selected--;
              }
              scrollPosController.scrollToItem(selected, center: center);
            }),
            _bt('Next', () {
              if (selected < itemCount - 1) {
                selected++;
              }
              scrollPosController.scrollToItem(selected, center: center);
            }),
            Row(
              children: [
                const Text('Animation:'),
                Switch(
                  value: scrollPosController.animate,
                  onChanged: (v) {
                    setState(() {
                      scrollPosController.animate = v;
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
          ],
        ),
      ),
    );
  }

  Widget _bt(String text, VoidCallback onPressed) {
    return TextButton(
      child: Text(text),
      onPressed: () {
        setState(() {
          onPressed();
        });
      },
    );
  }
}
