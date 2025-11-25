class Participants {
  final String name;
  final bool isSpeaking;
  final bool isYou;
  final String? uid;
  final String? meetingId;

  Participants({
    required this.name,
    required this.isSpeaking,
    required this.isYou,
    this.uid,
    this.meetingId,
  });
}
