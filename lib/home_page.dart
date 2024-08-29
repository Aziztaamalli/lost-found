// hedha li louta howa pour le moment s7i7
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'custom_bottom_navigation_bar.dart'; // Import the custom bottom navigation bar
import 'profile_page.dart';
import 'lost_item_form_page.dart';
import 'chat_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _configureFirebaseMessaging();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.messageId}');
      // Handle foreground message here, show notification UI if needed
    });
  }

  Future<void> _refreshData() async {
    // This function is triggered by the RefreshIndicator
    // You can use it to trigger any additional refresh logic if needed
    // For example, you might want to manually refresh the Firestore data,
    // but in this case, StreamBuilder automatically listens for updates.
    await Future.delayed(
        Duration(seconds: 1)); // Simulate a network call or other refresh logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
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
              return const Center(child: Text('No lost items found.'));
            }

            final items = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title']?.toLowerCase() ?? '';
              final description = data['description']?.toLowerCase() ?? '';
              final query = _searchQuery.toLowerCase();
              return title.contains(query) || description.contains(query);
            }).toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index].data()
                    as Map<String, dynamic>?; // Safely cast to Map
                final title = item?['title'] ?? 'No title';
                final description = item?['description'] ?? 'No description';
                final ownerId = item?.containsKey('ownerId') == true
                    ? item!['ownerId']
                    : null;

                final currentUserId =
                    FirebaseAuth.instance.currentUser?.uid ?? '';

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
                          onPressed: ownerId != null
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        ownerId: ownerId,
                                        currentUserId: currentUserId,
                                      ),
                                    ),
                                  );
                                }
                              : null, // Disable button if ownerId is null
                          child: const Text('Chat with the owner'),
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
        currentIndex: 1,
        toggleTheme: widget.toggleTheme,
      ),
    );
  }
}
