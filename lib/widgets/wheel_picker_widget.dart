import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelPickerWidget extends StatefulWidget {
  final formKey;
  final label;

  @override
  State<WheelPickerWidget> createState() => _WheelPickerWidget();
  const WheelPickerWidget({
    Key? key,
    required this.formKey,
    required this.label,
  }) : super(key: key);
}

class _WheelPickerWidget extends State<WheelPickerWidget> {
  final items = [
    'item 1',
    'item 2',
    'item 3',
    'item 4',
    'item 5',
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
      child: CupertinoPicker(
        itemExtent: 64,
        children: items
            .map((item) => Center(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 32),
                  ),
                ))
            .toList(),
        onSelectedItemChanged: (index) {
          setState(() => this.index = index);
        },
      ),
    ));
  }
}
