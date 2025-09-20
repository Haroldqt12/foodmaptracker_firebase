// dashboard.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodtracker_firebase/Dashboard_Widget/ImageSlider.dart';
import 'package:foodtracker_firebase/LOGINFORM/login.dart';
import 'package:foodtracker_firebase/Mobile/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  final String? userEmail;

  const Dashboard({super.key, this.userEmail});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  // ✅ Favorites list
  final List<String> favoriteRestaurants = [];

  // ✅ Sample restaurants
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "Pizza Planet",
      "category": "Pizza",
      "rating": 4.7,
      "recommendations": 12,
      "location": "101 Space Blvd",
      "reviews": [],
    },
    {
      "name": "Burger Hub",
      "category": "Burgers",
      "rating": 4.3,
      "recommendations": 9,
      "location": "45 Burger St",
      "reviews": [],
    },
    {
      "name": "Green Garden",
      "category": "Healthy",
      "rating": 4.2,
      "recommendations": 8,
      "location": "789 Healthy St",
      "reviews": [],
    },
    {
      "name": "Sushi House",
      "category": "Sushi",
      "rating": 4.6,
      "recommendations": 10,
      "location": "22 Tokyo Lane",
      "reviews": [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final List<Widget> _pages = [
      _homePage(),

      // ✅ Replaced TrendingPage() with placeholder
      Center(
        child: Text(
          "Trending Page (Coming Soon)",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),

      Center(
        child: Text("Location Page", style: TextStyle(color: Colors.white)),
      ),
      Center(
        child: Text(
          "Notifications Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      const ProfilePage(),
      _favoritesPage(),
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
              // Left side
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

              // Right side Avatar
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
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text("Profile"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: "Logout",
                    child: Row(
                      children: [
                        Icon(Icons.logout),
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
            onTabChange: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            color: Colors.white,
            tabBackgroundColor: const Color(0xff94b4c1),
            activeColor: Colors.white,
            gap: 30,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.trending_up, text: 'Trending'),
              GButton(icon: Icons.location_on, text: 'Location'),
              GButton(icon: Icons.notifications, text: 'Notifications'),
              GButton(icon: Icons.person, text: 'Profile'),
              GButton(icon: Icons.favorite, text: 'Favorites'),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Home page (simplified, no search or category)
  Widget _homePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Imageslider(),
          const SizedBox(height: 20),

          // ✅ Restaurant cards (no search or category filters anymore)
          Expanded(
            child: ListView(
              children: restaurants.map((r) => _restaurantCard(r)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Restaurant Card with ❤️ + 💬
  Widget _restaurantCard(Map<String, dynamic> restaurant) {
    final isFavorite = favoriteRestaurants.contains(restaurant["name"]);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.restaurant, color: Colors.deepOrange),
        title: Text(restaurant["name"]),
        subtitle: Text(
          "${restaurant["category"]} • ⭐ ${restaurant["rating"]} (${restaurant["recommendations"]} recommended)",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  if (isFavorite) {
                    favoriteRestaurants.remove(restaurant["name"]);
                  } else {
                    favoriteRestaurants.add(restaurant["name"]);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.comment, color: Colors.green),
              onPressed: () => _showReviews(restaurant),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Show reviews
  void _showReviews(Map<String, dynamic> restaurant) {
    // same as your existing implementation
  }

  // ✅ Favorites page
  Widget _favoritesPage() {
    if (favoriteRestaurants.isEmpty) {
      return const Center(
        child: Text(
          "No favorites yet ❤️",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: restaurants
          .where((r) => favoriteRestaurants.contains(r["name"]))
          .map((r) => _restaurantCard(r))
          .toList(),
    );
  }
}
