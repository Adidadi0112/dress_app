import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dress_app/models/outing.dart';

// Events
abstract class OutingsEvent extends Equatable {
  const OutingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadOutings extends OutingsEvent {}

class AddOuting extends OutingsEvent {
  final Outing outing;

  const AddOuting(this.outing);

  @override
  List<Object?> get props => [outing];
}

class UpdateOuting extends OutingsEvent {
  final Outing outing;

  const UpdateOuting(this.outing);

  @override
  List<Object?> get props => [outing];
}

class DeleteOuting extends OutingsEvent {
  final String outingId;

  const DeleteOuting(this.outingId);

  @override
  List<Object?> get props => [outingId];
}

// States
abstract class OutingsState extends Equatable {
  const OutingsState();

  @override
  List<Object?> get props => [];
}

class OutingsInitial extends OutingsState {}

class OutingsLoading extends OutingsState {}

class OutingsLoaded extends OutingsState {
  final List<Outing> pastOutings;
  final List<Outing> futureOutings;

  const OutingsLoaded({required this.pastOutings, required this.futureOutings});

  @override
  List<Object?> get props => [pastOutings, futureOutings];
}

class OutingsError extends OutingsState {
  final String message;

  const OutingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class OutingsBloc extends Bloc<OutingsEvent, OutingsState> {
  final List<Outing> _outings = [];

  OutingsBloc() : super(OutingsInitial()) {
    on<LoadOutings>(_onLoadOutings);
    on<AddOuting>(_onAddOuting);
    on<UpdateOuting>(_onUpdateOuting);
    on<DeleteOuting>(_onDeleteOuting);
  }

  void _onLoadOutings(LoadOutings event, Emitter<OutingsState> emit) {
    emit(OutingsLoading());

    final now = DateTime.now();
    final pastOutings =
        _outings.where((o) => o.date.isBefore(now)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    final futureOutings =
        _outings.where((o) => o.date.isAfter(now)).toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    emit(OutingsLoaded(pastOutings: pastOutings, futureOutings: futureOutings));
  }

  void _onAddOuting(AddOuting event, Emitter<OutingsState> emit) {
    _outings.add(event.outing);
    add(LoadOutings());
  }

  void _onUpdateOuting(UpdateOuting event, Emitter<OutingsState> emit) {
    final index = _outings.indexWhere((o) => o.id == event.outing.id);
    if (index != -1) {
      _outings[index] = event.outing;
      add(LoadOutings());
    }
  }

  void _onDeleteOuting(DeleteOuting event, Emitter<OutingsState> emit) {
    _outings.removeWhere((o) => o.id == event.outingId);
    add(LoadOutings());
  }
}
