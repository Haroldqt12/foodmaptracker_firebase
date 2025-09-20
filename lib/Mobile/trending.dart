import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Reviews',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // FIXED: Proper MaterialPageRoute navigation
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrendingPage()),
            );
          },
          child: const Text("Go to Trending"),
        ),
      ),
    );
  }
}

// ---------------- TRENDING PAGE ----------------
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
      "reviews": [],
    },
    {
      "name": "Street Grill",
      "rating": 3.8,
      "description": "Best BBQ and street food in town.",
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
      "recommendations": 9,
      "location": "456 BBQ Avenue",
      "reviews": [],
    },
  ];

  String searchQuery = "";

  void _showReviews(int index) {
    final restaurant = restaurants[index];
    final TextEditingController commentController = TextEditingController();
    List<XFile> mediaFiles = [];
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Restaurant name
                    Text(
                      restaurant["name"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Existing reviews
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView.builder(
                        itemCount: restaurant["reviews"].length,
                        itemBuilder: (context, rIndex) {
                          final review = restaurant["reviews"][rIndex];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(review["user"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review["comment"]),
                                if (review["media"] != null)
                                  Wrap(
                                    spacing: 8,
                                    children: (review["media"] as List<XFile>)
                                        .map(
                                          (file) => file.path.endsWith('.mp4')
                                              ? const Icon(Icons.videocam)
                                              : Image.file(
                                                  File(file.path),
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                        )
                                        .toList(),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(),

                    // --- REVIEW INPUT BOX (Facebook-like) ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: "Write a review...",
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              setState(() {
                                restaurant["reviews"].add({
                                  "user": "currentUser@mail.com",
                                  "comment": commentController.text,
                                  "media": mediaFiles,
                                });
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Post"),
                        ),
                      ],
                    ),

                    const Divider(),

                    // Options (Video & Photos)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final XFile? video = await picker.pickVideo(
                              source: ImageSource.gallery,
                            );
                            if (video != null) {
                              setModalState(() => mediaFiles.add(video));
                            }
                          },
                          icon: const Icon(Icons.videocam, color: Colors.red),
                          label: const Text("Video"),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setModalState(() => mediaFiles.add(image));
                            }
                          },
                          icon: const Icon(Icons.photo, color: Colors.green),
                          label: const Text("Photos"),
                        ),
                      ],
                    ),

                    // Media Preview
                    if (mediaFiles.isNotEmpty)
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mediaFiles.length,
                          itemBuilder: (context, i) {
                            final file = mediaFiles[i];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: file.path.endsWith('.mp4')
                                  ? const Icon(Icons.videocam)
                                  : Image.file(
                                      File(file.path),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = restaurants
        .where((r) => r["name"].toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xff213448),
      appBar: AppBar(
        backgroundColor: const Color(0xff213448),
        title: const Text("Trending Restaurants"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
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
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = filteredRestaurants[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    index: index,
                    showReviews: _showReviews,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- RESTAURANT CARD ----------------
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
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            restaurant["image"],
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(restaurant["name"]),
        subtitle: Text(restaurant["description"]),
        trailing: IconButton(
          icon: const Icon(Icons.comment, color: Colors.green),
          onPressed: () => showReviews(index),
        ),
      ),
    );
  }
}
