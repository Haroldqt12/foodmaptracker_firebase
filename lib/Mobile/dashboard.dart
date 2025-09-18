import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodtracker_firebase/Dashboard_Widget/ImageSlider.dart';
import 'package:foodtracker_firebase/LOGINFORM/login.dart';
import 'package:foodtracker_firebase/Mobile/profile.dart';
import 'package:foodtracker_firebase/Mobile/trending.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  final String? userEmail;

  const Dashboard({super.key, this.userEmail});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // ✅ Pages for navigation
    final List<Widget> _pages = [
      const Imageslider(),
      const TrendingPage(),
      Center(
        child: Text(
          "Location Page",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      Center(
        child: Text(
          "Notifications Page",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff213448),
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Dashboard title and email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.userEmail ?? user?.email ?? "No email",
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),

              // Right side: Avatar with popup menu
              PopupMenuButton<String>(
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) async {
                  if (value == "Profile") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  } else if (value == "Logout") {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "Profile",
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.black54),
                        SizedBox(width: 10),
                        Text("Profile"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: "Logout",
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.black54),
                        SizedBox(width: 10),
                        Text("Logout"),
                      ],
                    ),
                  ),
                ],
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xffEEF3D2),
                  child: ClipOval(
                    child: Image.asset(
                      'images/foodtracker.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Page switching
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff213448), Color(0xff213448)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _pages[_selectedIndex],
      ),

      // ✅ Bottom Navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff213448), Color(0xff213448)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            color: Colors.white,
            tabBackgroundColor: const Color(0xff94b4c1),
            activeColor: Colors.white,
            gap: 30,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.trending_up, text: 'Trending'),
              GButton(
                icon: Icons.location_on,
                iconActiveColor: Colors.white,
                iconSize: 52,
                text: 'Location',
              ),
              GButton(icon: Icons.notifications, text: 'Notifications'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
