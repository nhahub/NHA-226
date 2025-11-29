abstract class MeetingState {}

class MeetingInitial extends MeetingState {}

class MeetingJoining extends MeetingState {
  final String? meetingId;
  final String? uid;

  MeetingJoining({this.meetingId, this.uid});
}

class MeetingInProgress extends MeetingState {
  final List<Map<String, dynamic>> participants;
  final bool isMicOn;
  final bool isCameraOn;
  final String? meetingId;
  final String? uid;

  MeetingInProgress({
    this.participants = const [{}],
    this.isMicOn = true,
    this.isCameraOn = true,
    this.meetingId,
    this.uid,
  });
}

class MeetingEnded extends MeetingState {}
