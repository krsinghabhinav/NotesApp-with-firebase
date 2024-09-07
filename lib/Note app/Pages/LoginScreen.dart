import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:newfireabse/Note%20app/Pages/HomeScreen.dart';
import 'package:newfireabse/Note%20app/Pages/SignUpScreen.dart';
import 'package:newfireabse/Note%20app/Pages/forgotpassword.dart';
import 'package:newfireabse/message/toastmessage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  bool isloading = false; // For showing progress indicator
  bool _obscurePassword = true; // For password visibility

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login Screen',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 12),
              Lottie.asset(
                "assest/animation/Animation - 1725314276572.json",
                height: 330,
                width: 300,
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: loginEmailController,
                focusNode: emailFocusNode,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.email, size: 35),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(passwordFocusNode),
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: loginPasswordController,
                focusNode: passwordFocusNode,
                obscureText: _obscurePassword, // Toggle password visibility
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 35,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isloading = true; // Show progress indicator
                  });

                  // Dismiss the keyboard
                  FocusScope.of(context).unfocus();

                  var loginEmail = loginEmailController.text.trim();
                  var loginPassword = loginPasswordController.text.trim();

                  try {
                    final User? firebaseUser = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginEmail, password: loginPassword))
                        .user;

                    if (firebaseUser != null) {
                      Get.to(() => HomeScreen());
                      ToastUtil.showSuccess("User Login Successfully");
                    } else {
                      ToastUtil.showError(
                          "User not found. Check email and password.");
                    }
                  } on FirebaseAuthException catch (e) {
                    print('Error $e');
                    ToastUtil.showError(
                        "Error: ${e.message}"); // Improved error handling
                  } finally {
                    setState(() {
                      isloading = false; // Hide progress indicator
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
                        "Login",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(200, 45),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Get.to(() => ForgotPasswordScreen());
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Don't have an account",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignupScreen());
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
