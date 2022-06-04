import 'package:flutter/material.dart';
import 'package:newsapp/Design.dart';
import 'package:newsapp/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class resetpassword extends StatefulWidget {
  const resetpassword({Key? key}) : super(key: key);

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

class _resetpasswordState extends State<resetpassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFB9E6FF),
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
                    height: size.height * 0.1,
                  ),
                  Center(
                    child: Text('  Reset\nPassword',
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),

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
                    height: size.height * 0.1,
                  ),
                  firebaseUIButton(context, "Reset Password", () async{
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(
                        email: _emailTextController.text.trim(),
                        ).then((value) {
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  }),
                  SizedBox(
                    height: size.height * .02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
