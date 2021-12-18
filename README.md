# Scroll Position 

Provides some additional functions to ScrollController
to define item position relative to the screen.

![scrollpos_demo](https://user-images.githubusercontent.com/8223773/146646121-c7b702d4-e82e-4d95-b1b0-85377d7d3745.gif)

> Note: this works on condition that all items have the same height !

## Usage

```dart
// Create a ScrollPosController (don't forget to set and update itemCount !)
final controller = ScrollPosController(itemCount: itemCount);

// Assign the controller to a scrollable item (like an ListView)
ListView(
  controller: controller,
  children: [
    ...
  ];
);

// Control the controller
TextButton(
  child: Text('To item'),
  onPressed: () {
    setState(() {
      controller.scrollToItem(index);
    });
  },
);
```

## Main methods

- `void scrollTop({bool? animate})` : Go to the first item
- `void scrollBottom({bool? animate})` : Go to the last item
- `void scrollToItem(int index, {bool? animate, bool center = false})` : Makes the item visible on the screen 