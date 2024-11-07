import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserUid;
  final String selectedUserUid;

  const ChatScreen({
    super.key,
    required this.currentUserUid,
    required this.selectedUserUid,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late final Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();

    final chatDocId = _getChatDocumentId(widget.currentUserUid, widget.selectedUserUid);
    _messagesStream = firebaseFirestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  String _getChatDocumentId(String uid1, String uid2) {
    final sortedUids = [uid1, uid2]..sort();
    return sortedUids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: StreamBuilder(
                  stream: _messagesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          primary: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final qds = snapshot.data!.docs[index];
                            final Timestamp time = qds['timestamp'];
                            final DateTime dateTime = time.toDate();
                            final isCurrentUserMessage = auth.currentUser!.email == qds['sender'];
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: Column(
                                crossAxisAlignment: isCurrentUserMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.purple),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomLeft: Radius.circular(isCurrentUserMessage ? 20 : 0),
                                          bottomRight: Radius.circular(!isCurrentUserMessage ? 20 : 0),
                                        ),
                                      ),
                                      title: Text(
                                        qds['sender'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              qds['message'],
                                              style: const TextStyle(
                                                  fontSize: 15, color: Colors.black),
                                            ),
                                          ),
                                          Text(
                                            '${dateTime.hour}:${dateTime.minute >= 10 ? dateTime.minute : '0${dateTime.minute}'}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                    return Container();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        enabled: true,
                        contentPadding: const EdgeInsets.only(left: 15, bottom: 8, top: 8),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onSaved: (value) {
                        messageController.text = value!;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          final chatDocId = _getChatDocumentId(widget.currentUserUid, widget.selectedUserUid);
                          
                          firebaseFirestore.collection('chats').doc(chatDocId).collection('messages').add({
                            'message': messageController.text.trim(),
                            'timestamp': DateTime.now(),
                            'sender': auth.currentUser!.email,
                          });
                          messageController.clear();
                        }
                      },
                      icon: const Icon(
                        Icons.send_sharp,
                        size: 30,
                        color: Colors.blue,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
