import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  List<DocumentSnapshot> _expenses = [];
  List _categories = [];
  bool _isLoadingExpenses = true;

  @override
  // ignore: must_call_super
  initState() {
     _getCategories();
  }

  _getCategories() async {
    // final url = Uri.https('expense-tracking-3a6a1-default-rtdb.firebaseio.com', ca)
    // const response = await http.get();

    //_categories = await categoryRef.get();
    DatabaseEvent data = await ref.once();
    print(json.decode(json.encode(data.snapshot.value)));

    for(final item in json.decode(json.encode(data.snapshot.value)).entries) {
      print(item);
    }
    
    // Query q = _fireStore.collection("expense_categories").orderBy("title");
    // QuerySnapshot querySnapshot = await q.get();
    // _categories = querySnapshot.docs;
    // print(_categories);
    // return querySnapshot.docs;
  }

  _getExpenses() async {
    // Query q = _fireStore.collection("expenses").orderBy("created_at").limit(10);

    // setState(() {
    //   _isLoadingExpenses = true;
    // });
    // try {
    //   QuerySnapshot querySnapshot = await q.get();
    //   _expenses = querySnapshot.docs;
    // } catch(err) {
    //   print(err);
    // }
    
    
    // // print(_expenses.length);
    // // print(_expenses[1].data());
    // setState(() {
    //   _isLoadingExpenses = false;
    // });
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Expenses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                      FilledButton.tonal(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Color.fromARGB(255, 51, 206, 59)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context,"/createExpense");
                        },
                        child: const Text("Add New Expense", style: TextStyle(color: Colors.white),)
                      )
                    ]
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200.0,
                          child: StreamBuilder(
                            stream: ref.onValue,
                            builder: (context,
                                AsyncSnapshot<DatabaseEvent> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              } else {
                              Map<dynamic, dynamic> map =
                                  snapshot.data?.snapshot.value as dynamic;
                              List<dynamic> list = [];
                              list.clear();
                              list = map.values.toList();
                                          
                              return ListView.builder(
                                itemCount: snapshot.data?.snapshot.children.length,
                                itemBuilder: (context, index) {
                                  final titlecomp = '${index + 1}. ' +
                                      list[index]['description'];
                                  return ListTile(
                                    title: Text(
                                      titlecomp,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                    subtitle:
                                        Text(list[index]['amount']),
                                  );
                                });
                              }
                            },
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
}