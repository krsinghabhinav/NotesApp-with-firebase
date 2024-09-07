import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newfireabse/Note%20app/Pages/LoginScreen.dart';
import 'package:newfireabse/Note%20app/Pages/editeNoteScreens.dart';
import 'package:newfireabse/Note%20app/Pages/notesScreen.dart';
import 'package:newfireabse/message/toastmessage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final Map<String, bool> _expandedStates = {};
  final int _maxContentLength = 20;

  Future<void> _refreshData() async {
    setState(() {});
  }

  void _toggleExpanded(String noteDocId) {
    setState(() {
      _expandedStates[noteDocId] = !(_expandedStates[noteDocId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Data List',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.off(() => LoginScreen());
              ToastUtil.showError("User Logged Out");
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        backgroundColor: const Color.fromARGB(255, 1, 163, 204),
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("notes")
              .where("userID", isEqualTo: user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No data found"));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final note = doc['note'] as String;
                final noteId = doc['userID'] as String;
                final createdDate = (doc['createDate'] as Timestamp).toDate();
                final formattedDate = '${createdDate.toLocal()}';
                final noteDocId = doc.id;

                _expandedStates.putIfAbsent(noteDocId, () => false);

                final isLongContent = note.length > _maxContentLength;
                final isExpanded = _expandedStates[noteDocId]!;

                return Card(
                  color: const Color.fromARGB(255, 238, 236, 236),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          isLongContent
                              ? (isExpanded
                                  ? note
                                  : '${note.substring(0, _maxContentLength)}...')
                              : note,
                        ),
                        subtitle: Text(formattedDate),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(() => EditNotesScreen(), arguments: {
                                  "note": note,
                                  "noteDocId": noteDocId,
                                });
                                ToastUtil.showSuccess(
                                    "Ready to Update the Data");
                              },
                              icon: Icon(Icons.edit, size: 28),
                            ),
                            // SizedBox(width: 5),
                            IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("notes")
                                    .doc(noteDocId)
                                    .delete();
                                ToastUtil.showError("Note Deleted");
                              },
                              icon: Icon(Icons.delete, size: 28),
                            ),
                          ],
                        ),
                        onTap: () => _toggleExpanded(noteDocId),
                      ),
                      if (isLongContent)
                        TextButton(
                          onPressed: () => _toggleExpanded(noteDocId),
                          child: Text(
                            isExpanded ? 'Read Less' : 'Read More',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NoteScreen());
        },
        child: Icon(Icons.add, size: 40, color: Colors.white),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
