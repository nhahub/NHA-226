part of 'requests_bloc.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();
  
  @override
  List<Object> get props => [];
}

final class RequestsInitial extends RequestsState {}
