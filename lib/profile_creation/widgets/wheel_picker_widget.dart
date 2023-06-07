import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelPickerWidget extends StatefulWidget {
  final VoidCallback callback;

  const WheelPickerWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<WheelPickerWidget> createState() => _WheelPickerWidget();
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
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How many pushups can you do?',
            ),
            SizedBox(
              height: 350,
              child: CupertinoPicker(
                itemExtent: 64,
                children: items
                    .map((item) => Center(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ))
                    .toList(),
                onSelectedItemChanged: (index) {
                  setState(() => this.index = index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(
                  Icons.arrow_right_outlined,
                  size: 32,
                ),
                label: const Text(
                  'Next',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: widget.callback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
