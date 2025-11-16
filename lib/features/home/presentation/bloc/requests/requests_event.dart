part of 'requests_bloc.dart';

sealed class RequestsEvent extends Equatable {
  const RequestsEvent();

  @override
  List<Object> get props => [];
}

final class GetAllRequestsEvent extends RequestsEvent {}

final class AcceptRequestEvent extends RequestsEvent {
  final String uid;

  const AcceptRequestEvent(this.uid);
}

final class RejectRequestEvent extends RequestsEvent {
  final String uid;

  const RejectRequestEvent(this.uid);
}
