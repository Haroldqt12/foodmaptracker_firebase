class PostModel {
  final String id; // Firestore doc ID
  final String username;
  final String location;
  final String profileImage;
  final String restaurant;
  final double rating;
  final String review;
  final String imageUrl;
  int hearts; // mutable for increment/decrement
  final String timeAgo;

  bool isLiked; // 👈 track if current user liked it

  PostModel({
    required this.id,
    required this.username,
    required this.location,
    required this.profileImage,
    required this.restaurant,
    required this.rating,
    required this.review,
    required this.imageUrl,
    required this.hearts,
    required this.timeAgo,
    this.isLiked = false,
  });

  factory PostModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
    String currentUserId,
  ) {
    return PostModel(
      id: id,
      username: data['username'] ?? '',
      location: data['location'] ?? '',
      profileImage: data['profileImage'] ?? '',
      restaurant: data['restaurant'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      review: data['review'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      hearts: data['hearts'] ?? 0,
      timeAgo: data['timeAgo'] ?? '',
      isLiked: (data['likedBy'] ?? []).contains(currentUserId),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'location': location,
      'profileImage': profileImage,
      'restaurant': restaurant,
      'rating': rating,
      'review': review,
      'imageUrl': imageUrl,
      'hearts': hearts,
      'timeAgo': timeAgo,
    };
  }
}
