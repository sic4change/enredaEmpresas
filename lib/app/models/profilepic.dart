class ProfilePic {
  ProfilePic({required this.src, required this.title,
  });

  factory ProfilePic.fromMap(Map<String, dynamic> data, String documentId) {
    final String src = data['src'];
    final String title = data['title'];

    return ProfilePic(
        src: src,
        title: title
    );
  }

  final String src;
  final String title;

  Map<String, dynamic> toMap() {
    return {
      'src': src,
      'title': title,
    };
  }
}