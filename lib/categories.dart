import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final ref = FirebaseDatabase.instance.ref('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(1,1,66,1),
      appBar: AppBar(
        iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
        ),
         actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create category',
            onPressed: () {
              Navigator.pushNamed(context, "/createCategory");
            },
          )
        ],
        backgroundColor: const Color.fromRGBO(1,1,66,1),
        title: const Text("Categories", style: TextStyle(color: Color.fromRGBO(207, 207, 207, 1),),),
        
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
                if(!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  Map<dynamic, dynamic> map = snapshot.data?.snapshot.value as dynamic;
                  List<dynamic> list =[];
                  list.clear();
                  list = map.values.toList();

                  return ListView.builder(
                      itemCount: snapshot.data?.snapshot.children.length,
                      itemBuilder: (context, index) {
                        final titlecomp = (index + 1).toString() + '. ' + list[index]['title'];
                        return ListTile(
                          title: Text(titlecomp, style: const TextStyle(color: Colors.white, fontSize: 20),),
                          subtitle: Text(list[index]['created_at']),
                        );
                      });
                }
              },
            ),
          ),
          ]
        ),
      ),
    );
  }
}