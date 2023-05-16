class ResourcePicture {
  ResourcePicture({this.resourcePictureId, required this.resourcePic});

  final String? resourcePictureId;
  final String resourcePic;

  factory ResourcePicture.fromMap(Map<String, dynamic> data, String documentId) {
    return ResourcePicture(
      resourcePictureId: data['id'],
      resourcePic: data['resourcePhoto']['src'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'resourcePic': resourcePic,
    };
  }
}