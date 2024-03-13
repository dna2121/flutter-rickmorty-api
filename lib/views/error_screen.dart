import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.message, this.onPressed});

  final String message;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(message),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(onPressed: onPressed, child: const Text("Reload"))
      ],
    );
  }
}
