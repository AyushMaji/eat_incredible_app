part of 'weight_bloc.dart';

@freezed
class WeightEvent with _$WeightEvent {
  const factory WeightEvent.started() = _Started;
  const factory WeightEvent.getWeight(String pid) = _GetWeight;
}
