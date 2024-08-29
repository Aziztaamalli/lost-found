// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   final String ownerId;

//   const ChatPage({super.key, required this.ownerId});

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final _messageController = TextEditingController();

//   Future<void> _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       try {
//         await FirebaseFirestore.instance.collection('chats').add({
//           'message': _messageController.text.trim(),
//           'ownerId': widget.ownerId,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         // Send a notification to the owner
//         await FirebaseFirestore.instance.collection('notifications').add({
//           'title': 'New message from a user',
//           'body': _messageController.text.trim(),
//           'ownerId': widget.ownerId,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         _messageController.clear();
//         FocusScope.of(context).unfocus();
//       } catch (e) {
//         print('Error sending message: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat with Owner'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .where('ownerId', isEqualTo: widget.ownerId)
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No messages yet.'));
//                 }

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index]['message'] ?? 'No message';
//                     final timestamp =
//                         messages[index]['timestamp'] as Timestamp?;
//                     final formattedTimestamp = timestamp != null
//                         ? timestamp.toDate().toString()
//                         : 'No timestamp';

//                     return ListTile(
//                       title: Text(message),
//                       subtitle: Text(formattedTimestamp),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   final String ownerId;

//   const ChatPage({super.key, required this.ownerId});

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final _messageController = TextEditingController();

//   Future<void> _sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       try {
//         String message = _messageController.text.trim();

//         await FirebaseFirestore.instance.collection('chats').add({
//           'message': message,
//           'ownerId': widget.ownerId,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         await _sendNotification(message);

//         _messageController.clear();
//         FocusScope.of(context).unfocus();
//       } catch (e) {
//         print('Error sending message: $e');
//       }
//     }
//   }

//   Future<void> _sendNotification(String message) async {
//     final fcmToken = await _getOwnerFcmToken(widget.ownerId);
//     if (fcmToken != null) {
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'token': fcmToken,
//         'title': 'New message',
//         'body': message,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     }
//   }

//   Future<String?> _getOwnerFcmToken(String ownerId) async {
//     final doc =
//         await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
//     return doc['fcmToken'] as String?;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat with Owner'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .where('ownerId', isEqualTo: widget.ownerId)
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No messages yet.'));
//                 }

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index]['message'] ?? 'No message';
//                     final timestamp =
//                         messages[index]['timestamp'] as Timestamp?;
//                     final formattedTimestamp = timestamp != null
//                         ? timestamp.toDate().toString()
//                         : 'No timestamp';

//                     return ListTile(
//                       title: Text(message),
//                       subtitle: Text(formattedTimestamp),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String ownerId;
  final String currentUserId;

  const ChatPage({
    super.key,
    required this.ownerId,
    required this.currentUserId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        String message = _messageController.text.trim();

        // Add message to Firestore
        await FirebaseFirestore.instance.collection('chats').add({
          'message': message,
          'ownerId': widget.ownerId,
          'senderId': widget.currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Message sent: $message');

        // Optionally send a notification
        await _sendNotification(message);

        // Clear message input
        _messageController.clear();
        FocusScope.of(context).unfocus();
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  Future<void> _sendNotification(String message) async {
    final fcmToken = await _getOwnerFcmToken(widget.ownerId);
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'token': fcmToken,
        'title': 'New message',
        'body': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String?> _getOwnerFcmToken(String ownerId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
    return doc.data()?['fcmToken'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Owner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('ownerId', isEqualTo: widget.ownerId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>?;
                    final message = messageData?['message'] ?? 'No message';
                    final senderId = messageData?['senderId'] ?? '';
                    final timestamp = messageData?['timestamp'] as Timestamp?;
                    final formattedTimestamp = timestamp != null
                        ? timestamp.toDate().toString()
                        : 'No timestamp';

                    return Align(
                      alignment: senderId == widget.currentUserId
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: senderId == widget.currentUserId
                                ? Colors.blue[200]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: senderId == widget.currentUserId
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  color: senderId == widget.currentUserId
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                formattedTimestamp,
                                style: TextStyle(
                                  color: senderId == widget.currentUserId
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
