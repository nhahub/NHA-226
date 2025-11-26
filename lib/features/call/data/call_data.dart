import 'package:lingo_sign/features/call/domain/participants.dart';

class CallData {
  final List<Participants> participants;
  final bool isMicOn;
  final bool isCameraOn;
  final String? meetingId;
  final String? uid;

  const CallData({
    this.participants = const [],
    this.isMicOn = true,
    this.isCameraOn = true,
    this.meetingId,
    this.uid,
  });

  CallData copyWith({
    List<Participants>? participants,
    bool? isMicOn,
    bool? isCameraOn,
    String? meetingId,
    String? uid,
  }) {
    return CallData(
      participants: participants ?? this.participants,
      isMicOn: isMicOn ?? this.isMicOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      meetingId: meetingId ?? this.meetingId,
      uid: uid ?? this.uid,
    );
  }
}
