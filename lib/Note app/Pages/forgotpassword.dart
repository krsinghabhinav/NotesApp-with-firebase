import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newfireabse/Note%20app/Pages/LoginScreen.dart';
import 'package:newfireabse/message/toastmessage.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgotPassEmailController = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Forgot Password',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assest/animation/forgpass.png",
                height: 300,
                width: double.infinity,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: forgotPassEmailController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          size: 35,
                        ),
                        hintText: "Emial",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isloading = true; // Show progress indicator
                  });
                  var forgotEmail = forgotPassEmailController.text.trim();
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: forgotEmail)
                        .then((value) => {
                              Get.off(() => LoginScreen()),
                              ToastUtil.showInfo("Email sent check your email"),
                              print("Email Sent!!!"),
                            });
                  } on FirebaseAuthException catch (e) {
                    ToastUtil.showInfo("Email is not correct ");

                    print("Error $e");
                    setState(() {
                      isloading = true; // Show progress indicator
                    });
                  }
                },
                child: isloading
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(200, 45),
                  // Set the width and height here
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
