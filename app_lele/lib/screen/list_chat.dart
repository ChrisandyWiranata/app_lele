import 'package:app_lele/screen/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListChatScreeen extends StatefulWidget {
  const ListChatScreeen({super.key});

  @override
  State<ListChatScreeen> createState() => _ListChatScreeenState();
}

class _ListChatScreeenState extends State<ListChatScreeen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .orderBy('email')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List User'),
      ),
      body: StreamBuilder(
          stream: _usersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Error data');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data!.docs[index];
                  if (user['uid'] == FirebaseAuth.instance.currentUser!.uid) {
                    return Container();
                  } else {
                    return InkWell(
                      onTap: () {
                        final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
                        final selectedUserUid = user['uid'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUserUid: currentUserUid,
                              selectedUserUid: selectedUserUid,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 60,
                            height: 60,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDaJjME1Me_wesO9Yn8Y1es043qKxDEu-6kw&s'),
                            ),
                          ),
                          title: Text(user['email']),
                        ),
                      ),
                    );
                  }
                },
              );
            }
            return const Text('failed to get data');
          }),
    );
  }
}