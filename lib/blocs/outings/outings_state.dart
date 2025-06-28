
import 'package:equatable/equatable.dart';
import 'package:dress_app/models/outing.dart';

abstract class OutingsState extends Equatable {
  const OutingsState();

  @override
  List<Object> get props => [];
}

class OutingsInitial extends OutingsState {}

class OutingsLoading extends OutingsState {}

class OutingsLoaded extends OutingsState {
  final List<Outing> outings;

  const OutingsLoaded(this.outings);

  List<Outing> get pastOutings => outings.where((o) => o.isPast).toList();
  List<Outing> get futureOutings => outings.where((o) => !o.isPast).toList();

  @override
  List<Object> get props => [outings];
}

class OutingsError extends OutingsState {
  final String message;

  const OutingsError(this.message);

  @override
  List<Object> get props => [message];
}
