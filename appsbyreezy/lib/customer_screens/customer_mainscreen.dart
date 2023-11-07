import 'package:appsbyreezy/customer_tab_pages/account_screen.dart';
import 'package:appsbyreezy/customer_tab_pages/activity_tab.dart';
import 'package:appsbyreezy/customer_tab_pages/customer_home.dart';
import 'package:appsbyreezy/customer_tab_pages/services_tab.dart';
import 'package:appsbyreezy/global/global.dart';
import 'package:appsbyreezy/tabPages/earning_tab.dart';
import 'package:appsbyreezy/tabPages/home_tab.dart';
import 'package:appsbyreezy/tabPages/profile_tab.dart';
import 'package:appsbyreezy/tabPages/ratings_tab.dart';
import 'package:flutter/material.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> with SingleTickerProviderStateMixin
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
          CustomerHomePage(),
          ServicesTabPage(),
          ActivityTabPage(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: "Services",
            ),

            BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Rate",
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
