import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'customer_count_event.dart';
part 'customer_count_state.dart';

class CustomerCountBloc extends Bloc<CustomerCountEvent, CustomerCountState> {
  CustomerCountBloc(CustomerCountState initialState) : super(initialState);




  @override
  Stream<CustomerCountState> mapEventToState(
    CustomerCountEvent event,
  ) async* {
    switch(event.runtimeType){
      case getMessage:
        yield* _MapMessageState(event);
        break;
    }
  }

  Stream<CustomerCountState> _MapMessageState(getMessage event)async*{
    yield ResultMessage(message: event.message);
  }

}


