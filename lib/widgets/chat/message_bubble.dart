import "package:flutter/material.dart";

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String _userName;
  final String userImage;
  final Key key;

  MessageBubble(this.message, this.isMe, this._userName, this.userImage,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: isMe ? const Radius.circular(10) : Radius.circular(0),
                  bottomRight: !isMe ? const Radius.circular(10) : const Radius.circular(0),
                ),
                color: isMe ? Colors.orange[400] : Colors.indigo[400],
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
