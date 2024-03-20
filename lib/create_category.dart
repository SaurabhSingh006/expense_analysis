import 'dart:convert';

import 'package:expense_tracking/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:expense_tracking/global/toast.dart';
import 'package:expense_tracking/widgets/form_container_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  bool _isCreating = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 1, 66, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromRGBO(1, 1, 66, 1),
        title: const Text(
          "Create Category",
          style: TextStyle(
            color: Color.fromRGBO(207, 207, 207, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      FormContainerWidget(
                        controller: _titleController,
                        hintText: "Title",
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 10),
                      FormContainerWidget(
                        controller: _valueController,
                        hintText: "Value",
                        isPasswordField: false,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          _createCategory();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isCreating
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Create",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
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

  _createCategory() async {
    String title = _titleController.text;
    String value = _valueController.text;

    if(title == '' && value == '') {
      showToast(message: "Please enter title or value field");
      return;
    }
    setState(() {
      _isCreating = true;
    });

    final url = Uri.https('expense-tracking-3a6a1-default-rtdb.firebaseio.com', 'categories.json');
    final current = DateTime.now().toString();
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
    }, body: json.encode({
      'title': title,
      'value': value,
      'created_by': _firebaseAuth.currentUser?.uid,
      'created_at': current,
      'is_active': true
    }),);

    setState(() {
      _isCreating = false;
    });

    Navigator.pop(context);
  }
}