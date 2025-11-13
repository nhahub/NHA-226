
class Request {
  late String fromId;
  late String toId;
  late String status;
  late DateTime? time;

  Request({
    required this.fromId,
    required this.toId,
    required this.status,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromId': fromId,
      'toId': toId,
      'status': status,
      'timeAt': time,
    };
  }


  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      fromId: map['fromId'],
      toId: map['toId'],
      status: map['status'],
      time: map['timeAt']
    );
  }
}
