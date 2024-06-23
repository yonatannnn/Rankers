import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rankers/models/documentId.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/widgets/allStudentList.dart';

class Manage extends StatefulWidget {
  const Manage({Key? key}) : super(key: key);

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  int chooseWidg = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/books2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: Allstudentlist(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
