import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rankers/screens/addStudentScreen.dart';
import 'package:rankers/screens/homeScreen.dart';
import 'package:rankers/screens/loginScreen.dart';
import 'package:rankers/services/authService.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void logout(BuildContext context) {
    final as = AuthService();
    try {
      as.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/books2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Homescreen()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () => logout(context),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add Student',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Background color
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddScreen()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Add more buttons or widgets here as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
