import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitForm(
      String email, String username, String password, bool isLogin) async {
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': username, 'email': email});
      }
    } on PlatformException catch (err) {
      var message = 'An error occured';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                // height: size.height * 0.3,
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.all(12),
                child: const Text(
                  'Welcome to TDO APP!!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand'),
                )),
            AuthForm(_submitForm,isLoading),
          ],
        ),
      ),
    );
  }
}
