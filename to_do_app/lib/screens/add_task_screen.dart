import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/add_task';

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _addTask() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('myTasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time' : time.toString(),
      'timestamp': time,
    });
    Fluttertoast.showToast(msg: 'Task Added');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  label: Text('Enter title'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                label: Text('Enter description'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _addTask(),
              child: const Text('Add Task'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans'),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minimumSize: Size(size.width * 1.1, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
