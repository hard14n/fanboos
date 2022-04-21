// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({Key? key}) : super(key: key);

  @override
  _BeritaScreenState createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text('Berita Screen')),
    );
  }
}
