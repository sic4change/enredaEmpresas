class ResourcePicture {
  ResourcePicture({this.resourcePictureId, required this.resourcePhoto});

  final String? resourcePictureId;
  final String resourcePhoto;

  factory ResourcePicture.fromMap(Map<String, dynamic> data, String documentId) {
    return ResourcePicture(
      resourcePictureId: data['id'],
      resourcePhoto: data['resourcePhoto']['src'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'resourcePhoto': resourcePhoto,
    };
  }
}