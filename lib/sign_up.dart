import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'database/connection.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  Timer? _debounce;
  final RegExp emailRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[_\W]).{6,}$');

  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _dateOfBirth;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _emailExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: TextFormField(
                  controller: _controllers[0],
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Full Name is Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextFormField(
                    controller: _controllers[1]
                    ..addListener(() {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 500), () async {
                        _emailExists = await emailExists(_controllers[1].text);
                        setState(() {});
                      });
                    }),
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is Required';
                      } else if (!value.contains('@gmail.com')) {
                        return 'Invalid email';
                      }

                      if (_emailExists) {
                        return 'Email already exists';
                      }
                      return null;
                    },autovalidateMode: AutovalidateMode.onUserInteraction,),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextFormField(
                  controller: _controllers[2],
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Invalid. Must be upper, lowercase, number and special character.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextFormField(
                  controller: _controllers[3],
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Date of Birth is Required';
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());
                    if (picked != null && picked != _dateOfBirth) {
                      setState(() {
                        _dateOfBirth = picked;
                        _controllers[3].text =
                            DateFormat('yyyy-MM-dd').format(picked);
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextFormField(
                  controller: _controllers[4],
                  decoration: const InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Weight is Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextFormField(
                  controller: _controllers[5],
                  decoration: const InputDecoration(labelText: 'Height'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Height is Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  // if (!_formKey.currentState!.validate()) {
                  //   return;
                  // }
                  // _formKey.currentState!.save();

                  Fluttertoast.showToast(
                      msg: "Register Success",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                      
                  //Send data to sqlite server
                  // insertUser(_controllers.cast<String>(), _formKey);
                  // Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
