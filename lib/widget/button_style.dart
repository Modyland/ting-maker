import 'package:flutter/material.dart';

ElevatedButton cropButton(String text, Icon icon, VoidCallback callback) {
  return ElevatedButton(
    style: const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.white),
      padding: MaterialStatePropertyAll(
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
