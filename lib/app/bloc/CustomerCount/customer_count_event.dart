part of 'customer_count_bloc.dart';

@immutable
abstract class CustomerCountEvent {
  const CustomerCountEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class getMessage extends CustomerCountEvent {
  final String message;
  getMessage({this.message});

}