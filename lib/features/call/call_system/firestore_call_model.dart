class Call {
  final String callerId;
  final String receiverId;
  final String channel;
  final String status;

  Call({
    required this.callerId,
    required this.receiverId,
    required this.channel,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'channel': channel,
      'status': status,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'],
      receiverId: map['receiverId'],
      channel: map['channel'],
      status: map['status'],
    );
  }
}
