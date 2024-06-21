import 'package:flutter/material.dart';
import 'package:rankers/screens/loginScreen.dart';
import 'package:rankers/services/authService.dart';
import 'package:rankers/utils/text.dart';
import 'package:rankers/widgets/text_field.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  void signup() async {
    final authService = AuthService();
    if (!_isValidEmail(widget._emailController.text)) {
      return _showErrorDialog('invalid email');
    }

    if (!_isValidPassword(widget._passwordController.text)) {
      return _showErrorDialog('Password must be at least 6 characters long');
    }
    try {
      if (widget._confirmPasswordController.text ==
          widget._passwordController.text) {
        await authService.signup(
            widget._emailController.text, widget._passwordController.text);
        print('successful');
      } else {
        _showErrorDialog('Passwords do not match');
      }
    } catch (e) {
      print('error ${e}');
    }
  }

  bool _isSimilar(String password, confirmPassword) {
    return password == confirmPassword;
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
          child: Container(
              height: 500,
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.4),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Spacer(),
                    Center(
                        child: TextUtil(
                      text: "Sign Up",
                      weight: true,
                      size: 30,
                    )),
                    const Spacer(),
                    CustomTextField(
                        hintText: "Email", controller: widget._emailController),
                    const Spacer(),
                    CustomTextField(
                        hintText: "Password",
                        controller: widget._passwordController),
                    const Spacer(),
                    CustomTextField(
                        hintText: "confirm password",
                        controller: widget._confirmPasswordController),
                    const Spacer(),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        signup();
                      },
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
                          "Sign Up",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }),
                        );
                      },
                      child: Center(
                        child: TextUtil(
                          text: "have an account? Login",
                          size: 12,
                          weight: true,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
