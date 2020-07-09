import 'media_file.dart';

class Profile {
  final String uuid;
  final String name;
  final String address;
  String profilePhoto;
  List<String> followers = [];
  List<String> following = [];
  List<MediaFile> files = [];

  int get totalFollowers => followers.length;

  int get totalFollowing => following.length;

  int get totalFiles => files.length;

  Profile(this.uuid, this.name, this.address);

  Profile.fromMap(Map<String, dynamic> map)
      : uuid = map["uuid"],
        name = map["name"],
        address = map["address"],
        profilePhoto = map["profilePhoto"],
        followers =
            map["followers"] != null ? map["followers"].cast<String>() : [],
        following =
            map["following"] != null ? map["following"].cast<String>() : [],
        files = MediaFile.allFromMaps(map["files"]);

  static Profile fromProfilePhotoURL(String url) => Profile.fromMap({
        "profilePhoto": url,
      });

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "name": name,
        "address": address,
        "profilePhoto": profilePhoto,
        "followers": followers,
        "following": following,
        "files": MediaFile.allToMaps(files),
      };

  bool follows(String uuid) {
    return following.contains(uuid);
  }
}
