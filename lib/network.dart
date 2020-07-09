import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storiq/JSON/profile.dart';
import 'package:storiq/JSON/recent_file.dart';
import 'package:storiq/JSON/media_file.dart';

import 'JSON/recent_file.dart';
import 'JSON/media_file.dart';

final profileCollectionName = "profiles";
final recentFilesCollectionName = "recent_files";
final defaultPicLink =
    "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/64edb642419075.57cc3f77e4ec4.png";
final firestore = Firestore.instance;
String user;
Profile mainUserProfile;

Future<bool> userExists() async {
  DocumentSnapshot snapshot;
  snapshot = await firestore.document("$profileCollectionName/$user").get();
  if (snapshot == null || snapshot.data == null) return false;
  return true;
}

Future<void> getMainUserProfile() async {
  mainUserProfile = await getProfile(user);
}

Future<Profile> getProfile(String uuid) async {
  DocumentSnapshot snapshot;
  snapshot = await firestore.document("$profileCollectionName/$uuid").get();
  if (snapshot == null || snapshot.data == null) return null;
  return Profile.fromMap(snapshot.data);
}

Future<void> createProfile(String name, String address) async {
  mainUserProfile = Profile(user, name, address);
  await firestore
      .document("$profileCollectionName/$user")
      .setData(mainUserProfile.toMap());
}

Future<void> addLike(String id) async {
  DocumentSnapshot document =
      await firestore.document("$recentFilesCollectionName/$id").get();
  Post post = Post.fromMap(document.data);
  print("got post: ${post.toMap()}");
  if (!post.likedByUser(user)) {
    print("post is not already liked by user, so liking it now");
    post.likes.add(user);
    await firestore
        .document("$recentFilesCollectionName/$id")
        .updateData(post.toMap());
  }
}

Future<void> addFile(MediaFile mediaFile) async {
  mainUserProfile.files.add(mediaFile);
  uploadMainUserData();
  addToRecentFiles(Post(mainUserProfile, mediaFile));
}

Future<void> startFollowing(String uuid) async {
  mainUserProfile.following.add(uuid);
  uploadMainUserData();
  Profile tempProfile = await getProfile(uuid);
  tempProfile.followers.add(mainUserProfile.uuid);
  updateProfile(tempProfile);
}

Future<void> uploadMainUserData() async {
  await updateProfile(mainUserProfile);
}

Future<void> updateProfile(Profile profile) async {
  await firestore
      .document("$profileCollectionName/${profile.uuid}")
      .updateData(profile.toMap());
}

Future<void> addToRecentFiles(Post recentFile) async {
  await firestore.collection(recentFilesCollectionName).add(recentFile.toMap());
}
