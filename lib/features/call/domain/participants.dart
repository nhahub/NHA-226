class Participants {
  final String name;
  final int uid;
  final bool isYou;
  final bool isSpeaking;
  final bool isMuted;

  Participants({
    required this.name,
    required this.uid,
    this.isYou = false,
    this.isSpeaking = false,
    this.isMuted = false,
  });
}
