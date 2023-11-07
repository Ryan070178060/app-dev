import 'package:appsbyreezy/datamodels/profile_model.dart';
import 'package:appsbyreezy/global/global.dart';
import 'package:appsbyreezy/tabPages/earning_tab.dart';
import 'package:appsbyreezy/tabPages/home_tab.dart';
import 'package:appsbyreezy/tabPages/profile_tab.dart';
import 'package:appsbyreezy/tabPages/ratings_tab.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
 {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index)
  {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const  NeverScrollableScrollPhysics(),
        controller: tabController,
        children:  [
          MapScreen(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileScreen(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Earnings",
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Ratings",
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            ),
        ],

        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 56, 133, 146),
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const  TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
