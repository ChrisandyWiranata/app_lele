import 'dart:convert';

import 'package:app_lele/components/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String currentUserUid;
  final QueryDocumentSnapshot selectedUser;

  const ChatScreen({
    super.key,
    required this.currentUserUid,
    required this.selectedUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final Stream<QuerySnapshot> messagesStream;
  late final Map<String, dynamic> currentUser;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    initializeChat();
  }

  void loadCurrentUser() {
    firebaseFirestore
        .collection('users')
        .doc(widget.currentUserUid)
        .snapshots()
        .map((snapshot) => snapshot.data()!)
        .listen((userData) {
      setState(() {
        currentUser = userData;
      });
    });
  }

  void initializeChat() {
    final chatDocId =
        getChatDocumentId(widget.currentUserUid, widget.selectedUser['uid']);
    messagesStream = firebaseFirestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final chatDocId =
          getChatDocumentId(widget.currentUserUid, widget.selectedUser['uid']);
      firebaseFirestore
          .collection('chats')
          .doc(chatDocId)
          .collection('messages')
          .add({
        'message': messageController.text.trim(),
        'timestamp': DateTime.now(),
        'sender': auth.currentUser!.email,
      });

      final String tempMessage = messageController.text.trim();
      messageController.clear();
      scrollToLatestMessage();

      sendNotification(
        widget.selectedUser['fcmToken'],
        currentUser['username'],
        tempMessage,
      );
    }
  }

  void scrollToLatestMessage() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendNotification(String token, String title, String body) async {
    final url =
        Uri.parse('https://mature-auspicious-ice.glitch.me/send-notification');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('Error sending notification: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.curelean),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.selectedUser['username'],
          style: const TextStyle(
            color: AppColors.curelean,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      final isCurrentUser =
                          auth.currentUser!.email == message['sender'];
                      return buildMessageBubble(message, isCurrentUser);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageBubble(DocumentSnapshot message, bool isCurrentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isCurrentUser
                ? const SizedBox.shrink()
                : widget.selectedUser['imageProfile'] != null &&
                        widget.selectedUser['imageProfile'] != ''
                    ? ClipOval(
                        child: Image.network(
                          widget.selectedUser['imageProfile'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.bluetopaz.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 25,
                          color: AppColors.bluetopaz,
                        ),
                      ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? AppColors.bluetopaz.withOpacity(0.1)
                    : AppColors.icicle,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                  bottomLeft: !isCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['message'],
                    style: const TextStyle(
                      color: AppColors.curelean,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTime(message['timestamp']),
                    style: TextStyle(
                      color: AppColors.bluetopaz.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.icicle,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.icicle,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: messageController,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: AppColors.bluetopaz.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bluetopaz.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: AppColors.curelean,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getChatDocumentId(String uid1, String uid2) {
    final sortedUids = [uid1, uid2]..sort();
    return sortedUids.join('_');
  }

  String formatTime(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
