import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safiri/settings/settings_page.dart';
import 'package:safiri/trip-history/trip_history_list_view.dart';

import '../announcements/announcements_view.dart';
import 'homepage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages = [
    MyHomePage(),
    const AnnouncementsView(),
    const TripHistoryListView(),
    const SettingsPage(),
  ];
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedPage,
          onTap: (value) {
            setState(() {
              selectedPage = value;
              print(selectedPage);
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Ionicons.chatbox), label: "Inbox"),
            BottomNavigationBarItem(
                icon: Icon(Icons.watch_later_outlined), label: "Rides"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Home"),
          ],
        ),
      ),
    );
  }
}
