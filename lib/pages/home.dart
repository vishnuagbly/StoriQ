import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storiq/JSON/profile.dart';
import 'package:storiq/JSON/recent_file.dart';
import 'package:storiq/JSON/media_file.dart';
import 'package:storiq/network.dart';
import 'package:storiq/pages/add_file.dart';
import 'package:video_player/video_player.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stories",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500]),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 12),
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            mainUserProfile.profilePhoto ?? defaultPicLink),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          child: Icon(
                            Icons.add,
                            size: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  buildStoryAvatar(
                      "https://images.pexels.com/photos/2169434/pexels-photo-2169434.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                  buildStoryAvatar(
                      "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                  buildStoryAvatar(
                      "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                  buildStoryAvatar(
                      "https://images.pexels.com/photos/2092474/pexels-photo-2092474.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                  buildStoryAvatar(
                      "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                ],
              ),
            ),
            Container(
              height: 2,
              color: Colors.grey[300],
              margin: EdgeInsets.symmetric(horizontal: 30),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8),
                children: [
                  buildPostSection(
                      "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=640",
                      "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=940"),
                  buildPostSection(
                      "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=940",
                      "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                  buildPostSection(
                      "https://images.pexels.com/photos/1212600/pexels-photo-1212600.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=200&w=1260",
                      "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640"),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection(recentFilesCollectionName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot == null ||
                          !snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data.documents.length == 0)
                        return Container();
                      List<DocumentSnapshot> documents;
                      documents = snapshot.data.documents;
                      List<Container> filesWidgets = [];
                      for (DocumentSnapshot document in documents) {
                        Post file = Post.fromMap(document.data);
                        filesWidgets.add(buildPost(
                          file,
                          id: document.documentID,
                        ));
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filesWidgets,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFile(),
                ),
              );
            },
            child: Icon(
              Icons.add,
            ),
            backgroundColor: Colors.grey[900],
            elevation: 15,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
              )
            ],
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(Icons.home, 0),
            buildNavBarItem(Icons.person, 3, onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(mainUserProfile),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index, {Function onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        height: 45,
        child: icon != null
            ? Icon(
                icon,
                size: 25,
                color: index == _selectedItemIndex
                    ? Colors.black
                    : Colors.grey[700],
              )
            : Container(),
      ),
    );
  }

  Container buildPost(Post recentFile, {String id}) {
    return buildPostSection(
      recentFile.mediaFile.fileLink,
      null,
      name: recentFile.name,
      address: recentFile.address,
      uuid: recentFile.uuid,
      totalLikes: recentFile.totalLikes.toString(),
      liked: recentFile.likedByUser(mainUserProfile.uuid),
      id: id,
      fileType: recentFile.mediaFile.fileType,
    );
  }

  Container buildPostSection(
    String urlPost,
    String urlProfilePhoto, {
    String name,
    String address,
    String uuid,
    String totalLikes,
    bool liked,
    String id,
    FileType fileType,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPostFirstRow(
            urlProfilePhoto,
            name: name,
            address: address,
            uuid: uuid,
          ),
          SizedBox(
            height: 10,
          ),
          buildPostPicture(urlPost, liked ?? true, id, fileType ?? FileType.pic),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (totalLikes ?? "963") + " likes",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
//              Icon(
//                Icons.comment,
//                color: Colors.grey[800],
//              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Row buildPostFirstRow(String urlProfilePhoto,
      {String name, String address, String uuid}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                Profile profile;
                if (uuid == null)
                  profile = Profile.fromProfilePhotoURL(urlProfilePhoto);
                else
                  profile = await getProfile(uuid);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProfilePage(profile);
                    },
                  ),
                );
              },
              child: uuid != null
                  ? Hero(
                      tag: uuid,
                      child: FutureBuilder<Profile>(
                        future: getProfile(uuid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            Profile profile = snapshot.data;
                            return CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                  profile.profilePhoto ?? defaultPicLink),
                            );
                          }
                          return CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(defaultPicLink));
                        },
                      ),
                    )
                  : CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(defaultPicLink),
                    ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? "Tom Smith",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  address ?? "Iceland",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Stack buildPostPicture(
    String urlPost,
    bool liked,
    String id,
    FileType fileType,
  ) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width - 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: fileType == FileType.video ? Colors.black : Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
            image: fileType == FileType.pic
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(urlPost),
                  )
                : null,
          ),
          child: fileType == FileType.video ? ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: VideoPlayerController.network(urlPost),
                aspectRatio: 1,
                autoPlay: true,
                looping: true,
              ),
            ),
          ): Container(),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () async {
              if (!liked && id != null) {
                print("liking post");
                addLike(id);
              }
            },
            child: Icon(
              Icons.favorite,
              color: liked ? Colors.redAccent : Colors.grey,
              size: 40,
            ),
          ),
        )
      ],
    );
  }

  Container buildStoryAvatar(String url) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      height: 60,
      width: 60,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.red),
      child: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
