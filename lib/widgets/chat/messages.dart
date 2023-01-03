import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_chat/widgets/chat/message_bubble.dart';

class Messages extends StatefulWidget {

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(includeMetadataChanges: true),
      builder: (ctx, AsyncSnapshot chatSnapshot){
        if(chatSnapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        final chatDocs = chatSnapshot.data!.docs;
        final useridentify = FirebaseAuth.instance.currentUser!.uid;
        // print("userid $useridentify");
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i){
            // print("cur id ${chatDocs[i].data()["userId"]}");
            return  MessageBubble(
              chatDocs[i].data()["text"],
              chatDocs[i].data()["userId"] == useridentify,
              chatDocs[i].data()["username"],
              chatDocs[i].data()["userImage"],
              key: ValueKey(chatDocs[i].id),
            );
          },
        );
      },
    );
  }
}
