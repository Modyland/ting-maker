import 'package:flutter/material.dart';

ElevatedButton cropButton(String text, Icon icon, VoidCallback callback) {
  return ElevatedButton(
    style: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.white),
      padding: WidgetStatePropertyAll(
        EdgeInsets.fromLTRB(12, 8, 12, 8),
      ),
    ),
    child: Row(
      children: [
        icon,
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    ),
    onPressed: () => callback(),
  );
}
