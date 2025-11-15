class RequestModel {
  final String uid;
  final String status;
  final DateTime createdAt;

  RequestModel({
    required this.uid,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'status': status, 'created_at': createdAt};
  }

  factory RequestModel.fromJson(Map<String, dynamic> map) {
    return RequestModel(
      uid: map['uid'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }
}
