part of 'weight_bloc.dart';

@freezed
class WeightState with _$WeightState {
  const factory WeightState.initial() = _Initial;
  const factory WeightState.loading() = _Loading;
  const factory WeightState.loaded({required List<WeightModel> weightModel}) =
      _Loaded;

  const factory WeightState.error({required String message}) = _Error;
}
