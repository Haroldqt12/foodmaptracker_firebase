import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ Import your Dashboard page

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "Tasty Bites",
      "rating": 4.5,
      "description": "Delicious sandwiches and snacks for everyone.",
      "image": "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
      "recommendations": 15,
      "location": "123 Main Street",
      "reviews": [
        {"user": "alice@mail.com", "comment": "Amazing food!"},
        {"user": "bob@mail.com", "comment": "Loved the sandwich."},
        {"user": "mike@mail.com", "comment": "Affordable and tasty."},
        {"user": "karen@mail.com", "comment": "Quick service."},
      ],
    },
    {
      "name": "Street Grill",
      "rating": 3.8,
      "description": "Best BBQ and street food in town.",
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      "recommendations": 9,
      "location": "456 BBQ Avenue",
      "reviews": [
        {"user": "mark@mail.com", "comment": "Great BBQ!"},
        {"user": "jane@mail.com", "comment": "Affordable meals."},
        {"user": "sam@mail.com", "comment": "Loved the sauce!"},
        {"user": "rita@mail.com", "comment": "Nice grilled chicken."},
      ],
    },
    {
      "name": "Green Garden",
      "rating": 4.2,
      "description": "Fresh salads, smoothies, and healthy bites.",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsTgLlP6o4hiAffmApg128CNl4gWQBfl2gVA&s",
      "recommendations": 12,
      "location": "789 Healthy St",
      "reviews": [
        {"user": "lisa@mail.com", "comment": "Very fresh and tasty!"},
        {"user": "tom@mail.com", "comment": "Loved the smoothie."},
        {"user": "nina@mail.com", "comment": "Super healthy menu."},
        {"user": "leo@mail.com", "comment": "Nice vegan options."},
      ],
    },
    {
      "name": "Pizza Planet",
      "rating": 4.7,
      "description": "Out-of-this-world pizza and sides.",
      "image":
          "https://img1.wsimg.com/isteam/ip/538bcd6d-a924-461e-a467-d49ed06293ca/SRO_1507-7e12095.jpg",
      "recommendations": 20,
      "location": "101 Space Blvd",
      "reviews": [
        {"user": "dan@mail.com", "comment": "Best pizza ever!"},
        {"user": "emma@mail.com", "comment": "Cheesy heaven."},
        {"user": "ryan@mail.com", "comment": "Crispy crust is amazing."},
        {"user": "mia@mail.com", "comment": "Huge pizza slices!"},
      ],
    },
    {
      "name": "Sushi World",
      "rating": 4.6,
      "description": "Authentic Japanese sushi and sashimi.",
      "image": "https://images.unsplash.com/photo-1553621042-f6e147245754",
      "recommendations": 18,
      "location": "22 Tokyo Lane",
      "reviews": [
        {"user": "ken@mail.com", "comment": "Fresh and authentic!"},
        {"user": "yumi@mail.com", "comment": "Best sushi ever!"},
        {"user": "alex@mail.com", "comment": "Great ambiance too."},
      ],
    },
    {
      "name": "Burger Hub",
      "rating": 4.1,
      "description": "Juicy burgers with crispy fries.",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF4rr7DH7ELu_0QL4dX5_N9-y4g2rPyuQ-Iw&s",
      "recommendations": 11,
      "location": "45 Burger St",
      "reviews": [
        {"user": "jack@mail.com", "comment": "Big portions!"},
        {"user": "sara@mail.com", "comment": "Loved the fries."},
        {"user": "pete@mail.com", "comment": "Affordable burgers."},
      ],
    },
    {
      "name": "Coffee Corner",
      "rating": 4.3,
      "description": "Cozy café with specialty coffee and pastries.",
      "image": "https://images.unsplash.com/photo-1498804103079-a6351b050096",
      "recommendations": 14,
      "location": "77 Brew Street",
      "reviews": [
        {"user": "anna@mail.com", "comment": "Best cappuccino ever."},
        {"user": "liam@mail.com", "comment": "Nice place to chill."},
        {"user": "noah@mail.com", "comment": "Friendly staff."},
      ],
    },
  ];

  void _showReviews(int index) {
    final restaurant = restaurants[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              // Title + locator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    restaurant["name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 28,
                    ),
                    tooltip: "Locate Restaurant",
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Location: ${restaurant['location']}"),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Customer Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // ✅ Only show customer reviews
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurant["reviews"].length,
                    itemBuilder: (context, rIndex) {
                      final review = restaurant["reviews"][rIndex];
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.grey),
                        title: Text(review["user"]),
                        subtitle: Text(review["comment"]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff213448),
        appBar: AppBar(
          backgroundColor: const Color(0xff213448),
          title: const Text(
            "Trending Restaurants",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                index: index,
                showReviews: _showReviews,
              );
            },
          ),
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final int index;
  final Function(int) showReviews;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.index,
    required this.showReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                restaurant["image"],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant["description"],
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        restaurant["rating"].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${restaurant["recommendations"]} recommended",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff213448),
              ),
              onPressed: () => showReviews(index),
            ),
          ],
        ),
      ),
    );
  }
}
