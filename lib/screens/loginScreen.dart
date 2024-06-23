import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rankers/screens/homeScreen.dart';
import 'package:rankers/screens/registrationScreen.dart';
import 'package:rankers/services/authService.dart';
import 'package:rankers/utils/text.dart';
import 'package:rankers/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true;
    });

    if (!_isValidEmail(widget._emailController.text)) {
      _showErrorDialog("Invalid Email");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!_isValidPassword(widget._passwordController.text)) {
      _showErrorDialog("Invalid Password");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final authService = AuthService();
    try {
      await authService.login(
          widget._emailController.text, widget._passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool _isValidPassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/books2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 400,
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.4),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Spacer(),
                    TextUtil(
                      text: "Login",
                      weight: true,
                      size: 30,
                    ),
                    Spacer(),
                    CustomTextField(
                      hintText: "Email",
                      controller: widget._emailController,
                    ),
                    Spacer(),
                    CustomTextField(
                      hintText: "Password",
                      controller: widget._passwordController,
                    ),
                    Spacer(),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "Log In",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RegistrationScreen();
                          }),
                        );
                      },
                      child: TextUtil(
                        text: "Don't have an account? REGISTER",
                        size: 12,
                        weight: true,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
