import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../categories/category_screen.dart';
import '../watchlist/watchlist_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/global_chat_screen.dart';
import '../watchparty/party_video_selector.dart'; // Watch Party entry point

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    // Generate a unique user ID (can be replaced with real auth ID)
    _userId = DateTime.now().millisecondsSinceEpoch.toString();

    _pages = [
      HomeScreen(),
      CategoryScreen(),
      WatchlistScreen(userId: _userId), // Pass userId
      ProfileScreen(),
      GlobalChatScreen(),
      PartyVideoSelector(userId: _userId), // Pass userId
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: const Color(0xFFE50914),
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Watchlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: "Watch Party"),
        ],
      ),
    );
  }
}
