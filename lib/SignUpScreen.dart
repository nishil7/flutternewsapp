import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsapp/widget.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Design.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFB2DDF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              height: size.height * 0.5,
              width: size.width * 0.5,
              child: CustomPaint(
                painter: SignupHeaderCircle(),
              ),
            ),
            Positioned(
              height: size.height * 0.55,
              width: size.width,
              bottom: 0,
              child: CustomPaint(
                painter: SignupFooterCircle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0 * 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * .06,
                  ),
                  Text('Create\nAccount',
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  reusableTextField("Enter Name", Icons.person_outline, false,
                      _userNameTextController),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  reusableTextField("Enter Email Id", Icons.mail,
                      false, _emailTextController),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outlined, true,
                      _passwordTextController),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: size.height * .04,
                  ),
                  firebaseUIButton(context, "Sign Up", () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      print("Created New Account");
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
