import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newfireabse/message/toastmessage.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController noteController = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;
  bool isProcessing = false; // Add this to manage the button state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: noteController,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write Your Notes",
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isProcessing
                    ? null
                    : () async {
                        setState(() {
                          isProcessing = true; // Set processing to true
                        });

                        var note = noteController.text.trim();
                        if (note.isNotEmpty) {
                          try {
                            await FirebaseFirestore.instance
                                .collection("notes")
                                .doc()
                                .set({
                              "createDate": DateTime.now(),
                              "note": note,
                              "userID": userId?.uid,
                            });
                            ToastUtil.showSuccess("Data Stored Successfully");
                            Navigator.pop(context);
                          } catch (e) {
                            // Handle error (e.g., show a message to the user)
                            print("Error: $e");
                          } finally {
                            setState(() {
                              isProcessing = false; // Reset processing to false
                            });
                          }
                        } else {
                          print("Note is empty");
                          setState(() {
                            isProcessing =
                                false; // Reset processing to false if note is empty
                          });
                        }
                      },
                child: Text(
                  isProcessing ? "Adding..." : "Add Note",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(50, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
