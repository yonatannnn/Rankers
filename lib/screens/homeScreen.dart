import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rankers/widgets/Drawer.dart';
import 'package:rankers/widgets/Ministry8result.dart';
import 'package:rankers/widgets/graduateStudentsList.dart';
import 'package:rankers/widgets/matric10nthStudetntList.dart';
import 'package:rankers/widgets/matric12thStudentList.dart';
import 'package:rankers/widgets/allStudentList.dart';
import 'package:rankers/widgets/firstRankStudentsList.dart';
import 'package:rankers/widgets/gradeSeparatorButton.dart';
import 'package:rankers/widgets/ministryResult.dart';
import 'package:rankers/widgets/secondRankStudents.dart';
import 'package:rankers/widgets/thirdRankStudents.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int chooseWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/books2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GradeSeparatorButton(
                        toBeWritten: 'Grades',
                        opacity: 0.5,
                        rank: 0,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 0;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '1',
                        opacity: 0.5,
                        rank: 1,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 1;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '2',
                        opacity: 0.5,
                        rank: 2,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 2;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '3',
                        opacity: 0.5,
                        rank: 3,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 3;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '6',
                        opacity: 0.5,
                        rank: 6,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 6;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '8',
                        opacity: 0.5,
                        rank: 8,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 8;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: '12',
                        opacity: 0.5,
                        rank: 12,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 12;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      GradeSeparatorButton(
                        toBeWritten: 'Graduates',
                        opacity: 0.5,
                        rank: -1,
                        onPressed: () {
                          setState(() {
                            chooseWidget = 13;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (chooseWidget == 0) ...[
                Allstudentlist(false),
              ] else if (chooseWidget == 1) ...[
                FirstRankStudentsList(false),
              ] else if (chooseWidget == 2) ...[
                SecondRankStudentsList(false),
              ] else if (chooseWidget == 3) ...[
                ThirdRankStudentsList(false),
              ] else if (chooseWidget == 6) ...[
                MinistryRankStudentsList(false),
              ] else if (chooseWidget == 8) ...[
                MinistryRank8StudentsList(false),
              ] else if (chooseWidget == 12) ...[
                Matric12RankStudentsList(showButton: false),
              ] else if (chooseWidget == 13) ...[
                GraduateStudentsList(false),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
