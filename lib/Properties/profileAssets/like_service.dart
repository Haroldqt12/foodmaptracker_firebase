import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodtracker_firebase/Properties/trendingAssets/post_model.dart';

class LikeService {
  static Future<void> toggleLike(PostModel post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(post.id);

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(post.id);

    if (post.isLiked) {
      // Unlike
      await postRef.update({
        'hearts': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([user.uid]),
      });
      await favoritesRef.delete();
      post.isLiked = false;
      post.hearts -= 1;
    } else {
      // Like
      await postRef.update({
        'hearts': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([user.uid]),
      });
      await favoritesRef.set({
        'restaurant': post.restaurant,
        'description': post.review,
        'imageUrl': post.imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      post.isLiked = true;
      post.hearts += 1;
    }
  }
}
