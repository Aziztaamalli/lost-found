//version 2 : hedhi li temchi
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'custom_bottom_navigation_bar.dart';
// import 'chat_page.dart'; // Import your ChatPage

// class PostedItemsPage extends StatefulWidget {
//   final VoidCallback toggleTheme;

//   const PostedItemsPage({super.key, required this.toggleTheme});

//   @override
//   _PostedItemsPageState createState() => _PostedItemsPageState();
// }

// class _PostedItemsPageState extends State<PostedItemsPage> {
//   String _searchQuery = '';

//   void _updateSearchQuery(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   Future<void> _refreshData() async {
//     await Future.delayed(Duration(seconds: 1));
//   }

//   void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(item['title'] ?? 'No title'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Description: ${item['description'] ?? 'No description'}'),
//               const SizedBox(height: 10),
//               Text(
//                   'Posted on: ${item['timestamp']?.toDate().toLocal().toString() ?? 'Unknown'}'),
//               Text('Location: ${item['location'] ?? 'Unknown'}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _navigateToChatPage(BuildContext context, String ownerId) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ChatPage(
//           ownerId: ownerId,
//           currentUserId: currentUserId,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     print('Current User ID: $currentUserId');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Posted Items'),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50.0),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: TextField(
//               onChanged: _updateSearchQuery,
//               decoration: InputDecoration(
//                 hintText: 'Search by title or description',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('lost_items')
//               .where(
//                 'ownerId',
//                 isEqualTo: currentUserId,
//               )
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }

//             if (!snapshot.hasData) {
//               return const Center(child: Text('Loading...'));
//             }

//             if (snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No posted items found.'));
//             }

//             print('Snapshot data: ${snapshot.data!.docs}');

//             final items = snapshot.data!.docs.where((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               final title = data['title']?.toLowerCase() ?? '';
//               final description = data['description']?.toLowerCase() ?? '';
//               final query = _searchQuery.toLowerCase();
//               return title.contains(query) || description.contains(query);
//             }).toList();

//             print('Number of items: ${items.length}');

//             return ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index].data() as Map<String, dynamic>?;
//                 print('Item data: $item');

//                 if (item == null) {
//                   return const SizedBox.shrink();
//                 }

//                 final title = item['title'] ?? 'No title';
//                 final description = item['description'] ?? 'No description';
//                 final ownerId =
//                     item['ownerId'] ?? ''; // Get the ownerId from item

//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           description,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () => _showItemDetails(context, item),
//                           child: const Text('More Details'),
//                         ),
//                         ElevatedButton(
//                           onPressed: () =>
//                               _navigateToChatPage(context, ownerId),
//                           child: const Text('View Messages'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: 3,
//         toggleTheme: widget.toggleTheme,
//       ),
//     );
//   }
// }
//version 3 :
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_bottom_navigation_bar.dart';
import 'chat_page.dart'; // Import your ChatPage

class PostedItemsPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const PostedItemsPage({super.key, required this.toggleTheme});

  @override
  _PostedItemsPageState createState() => _PostedItemsPageState();
}

class _PostedItemsPageState extends State<PostedItemsPage> {
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
  }

  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item['title'] ?? 'No title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${item['description'] ?? 'No description'}'),
              const SizedBox(height: 10),
              Text(
                  'Posted on: ${item['timestamp']?.toDate().toLocal().toString() ?? 'Unknown'}'),
              Text('Location: ${item['location'] ?? 'Unknown'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChatPage(BuildContext context, String ownerId) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          ownerId: ownerId,
          currentUserId: currentUserId,
        ),
      ),
    );
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('lost_items')
          .doc(itemId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully')),
      );
    } catch (e) {
      print('Error deleting item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete item')),
      );
    }
  }

  void _confirmDelete(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteItem(itemId); // Delete the item
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    print('Current User ID: $currentUserId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posted Items'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by title or description',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('lost_items')
              .where(
                'ownerId',
                isEqualTo: currentUserId,
              )
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Loading...'));
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No posted items found.'));
            }

            print('Snapshot data: ${snapshot.data!.docs}');

            final items = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title']?.toLowerCase() ?? '';
              final description = data['description']?.toLowerCase() ?? '';
              final query = _searchQuery.toLowerCase();
              return title.contains(query) || description.contains(query);
            }).toList();

            print('Number of items: ${items.length}');

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index].data() as Map<String, dynamic>?;
                print('Item data: $item');

                if (item == null) {
                  return const SizedBox.shrink();
                }

                final title = item['title'] ?? 'No title';
                final description = item['description'] ?? 'No description';
                final ownerId =
                    item['ownerId'] ?? ''; // Get the ownerId from item
                final itemId = items[index].id; // Get the document ID

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _showItemDetails(context, item),
                          child: const Text('More Details'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              _navigateToChatPage(context, ownerId),
                          child: const Text('View Messages'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _confirmDelete(context, itemId),
                          child: const Text('Delete Item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Set color to red for delete
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        toggleTheme: widget.toggleTheme,
      ),
    );
  }
}
