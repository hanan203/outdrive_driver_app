import 'package:flutter/material.dart';
import 'package:outdrive/src/constants/colors.dart';
import 'package:outdrive/src/constants/sizes.dart';
import 'package:outdrive/src/features/screens/tabScrren/earning_tab.dart';
import 'package:outdrive/src/features/screens/tabScrren/home_tab.dart';
import 'package:outdrive/src/features/screens/tabScrren/profile_tab.dart';
import 'package:outdrive/src/features/screens/tabScrren/rating_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
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
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Earning", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Rating", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],

        unselectedItemColor: Colors.white24,
        selectedItemColor: Colors.white,
        backgroundColor: bgColor,
        type: BottomNavigationBarType.shifting,
        selectedLabelStyle: font_color_white,
        unselectedLabelStyle: const TextStyle(
            color: Colors.white24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 10
        ),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
