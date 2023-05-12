class Contact {
  Contact({this.contactId, required this.email, required this.name, required this.text});

  factory Contact.fromMap(Map<String, dynamic> data, String documentId) {
    final String contactId = data['contactId'];
    final String email = data['email'];
    final String name = data['name'];
    final String text = data['text'];

    return Contact(
      contactId: contactId,
      email: email,
      name: name,
      text: text,
    );
  }

  final String? contactId;
  final String email;
  final String name;
  final String text;

  Map<String, dynamic> toMap() {
    return {
      'contactId': contactId,
      'email' : email,
      'name' : name,
      'text' : text,
    };
  }
}