import 'package:flutter/material.dart';

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
      "reviews": [
        {"user": "alice@mail.com", "comment": "Amazing food!"},
        {"user": "bob@mail.com", "comment": "Loved the sandwich."},
      ],
    },
    {
      "name": "Street Grill",
      "rating": 3.8,
      "description": "Best BBQ and street food in town.",
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      "reviews": [
        {"user": "mark@mail.com", "comment": "Great BBQ!"},
        {"user": "jane@mail.com", "comment": "Affordable meals."},
      ],
    },
    {
      "name": "Green Garden",
      "rating": 4.2,
      "description": "Fresh salads, smoothies, and healthy bites.",
      "image": "https://images.unsplash.com/photo-1566843971477-216abb93b61a",
      "reviews": [
        {"user": "lisa@mail.com", "comment": "Very fresh and tasty!"},
        {"user": "tom@mail.com", "comment": "Loved the smoothie."},
      ],
    },
    {
      "name": "Pizza Planet",
      "rating": 4.7,
      "description": "Out-of-this-world pizza and sides.",
      "image": "https://images.unsplash.com/photo-1601924582975-9e84b8f08991",
      "reviews": [
        {"user": "dan@mail.com", "comment": "Best pizza ever!"},
        {"user": "emma@mail.com", "comment": "Cheesy heaven."},
      ],
    },
  ];

  void _showReviews(int index) {
    final restaurant = restaurants[index];
    final TextEditingController reviewController = TextEditingController();

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
          child: SingleChildScrollView(
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
                const Text(
                  "Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
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
                const Divider(),
                TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(
                    hintText: "Write your review...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("Post Review"),
                  onPressed: () {
                    if (reviewController.text.isNotEmpty) {
                      setState(() {
                        restaurants[index]["reviews"].add({
                          "user": "guest@mail.com",
                          "comment": reviewController.text,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: restaurants.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85, // Adjusted for smaller image
          ),
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main restaurant image (not too large)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        restaurant["image"],
                        height: 80, // Reduced height
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Restaurant name
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
                    // Restaurant description
                    Text(
                      restaurant["description"],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Rating
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
                      ],
                    ),
                    const Spacer(),
                    // Icon buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xff213448),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _showReviews(index),
                          icon: const Icon(Icons.info),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Location of ${restaurant['name']}",
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.location_on),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
