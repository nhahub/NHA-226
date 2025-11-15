// enum CallType { send, cancel, noRespons}

class LastCall {
  final String uid;
  final String name;
  final String imageUrl;
  final DateTime lastSeen;

  LastCall({
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.lastSeen,
  });
}