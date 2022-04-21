// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, constant_identifier_names, unnecessary_new

import 'package:fanboos/Model/constants.dart';
import 'package:flutter/material.dart';

class FollowUpToDoList extends StatefulWidget {
  @override
  _FollowUpToDoListState createState() => _FollowUpToDoListState();
}

class _FollowUpToDoListState extends State<FollowUpToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text(
          'Follow Up To Do List',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: bodyMethod(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AlertDialog(
            title: Text('data'),
          );
        },
        tooltip: 'Simpan Follow UP',
        child: Icon(Icons.save_outlined),
      ),
    );
  }

  Column bodyMethod(context) {
    var dataSimpanFollowUp = TextEditingController();

    var hScreen = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var wScreen = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: hScreen * 0.27,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: Colors.grey,
                blurRadius: 3.0,
                offset: Offset(0.0, 1.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new TextField(
              controller: dataSimpanFollowUp,
              minLines: 10,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Masukan Follow Up Baru',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 30,
          margin: const EdgeInsets.all(10),
          // color: Colors.blue,
          child: Row(
            children: [Text('Pic.'), Icon(Icons.people)],
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 30,
          margin: const EdgeInsets.all(10),
          // color: Colors.blue,
          child: Row(
            children: [Text('Due.'), Icon(Icons.date_range_outlined)],
          ),
        )
      ],
    );
  }
}



