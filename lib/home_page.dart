import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseReference categoryRef = FirebaseDatabase.instance.ref('categories');
  final ref = FirebaseDatabase.instance.ref('expenses');

  // FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List _expenses = [];
  Map _categories = {};
  bool _isLoadingExpenses = true;

  @override
  // ignore: must_call_super
  initState() {
    _getCategories();
  }

  _getCategories() async {
    //_categories = await categoryRef.get();
    DatabaseEvent data = await categoryRef.once();
    _categories = json.decode(json.encode(data.snapshot.value));

    DatabaseEvent dataExp = await ref.once();
    List expensee = json.decode(json.encode(dataExp.snapshot.value)).values.toList();
    for (var i = 0; i < expensee.length; i++) {
      // TO DO
      if(expensee[i]['created_by'] == _firebaseAuth.currentUser?.uid) {
        _expenses.add(expensee[i]);
      }
    }

    setState(() {
      _isLoadingExpenses = false;
    });
    
    // Query q = _fireStore.collection("expense_categories").orderBy("title");
    // QuerySnapshot querySnapshot = await q.get();
    // _categories = querySnapshot.docs;
    // print(_categories);
    // return querySnapshot.docs;
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
              "Dashboard",
              style: TextStyle(color: Color.fromRGBO(207, 207, 207, 1)),
            ),
            actions: [
              PopupMenuButton(
                onSelected: (value) => {
                  if(value == 1) {
                    Navigator.pushNamed(context, "/categories")
                  } else if(value == 2) {
                    FirebaseAuth.instance.signOut(),
                    Navigator.pushReplacementNamed(context, "/")
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(value: 1, child: Text("Expense categories")),
                    const PopupMenuItem(value: 2, child: Text("Log Out"))
                  ];
              })
            ],
          ),
          body: DefaultTextStyle(
            style: const TextStyle(color: Color.fromRGBO(207, 207, 207, 1)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          if(_isLoadingExpenses) {
                            return const Text("Loading...");
                          } else {
                            return Expanded(
                              child: SizedBox(
                                height: _isLoadingExpenses || _expenses.length == 0 ? 0 : 200.0,
                                child: PieChart(PieChartData(
                                  sectionsSpace: 10, sections: pieChartSections())),
                              ),
                            );
                          }
                        }
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Expenses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                      FilledButton.tonal(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Color.fromARGB(255, 51, 206, 59)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context,"/createExpense").then((value) => setState(() {
                            _isLoadingExpenses = true;
                            _getCategories();
                          }));
                        },
                        child: const Text("Add New Expense", style: TextStyle(color: Colors.white),)
                      )
                    ]
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 400.0,
                          child: DelayedDisplay(
                            delay: const Duration(milliseconds: 200),
                            child: StreamBuilder(
                              stream: ref.onValue,
                              builder: (context,
                                  AsyncSnapshot<DatabaseEvent> snapshot) {
                                    if(_expenses.length == 0) {
                                      return const Center(
                                        child: Text("Please add expenses", style: TextStyle(fontSize: 25),),
                                      );
                                    }

                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                } else {
                                Map<dynamic, dynamic> map = snapshot.data?.snapshot.value as dynamic;
                                List<dynamic> list = [];
                                list.clear();
                                list = map.values.toList();
                                            
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.snapshot.children.length,
                                  itemBuilder: (context, index) {
                                    if(_firebaseAuth.currentUser?.uid != list[index]['created_by']) {
                                      return const SizedBox.shrink();
                                    }

                                    final titlecomp = list[index]['description'];
                                    return ListTile(
                                      title: Text(titlecomp,style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text('INR ' + list[index]['amount'], style: const TextStyle(color: Colors.red),),
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],)
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> pieChartSections() {
    List colorList = [
      const Color.fromRGBO(205, 250, 219, 1),
      const Color.fromRGBO(0, 121, 255,1),
      const Color.fromRGBO(247, 65, 143,1),
      const Color.fromRGBO(246, 250, 112, 1),
      const Color.fromRGBO(123, 211, 234,1),
      const Color.fromRGBO(131, 162, 255,1),
      const Color.fromRGBO(246, 253, 195,1),
      const Color.fromRGBO(255, 207, 150,1),
      const Color.fromRGBO(255, 128, 128, 1),
      const Color.fromRGBO(76, 205, 153,1),
      const Color.fromRGBO(255, 128, 128,1),
    ];
      return List.generate(_expenses.length, (index) {
        final amount = double.parse(_expenses[index]['amount']);
        final categoryid = _categories[_expenses[index]['categoryId']]['title'] + '- ' + amount.toString();
        
        return PieChartSectionData(
          color: colorList[index],
          value:amount,
          title: categoryid,
          titleStyle: const TextStyle(backgroundColor: Colors.black, fontWeight: FontWeight.bold)
        );
      });
  }
}