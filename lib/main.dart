import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rankers/firebase_options.dart';
import 'package:rankers/screens/addStudentScreen.dart';
import 'package:rankers/screens/homeScreen.dart';
import 'package:rankers/screens/registrationScreen.dart';
import 'package:rankers/services/authService.dart';
import './screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CheckScreen());
  }
}

class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context);
    print(authProvider.user);
    if (authProvider.user == null) {
      return LoginScreen();
    } else {
      return AddScreen();
    }
  }
}
