import 'dart:convert';
import 'dart:ffi';
// import 'package:expense_tracking/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:expense_tracking/global/toast.dart';
import 'package:expense_tracking/widgets/form_container_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class CreateExpense extends StatefulWidget {
  const CreateExpense({super.key});

  @override
  State<CreateExpense> createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  bool isLoading = false;
  bool _isCreating = false;
  String categoryId = "";
  List<dynamic> categories = [];
  final List<DropdownMenuEntry<String>> category_menu_list = [];
  // final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveCategory();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(1, 1, 66, 1),
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: const Color.fromRGBO(1, 1, 66, 1),
            title: const Text(
              "Add Expense",
              style: TextStyle(
                color: Color.fromRGBO(207, 207, 207, 1),
              ),
            ),
          ),
          body: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  FormContainerWidget(
                    controller: _descriptionController,
                    hintText: "Description",
                    isPasswordField: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormContainerWidget(
                    controller: _amountController,
                    isPasswordField: false,
                    inputType: TextInputType.number,
                    hintText: "Amount",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownMenu<String>(
                    hintText: "Select Category",
                    controller: _categoryController,
                    initialSelection: categoryId,
                    onSelected: (value) {
                      categoryId = value!;
                      // This is called when the user selects an item.
                      setState(() {
                        // dropdownValue = value!;
                      });
                    },
                    expandedInsets: EdgeInsets.zero,
                    
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                  
                      )
                    ),
                    dropdownMenuEntries: categories.map((menu) {
                      return DropdownMenuEntry<String>(value: menu["value"], label: menu["title"]);
                    }).toList()
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        _createExpense();
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
                                  "Add expense",
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
          ),
        ),
      ),
    );
  }

  _retrieveCategory() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.https('expense-tracking-3a6a1-default-rtdb.firebaseio.com', 'categories.json');
    final response = await http.get(url);
    Map dataObj = {};
    json.decode(response.body).keys.toList().forEach((value) {
      dataObj['title'] = json.decode(response.body)[value]['title'];
      dataObj['value'] = value;
      categories.add(dataObj);
      dataObj = {};
    });
    setState(() {
      isLoading = false;
    });
  }

  _createExpense() async {
    String description = _descriptionController.text;
    String amount = _amountController.text;
    // String categoryId = _categoryController;

    print(categoryId);
    final current = DateTime.now().toString();
    
    if(description == '' && amount == '' && categoryId == "") {
      showToast(message: "Please enter all the field");
      return;
    }
    setState(() {
      _isCreating = true;
    });

    final url = Uri.https('expense-tracking-3a6a1-default-rtdb.firebaseio.com', 'expenses.json');
    
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
    }, body: json.encode({
      'description': description,
      'amount': amount,
      'created_by': _firebaseAuth.currentUser?.uid,
      'created_at': current,
      'is_active': true,
      'categoryId': categoryId
    }),);

    setState(() {
      _isCreating = false;
    });

    Navigator.pop(context);
  }
}