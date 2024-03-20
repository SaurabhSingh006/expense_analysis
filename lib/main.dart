import 'package:expense_tracking/categories.dart';
import 'package:expense_tracking/create_category.dart';
import 'package:expense_tracking/create_expense.dart';
import 'package:expense_tracking/login_page.dart';
import 'package:expense_tracking/signup_page.dart';
import 'package:expense_tracking/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAQVTD6j-PfVYF4qPeZlLx6Gv8UhLqJFxw",
        appId: "1:940775000239:web:94af4e503e4a5c9e8e2c5a",
        messagingSenderId: "940775000239",
        projectId: "expense-tracking-3a6a1",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAQVTD6j-PfVYF4qPeZlLx6Gv8UhLqJFxw",
      appId: "1:940775000239:web:94af4e503e4a5c9e8e2c5a",
      messagingSenderId: "940775000239",
      projectId: "expense-tracking-3a6a1",
      )
    );
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) =>  const HomePage(),
        '/categories': (context) => const Categories(),
        '/createExpense': (context) => const CreateExpense(),
        '/createCategory': (context) => const CreateCategory()
      },
    );
  }
}
