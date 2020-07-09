import 'dart:developer';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:storiq/network.dart';
import 'package:video_player/video_player.dart';
import '../JSON/media_file.dart';

class AddFile extends StatefulWidget {
  AddFile({this.addProfileImage = false});

  final bool addProfileImage;

  @override
  _AddFileState createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  PickedFile _file;
  String _uploadedFileURL;
  String _uploadingURL = '$user/files/${mainUserProfile.totalFiles.toString()}';
  FileType _fileType = FileType.pic;
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (widget.addProfileImage) _uploadingURL = "$user/profilePic";
    log("building Add Page", name: "AddFile");
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[150],
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_fileType == FileType.pic
                      ? 'Selected Image'
                      : 'Selected Video'),
                  _file != null
                      ? _fileType == FileType.pic
                          ? Image.file(
                              File(_file.path),
                              height: 150,
                            )
                          : Chewie(
                              controller: ChewieController(
                                videoPlayerController:
                                    VideoPlayerController.file(File(_file.path)),
                                aspectRatio: 1,
                                autoPlay: true,
                                looping: true,
                              ),
                            )
                      : Container(height: 150),
                  _file == null
                      ? Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RadioListTile(
                                  title: const Text("Photo"),
                                  value: FileType.pic,
                                  groupValue: _fileType,
                                  onChanged: (FileType value) {
                                    setState(() {
                                      _fileType = value;
                                    });
                                  },
                                ),
                                !widget.addProfileImage
                                    ? RadioListTile(
                                        title: const Text("Video"),
                                        value: FileType.video,
                                        groupValue: _fileType,
                                        onChanged: (FileType value) {
                                          setState(() {
                                            _fileType = value;
                                          });
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text('Choose File'),
                                  onPressed: chooseFile,
                                  color: Colors.cyan,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                RaisedButton(
                                  child: Text("Capture"),
                                  onPressed: captureFile,
                                  color: Colors.cyan,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  _file != null
                      ? RaisedButton(
                          child: Text('Upload File'),
                          onPressed: () => uploadFile(widget.addProfileImage),
                          color: Colors.cyan,
                        )
                      : Container(),
                  _file != null
                      ? RaisedButton(
                          child: Text('Clear Selection'),
                          onPressed: clearSelection,
                        )
                      : Container(),
                  Text('Uploaded Image'),
                  _uploadedFileURL != null
                      ? _fileType == FileType.pic
                          ? Image.network(
                              _uploadedFileURL,
                              height: 150,
                            )
                          : Chewie(
                              controller: ChewieController(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                        _uploadedFileURL),
                                aspectRatio: 1,
                                autoPlay: true,
                                looping: true,
                              ),
                            )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clearSelection() {
    setState(() {
      _file = null;
      _uploadedFileURL = null;
    });
  }

  Future captureFile() async {
    if (_fileType == FileType.pic) {
      await _picker.getImage(source: ImageSource.camera).then((image) {
        setState(() {
          _file = image;
        });
      });
      return;
    }
    await _picker
        .getVideo(source: ImageSource.camera, maxDuration: Duration(minutes: 3))
        .then((video) {
      setState(() {
        _file = video;
      });
    });
  }

  Future chooseFile() async {
    if (_fileType == FileType.pic) {
      await _picker.getImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _file = image;
        });
      });
      return;
    }
    await _picker.getVideo(source: ImageSource.gallery).then((video) {
      setState(() {
        _file = video;
      });
    });
  }

  Future uploadFile(bool addProfileImage) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_uploadingURL);
    StorageUploadTask uploadTask = storageReference.putFile(File(_file.path));
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      if (addProfileImage) {
        mainUserProfile.profilePhoto = fileURL;
        uploadMainUserData();
      } else
        addFile(MediaFile(_fileType, fileURL));
      log("file uploaded successfully", name: "uploadFile");
      log("file url: $fileURL", name: "uplaodFile");
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}
