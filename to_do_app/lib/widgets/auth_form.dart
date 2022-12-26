import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String userName, String password,bool isLogin) submitFN;
  final bool isLoading;
  AuthForm(this.submitFN, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _username = '';
  var _password = '';

  void _toSubmit(){
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      _formKey.currentState!.save();
      widget.submitFN(_email.trim() , _username.trim(),_password.trim(), _isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      // padding: const EdgeInsets.all(12),
      elevation: 5,
      margin:  EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  enableSuggestions: false,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid Email Address.';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _email = value!;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                if (!_isLogin)
                TextFormField(
                    key: ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        icon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)))),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _username = value!;
                    },
                  ),
                if(!_isLogin)
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.password),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be contain at least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _password = value!;
                  },
                ),
                  SizedBox(
                  height: size.height * 0.05,
                  ),
                if(widget.isLoading) CircularProgressIndicator(),
                if(!widget.isLoading)
                ElevatedButton.icon(
                  onPressed: _toSubmit,
                  label: Text(_isLogin ? 'Login' : 'Sign Up'),
                  icon: Icon(_isLogin ? Icons.login : Icons.person_add),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'OpenSans'),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minimumSize: Size(size.width * 0.6, 50),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                if(!widget.isLoading)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin ? 'Create new account' : 'I have already account'),
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'OpenSans',
                    ),
                    // elevation: 5,
                    // backgroundColor: const Color.fromARGB(255, 223, 218, 218),
                    // foregroundColor: Colors.black,
                    minimumSize: Size(size.width * 0.6, 50),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
