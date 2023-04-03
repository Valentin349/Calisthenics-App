import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelPickerWidget extends StatefulWidget {
  final void Function(int) callback;
  final String titleText;
  final List items;
  final bool? backButton;

  const WheelPickerWidget({
    Key? key,
    required this.titleText,
    required this.items,
    required this.callback,
    required this.backButton,
  }) : super(key: key);

  @override
  State<WheelPickerWidget> createState() => _WheelPickerWidget();
}

class _WheelPickerWidget extends State<WheelPickerWidget> {
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
            Text(
              widget.titleText,
            ),
            SizedBox(
              height: 350,
              child: CupertinoPicker(
                itemExtent: 64,
                children: widget.items
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
            createButton(),
          ],
        ),
      ),
    );
  }

  Widget createButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: (widget.backButton ?? false)
          ? Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.arrow_left_outlined,
                      size: 32,
                    ),
                    label: const Text(
                      'back',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.arrow_right_outlined,
                      size: 32,
                    ),
                    label: const Text(
                      'Next',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () => widget.callback(index),
                  ),
                ),
              ],
            )
          : ElevatedButton.icon(
              icon: const Icon(
                Icons.arrow_right_outlined,
                size: 32,
              ),
              label: const Text(
                'Next',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => widget.callback(index),
            ),
    );
  }
}
