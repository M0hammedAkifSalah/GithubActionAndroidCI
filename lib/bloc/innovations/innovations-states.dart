import '/model/innovations.dart';

abstract class InnovationStates {}

class InnovationsLoading extends InnovationStates {}

class InnovationsLoaded extends InnovationStates {
  final List<Innovation> innovations;
  final bool hasMore;
  InnovationsLoaded(this.innovations,this.hasMore);
}

abstract class InnovationCurrentState {}

class CurrentInnovationLoaded extends InnovationCurrentState {
  Innovation innovation;
  bool seeInnovation;
  CurrentInnovationLoaded(this.innovation, this.seeInnovation);
}

class CurrentInnovationNotLoaded extends InnovationCurrentState {}
