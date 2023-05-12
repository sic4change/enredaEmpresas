class Message {
  Message({this.messageId, required this.userId, required this.order,
    required this.sendby, required this.message
  });

  final String? messageId;
  final String userId;
  final int order;
  final String sendby;
  final String message;


  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'userId': userId,
      'order': order,
      'sendby': sendby,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    final String message = data['message'];
    final String userId = data['userId'];
    final int order = data['order'];
    final String sendby = data['sendby'];

    return Message(
      messageId: documentId,
      userId: userId,
      order: order,
      sendby: sendby,
      message: message,
    );
  }

}