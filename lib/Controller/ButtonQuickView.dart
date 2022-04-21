// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, must_be_immutable, unused_field, use_key_in_widget_constructors, no_logic_in_create_state

import 'package:fanboos/Controller/Keluhan/Keluhan.dart';
import 'package:fanboos/Controller/MRIT/MR.dart';
import 'package:fanboos/Controller/Things2Do/Things2Do.dart';
import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ButtonQuickView extends StatefulWidget {
  final IconData _iconData;
  final String JudulButton;

  @override
  _MRITState createState() => _MRITState(_iconData, JudulButton);

  const ButtonQuickView(this._iconData, this.JudulButton);
}

class _MRITState extends State<ButtonQuickView> {
  bool isPressed = false;

  final IconData iConData;
  String JudulButton;
  _MRITState(this.iConData, this.JudulButton);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
          height: 50,
          width: 50,
          child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                isPressed = !isPressed;
              });
            },
            onTapUp: (details) {
              setState(() {
                isPressed = !isPressed;
              });
            },
            onTapCancel: () {
              setState(() {
                isPressed = !isPressed;
              });
            },
            onTap: () {
              setState(() {
                switch (JudulButton) {
                  case 'MR':
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MRIT()));
                    }
                    break;

                  case 'Things To Do':
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Things2Do()));
                    }
                    break;
                  case 'Keluhan':
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Keluhan()));
                    }
                    break;

                }
              });
            },
            child: Transform.rotate(
              angle: pi / 4,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 10,
                color: (isPressed) ? Colors.blueAccent : kPrimaryColor,
                // child: const Icon(Icons.add_task, size: 25),
                child: Transform.rotate(
                    angle: -pi / 4,
                    child: Icon(
                      iConData,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
          child: Text(JudulButton),
        )
      ],
    );
  }
}
