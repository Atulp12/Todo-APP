import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/add_task_screen.dart';
import 'package:to_do_app/screens/description_screen.dart';

class ToDoScreen extends StatefulWidget {
  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  String uId = '';

  @override
  void initState() {
    getUid();
    super.initState();
  }

  void getUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    setState(() {
      uId = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TDO APP',
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uId)
              .collection('myTasks')
              .snapshots(),
          builder: (ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapShot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var time =
                        (snapShot.data!.docs[index]['timestamp'] as Timestamp)
                            .toDate();
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Description(snapShot.data!.docs[index]['title'],snapShot.data!.docs[index]['description'] )));
                      },
                      child: Card(
                        elevation: 5,
                        color: Color.fromARGB(255, 198, 252, 239),
                        shadowColor: Color.fromARGB(255, 194, 254, 240),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        snapShot.data!.docs[index]['title'],
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 18,
                                            color: Colors.black),
                                      )),
                                      SizedBox(height: 2,),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      DateFormat.yMd().add_jm().format(time),
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: 'Quicksand'),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                child: IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(uId)
                                          .collection('myTasks')
                                          .doc(snapShot.data!.docs[index]['time'])
                                          .delete();
                                    },
                                    icon: Icon(Icons.delete)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
