class CallModel {
  final String callerId;
  final String channelName;
  final String token;
  final String status;
  CallModel({required this.callerId, required this.channelName, required this.token, required this.status});
  factory CallModel.fromMap(Map<String, dynamic> m) => CallModel(callerId: m['callerId'] as String, channelName: m['channelName'] as String, token: m['token'] as String, status: m['status'] as String);
}
