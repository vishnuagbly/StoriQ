enum FileType {
  pic,
  video,
  story,
}

class MediaFile {
  final FileType fileType;
  final String fileLink;

  MediaFile(this.fileType, this.fileLink);

  MediaFile.fromMap(Map<String, dynamic> map)
      : fileType = FileType.values[map["fileType"]],
        fileLink = map["link"];

  Map<String, dynamic> toMap() => {"fileType": fileType.index, "link": fileLink};

  static List<MediaFile> allFromMaps(maps) {
    List<MediaFile> result = [];
    if (maps != null)
      for (Map<String, dynamic> map in maps) result.add(MediaFile.fromMap(map));
    return result;
  }

  static List<Map<String, dynamic>> allToMaps(List<MediaFile> mediaFiles) {
    List<Map<String, dynamic>> maps = [];
    if (mediaFiles != null)
      for (MediaFile mediaFile in mediaFiles) maps.add(mediaFile.toMap());
    return maps;
  }
}

MediaFile dummy = MediaFile(null, null);
