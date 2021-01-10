part of 'customer_count_bloc.dart';

@immutable
abstract class CustomerCountState {
  const CustomerCountState();
  @override
  List<Object> get props => [];
}



class ResultMessage extends CustomerCountState {
  final String message;

  const ResultMessage({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Loaded { items: ${message} }';
}
