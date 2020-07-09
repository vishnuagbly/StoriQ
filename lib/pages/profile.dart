import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:storiq/JSON/media_file.dart';
import 'package:storiq/JSON/profile.dart';
import 'package:storiq/network.dart';
import 'package:storiq/pages/add_file.dart';
import 'package:video_player/video_player.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;

  ProfilePage(this.profile);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Card> media = [
      buildMediaCard(
          "https://images.pexels.com/photos/994605/pexels-photo-994605.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=1260"),
      buildMediaCard(
          "https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=1260"),
      buildMediaCard(
          "https://images.pexels.com/photos/733475/pexels-photo-733475.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=1260"),
      buildMediaCard(
          "https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=1260"),
      buildMediaCard(
          "https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=1260"),
      buildMediaCard(
          "https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=1260"),
    ];
    for (MediaFile file in widget.profile.files) {
      String mediaLink = file.fileLink;
      media.add(buildMediaCard(mediaLink, fileType: file.fileType));
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 35),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios)),
                InkWell(
                  onTap: () {
                    setState(() {});
                  },
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Hero(
            tag: widget.profile.profilePhoto ?? defaultPicLink,
            child: GestureDetector(
              onTap: () {
                if (widget.profile.uuid == mainUserProfile.uuid)
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddFile(addProfileImage: true)));
              },
              child: Container(
                margin: EdgeInsets.only(top: 35),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 20,
                    )
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        widget.profile.profilePhoto ?? defaultPicLink),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.profile.name ?? "Tom Smith",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.profile.address ?? "London, England",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          widget.profile.uuid != null &&
                  widget.profile.uuid != mainUserProfile.uuid
              ? RaisedButton(
                  child: Text(mainUserProfile.follows(widget.profile.uuid)
                      ? "Following"
                      : "Follow"),
                  onPressed: mainUserProfile.follows(widget.profile.uuid)
                      ? null
                      : () {
                          startFollowing(widget.profile.uuid);
                          setState(() {
                            widget.profile.followers.add(mainUserProfile.uuid);
                          });
                        },
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildStatColumn("${widget.profile.totalFiles}", "Photos"),
              buildStatColumn("${widget.profile.totalFollowers}", "Followers"),
              buildStatColumn("${widget.profile.totalFollowing}", "Following"),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
              child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 5),
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 5 / 6,
                children: media,
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
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
            buildNavBarItem(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
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

  Card buildMediaCard(String url, {FileType fileType = FileType.pic}) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: fileType == FileType.pic
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(url),
                )
              : null,
        ),
        child: fileType == FileType.video ? Chewie(
          controller: ChewieController(
            videoPlayerController: VideoPlayerController.network(url),
            aspectRatio: 1,
            autoPlay: true,
            looping: true,
          ),
        ): Container(),
      ),
    );
  }

  Column buildStatColumn(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
