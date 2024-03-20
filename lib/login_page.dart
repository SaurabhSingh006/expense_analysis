
import 'package:expense_tracking/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:expense_tracking/global/toast.dart';
import 'package:expense_tracking/signup_page.dart';
import 'package:expense_tracking/widgets/form_container_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: w,
                height: h*0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/loginimg.png'),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const Text(
                      "Sign into your account",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 50),
                    FormContainerWidget(
                      controller: _emailController,
                      hintText: "Email",
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    FormContainerWidget(
                      controller: _passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 30,),
                    GestureDetector(
                        onTap: () {
                          _signIn();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isSigning
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            textAlign: TextAlign.end,
                            "Forgot your password?",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ]
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ) 
            ],
          ),
        ),
      )
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if(email == "" || password == "") {
      showToast(message: "Please enter email or password");
      return;
    }
    setState(() {
      _isSigning = true;
    });

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      print(FirebaseAuth.instance.currentUser);
      showToast(message: "User is successfully signed in");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showToast(message: "some error occured");
    }
  }
}