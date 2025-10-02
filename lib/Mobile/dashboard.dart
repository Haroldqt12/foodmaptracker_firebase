import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodtracker_firebase/Properties/dashboardAssets/ImageSlider.dart';
import 'package:foodtracker_firebase/Properties/dashboardAssets/foodDescription.dart';

class NavDashboardPage extends StatefulWidget {
  const NavDashboardPage({super.key});

  @override
  State<NavDashboardPage> createState() => _NavDashboardPageState();
}

class _NavDashboardPageState extends State<NavDashboardPage> {
  String? username = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          username = userDoc["username"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213448), // keep dark background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: const Color(0xff213448),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    username ?? "Guest",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Welcome back 👋",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('images/foodtracker.jpg'),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          const ImageSlider(),
          const SizedBox(height: 20),
          const Text(
            'Recommended Meals',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xff2f4a5d),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'images/food1.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(
                'Grilled Chicken Salad',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Fresh greens with protein',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Fooddescription()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
