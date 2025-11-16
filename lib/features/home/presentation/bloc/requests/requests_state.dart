part of 'requests_bloc.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object> get props => [];
}

final class RequestsInitial extends RequestsState {}

final class RequestsLoading extends RequestsState {}

final class RequestsLoaded extends RequestsState {
  final List<Request> requests;

  const RequestsLoaded(this.requests);
}

final class SuccessAcceptedRequest extends RequestsState {
  final String message;

  const SuccessAcceptedRequest({required this.message});
}

final class SuccessRejectedRequest extends RequestsState {
  final String message;

  const SuccessRejectedRequest({required this.message});
}

final class RequestsError extends RequestsState {
  final String message;

  const RequestsError(this.message);
}
