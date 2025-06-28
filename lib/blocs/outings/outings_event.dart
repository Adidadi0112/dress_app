
import 'package:equatable/equatable.dart';
import 'package:dress_app/models/outing.dart';

abstract class OutingsEvent extends Equatable {
  const OutingsEvent();

  @override
  List<Object> get props => [];
}

class LoadOutings extends OutingsEvent {}

class AddOuting extends OutingsEvent {
  final Outing outing;

  const AddOuting(this.outing);

  @override
  List<Object> get props => [outing];
}

class UpdateOuting extends OutingsEvent {
  final Outing outing;

  const UpdateOuting(this.outing);

  @override
  List<Object> get props => [outing];
}

class DeleteOuting extends OutingsEvent {
  final String id;

  const DeleteOuting(this.id);

  @override
  List<Object> get props => [id];
}
