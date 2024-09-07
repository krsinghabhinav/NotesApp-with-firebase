import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:newfireabse/Note%20app/Pages/LoginScreen.dart';
import 'package:newfireabse/Note%20app/services/signupService.dart';
import 'package:newfireabse/message/toastmessage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();

  bool isSignup = false;
  bool _obscurePassword = true;

  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode userPhoneFocusNode = FocusNode();
  final FocusNode userEmailFocusNode = FocusNode();
  final FocusNode userPasswordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void dispose() {
    userNameController.dispose();
    userPhoneController.dispose();
    userEmailController.dispose();
    userPasswordController.dispose();
    userNameFocusNode.dispose();
    userPhoneFocusNode.dispose();
    userEmailFocusNode.dispose();
    userPasswordFocusNode.dispose();
    super.dispose();
  }

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
          'Signup Screen',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Close the keyboard when tapping outside of the text fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey, // Add Form widget
              child: Column(
                children: [
                  Lottie.asset(
                      "assest/animation/Animation - 1725328181860.json",
                      height: 280,
                      width: 400),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: userNameController,
                    focusNode: userNameFocusNode,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          size: 35,
                        ),
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(userPhoneFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: userPhoneController,
                    focusNode: userPhoneFocusNode,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.phone_android,
                          size: 35,
                        ),
                        hintText: "Phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(userEmailFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      final phone = value.trim();
                      if (phone.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: userEmailController,
                    focusNode: userEmailFocusNode,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.email,
                        size: 35,
                      ),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(userPasswordFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      // Regex for validating emails
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  myCustomWidget(),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isSignup = true;
                            });

                            var userName = userNameController.text.trim();
                            var userPhone = userPhoneController.text.trim();
                            var userEmail = userEmailController.text.trim();
                            var userPassword =
                                userPasswordController.text.trim();

                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                              );
                              await signUpUser(
                                  userName, userPhone, userEmail, userPassword);

                              ToastUtil.showSuccess("User Successfully SignUp");
                              print("User Signed Up Successfully!");
                            } catch (e) {
                              ToastUtil.showError("Sign Up Failed: $e");
                            } finally {
                              setState(() {
                                isSignup = false;
                              });
                            }
                          }
                        },
                        child: isSignup
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Sign Up",
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
                    ],
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => LoginScreen());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Already have an account",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myCustomWidget() {
    return TextFormField(
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      controller: userPasswordController,
      focusNode: userPasswordFocusNode,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              size: 35,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
          return 'Password must contain both letters and numbers';
        }
        return null;
      },
    );
  }
}
