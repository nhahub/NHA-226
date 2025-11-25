import 'package:lingo_sign/features/meeting_call/domain/models/Participants.dart';

class MeetingData {
  final List<Participants> participants;
  final bool isMicOn;
  final bool isCameraOn;
  final String? meetingId;
  final String? uid;

  const MeetingData({
    this.participants = const [],
    this.isMicOn = true,
    this.isCameraOn = true,
    this.meetingId,
    this.uid,
  });

  MeetingData copyWith({
    List<Participants>? participants,
    bool? isMicOn,
    bool? isCameraOn,
    String? meetingId,
    String? uid,
  }) {
    return MeetingData(
      participants: participants ?? this.participants,
      isMicOn: isMicOn ?? this.isMicOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      meetingId: meetingId ?? this.meetingId,
      uid: uid ?? this.uid,
    );
  }
}
