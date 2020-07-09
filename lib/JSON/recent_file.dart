import 'package:storiq/JSON/profile.dart';
import 'package:storiq/JSON/media_file.dart';

class Post {
  final String uuid;
  final String name;
  final String address;
  List<String> likes = [];
  List<String> comments = [];
  final MediaFile mediaFile;

  int get totalLikes => likes.length;

  Post(Profile profile, MediaFile mediaFile)
      : uuid = profile.uuid,
        name = profile.name,
        address = profile.address,
        mediaFile = mediaFile;

  Post.fromMap(Map<String, dynamic> map)
      : uuid = map["uuid"],
        name = map["name"],
        address = map["address"],
        mediaFile = MediaFile.fromMap(map["file"] ?? dummy.toMap()),
        likes = map["likes"] != null ? map["likes"].cast<String>() : [],
        comments =
            map["comments"] != null ? map["comments"].cast<String>() : [];

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "name": name,
        "address": address,
        "file": mediaFile.toMap(),
        "likes": likes,
        "comments": comments,
      };

  bool likedByUser(String uuid) {
    for (String liker in likes) if (liker == uuid) return true;
    return false;
  }
}
