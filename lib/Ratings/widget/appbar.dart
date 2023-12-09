import 'package:flutter/material.dart';

AppBar myAppBar(String judul) {
  return AppBar(
    title: Text(
      judul,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
    ),
    backgroundColor: Colors.pink.shade400,
  );
}
