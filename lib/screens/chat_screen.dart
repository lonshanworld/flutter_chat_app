import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_chat/widgets/chat/messages.dart';
import 'package:flutter_chat/widgets/chat/new_messages.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chat"),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: "logout",
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Messages()),
          NewMessages(),
        ],
      ),
    );
  }
}
