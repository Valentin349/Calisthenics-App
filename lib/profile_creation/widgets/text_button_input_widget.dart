import 'package:flutter/material.dart';

class TextButtonFormWidget extends StatelessWidget {
  const TextButtonFormWidget({
    super.key,
    required this.formKey,
    required this.textController,
    required this.label,
    required this.callback,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: textController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(label: Text(label)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 3
                  ? 'Enter min. 3 characters'
                  : null,
            ),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton.icon(
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
              onPressed: callback,
            ),
          ],
        ),
      ),
    );
  }
}
