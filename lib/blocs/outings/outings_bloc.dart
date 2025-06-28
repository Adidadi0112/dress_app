import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final List<Outing> outings;

  const OutingsLoaded({required this.outings});

  @override
  List<Object?> get props => [outings];
}

class OutingsError extends OutingsState {
  final String message;

  const OutingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class OutingsBloc extends Bloc<OutingsEvent, OutingsState> {
  OutingsBloc() : super(OutingsInitial()) {
    on<LoadOutings>(_onLoadOutings);
    on<AddOuting>(_onAddOuting);
    on<UpdateOuting>(_onUpdateOuting);
    on<DeleteOuting>(_onDeleteOuting);
  }

  List<Outing> _outings = [];

  void _onLoadOutings(LoadOutings event, Emitter<OutingsState> emit) {
    emit(OutingsLoading());
    try {
      // In a real app, this would fetch from a database or API
      emit(OutingsLoaded(outings: List.from(_outings)));
    } catch (e) {
      emit(OutingsError(e.toString()));
    }
  }

  void _onAddOuting(AddOuting event, Emitter<OutingsState> emit) {
    try {
      _outings.add(event.outing);
      emit(OutingsLoaded(outings: List.from(_outings)));
    } catch (e) {
      emit(OutingsError(e.toString()));
    }
  }

  void _onUpdateOuting(UpdateOuting event, Emitter<OutingsState> emit) {
    try {
      final index = _outings.indexWhere((o) => o.id == event.outing.id);
      if (index != -1) {
        _outings[index] = event.outing;
        emit(OutingsLoaded(outings: List.from(_outings)));
      }
    } catch (e) {
      emit(OutingsError(e.toString()));
    }
  }

  void _onDeleteOuting(DeleteOuting event, Emitter<OutingsState> emit) {
    try {
      _outings.removeWhere((o) => o.id == event.outingId);
      emit(OutingsLoaded(outings: List.from(_outings)));
    } catch (e) {
      emit(OutingsError(e.toString()));
    }
  }
}
