import 'package:flutter/material.dart';
import 'package:getfit2/userprovider.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';
import 'database/connection.dart';
import 'main.dart';
import 'sign_up.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> with TickerProviderStateMixin {
  // String data = '';
  final RegExp emailRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[_\W]).{6,}$');
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ImageProvider loginGif = const AssetImage('images/login_gif-min.gif');
  late GifController _controller;
  bool invalidDetails = false;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
    _controller.value = 0;
    _controller.animateTo(29,
        duration:
            const Duration(milliseconds: 1000)); // Play the gif in 1 second

    // final databaseReference = FirebaseDatabase.instance.ref();

    // databaseReference.child('sensor_data').limitToLast(1).onValue.listen((event) {
    //   final newData = event.snapshot.value.toString();
    //   setState(() {
    //     data = newData;
    //     print(data);
    //   });
    // });
    
  }

  @override
  void dispose() {
    _controller.dispose(); // dispose the AnimationController
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 150,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: Transform.scale(
          scale: 0.7,
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 50.0),
                    child: Text(
                      'Login',
                      style: GoogleFonts.getFont(
                        'Lato',
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF50B0FF),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/dumbell.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Gif(
                      controller: _controller,
                      fps: 30,
                      autostart: Autostart.loop,
                      placeholder: (context) => const Text('Loading...'),
                      image: loginGif,
                    ),
                  ),
                ),
              ),
              Padding(
                // padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter your email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@gmail.com')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                // padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
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
              Opacity(
                opacity: invalidDetails ? 1.0 : 0.0,
                child: const Text(
                  'Invalid Login Details',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //TODO
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () async {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    // predictWorkout();
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();
                    await selectUsers(
                        _emailController.text, _passwordController.text);
                    if (userselected) {
                      userselected = false;
                      userProvider.setEmail(_emailController.text);
                      navigatorKey.currentState!
                          .pushReplacementNamed('/homepage');
                    } else {
                      setState(() {
                        invalidDetails = true;
                      });
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'New User? ',
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Create Account',
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
