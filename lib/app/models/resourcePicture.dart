class ResourcePicture {
  ResourcePicture({required this.id, required this.resourcePhoto, required this.name, required this.role});

  factory ResourcePicture.fromMap(Map<String, dynamic> data, String documentId) {
    return ResourcePicture(
      id: data['id'],
      resourcePhoto: data['resourcePhoto']['src'],
      name: data['resourcePhoto']['title'],
      role: data['role'],
    );
  }
  final String id;
  final String resourcePhoto;
  final String name;
  final String role;

  @override
  bool operator == (Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResourcePicture &&
            other.id == id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resourcePhoto': resourcePhoto,
      'name': name,
      'role': role,
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

}