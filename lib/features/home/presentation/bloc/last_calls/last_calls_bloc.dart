import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'last_calls_event.dart';
part 'last_calls_state.dart';

class LastCallsBloc extends Bloc<LastCallsEvent, LastCallsState> {
  LastCallsBloc() : super(LastCallsInitial()) {
    on<LastCallsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
