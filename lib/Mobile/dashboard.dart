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

  // ✅ Favorites list
  final List<String> favoriteRestaurants = [];

  // ✅ Search + category
  String searchQuery = "";
  String selectedCategory = "All";

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
      const TrendingPage(),
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

  // ✅ Home page
  Widget _homePage() {
    List<String> categories = ["All", "Pizza", "Burgers", "Healthy", "Sushi"];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Imageslider(),
          const SizedBox(height: 12),

          // 🔎 Search bar
          TextField(
            onChanged: (value) =>
                setState(() => searchQuery = value.toLowerCase()),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              hintText: "Search restaurants...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 🍔 Category filter
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) =>
                      setState(() => selectedCategory = category),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // ✅ Restaurant cards
          Expanded(
            child: ListView(
              children: restaurants
                  .where(
                    (r) =>
                        (selectedCategory == "All" ||
                            r["category"] == selectedCategory) &&
                        (searchQuery.isEmpty ||
                            r["name"].toLowerCase().contains(searchQuery)),
                  )
                  .map((r) => _restaurantCard(r))
                  .toList(),
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

  // ✅ Show reviews with ability to add multiple comments
  void _showReviews(Map<String, dynamic> restaurant) {
    double selectedStars = 0.0;
    final commentController = TextEditingController();

    final userEmail =
        FirebaseAuth.instance.currentUser?.email ?? "guest@mail.com";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    restaurant["name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 📌 Show all reviews stacked
                  if (restaurant["reviews"].isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: restaurant["reviews"].length,
                        itemBuilder: (context, index) {
                          final review = restaurant["reviews"][index];
                          return ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            title: Text(review["user"]),
                            subtitle: Text(review["comment"]),
                          );
                        },
                      ),
                    )
                  else
                    const Text(
                      "No reviews yet. Be the first to comment!",
                      style: TextStyle(color: Colors.grey),
                    ),

                  const Divider(),
                  const Text("Your Rating"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < selectedStars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () =>
                            setModalState(() => selectedStars = i + 1.0),
                      );
                    }),
                  ),

                  // 💬 Comment text field
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Write your comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("Submit Review"),
                    onPressed: () {
                      if (selectedStars > 0 &&
                          commentController.text.isNotEmpty) {
                        setState(() {
                          // Always add new review instead of replacing
                          restaurant["reviews"].add({
                            "user": userEmail,
                            "comment": commentController.text,
                            "stars": selectedStars,
                          });

                          // update rating (simple avg)
                          double avgStars =
                              restaurant["reviews"]
                                  .map((r) => r["stars"] as double)
                                  .reduce((a, b) => a + b) /
                              restaurant["reviews"].length;

                          restaurant["rating"] = double.parse(
                            avgStars.toStringAsFixed(1),
                          );

                          if (selectedStars >= 4) {
                            restaurant["recommendations"]++;
                          }
                        });

                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
