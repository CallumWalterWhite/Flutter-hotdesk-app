import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../util/colour_palette.dart';
import '../../widgets/widget.dart';
import '../home.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  _SignUpScreenState();

  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> verifyEmail(
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      String email = _emailController.value.text;
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(email: email,),
          ),
        );
      } else {
        String name = _userNameController.value.text;
        String password = _passwordController.value.text;
        registerAccount(email, name, password, (e) =>
            ShowErrorDialog(context, 'Failed to create account', e));
      }
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: mainColour,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 80
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Username",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _userNameController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your username',
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter your username to continue';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Email address",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your email address',
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter your email address to continue';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Password",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your password',
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter your password to continue';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await verifyEmail((e) {
                            ShowErrorDialog(context, 'Failed to create account', e);
                          });
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Text(
                          'Register',
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                        child: const Icon(Icons.keyboard_arrow_left,
                            color: Colors.white),
                      ),
                      const Text('Back',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
