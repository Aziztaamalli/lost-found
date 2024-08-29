import 'package:flutter/material.dart';
import 'package:my_first_app/posted_items.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'lost_item_form_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback toggleTheme;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue, // Color for the selected icon
      unselectedItemColor: Colors.grey, // Color for unselected icons
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Posted Items',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(toggleTheme: toggleTheme)),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(toggleTheme: toggleTheme)),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LostItemFormPage()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PostedItemsPage(toggleTheme: toggleTheme)),
            );
            break;
        }
      },
    );
  }
}
