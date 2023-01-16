import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/weight/weight_model.dart';
import 'package:eat_incredible_app/repo/product_details_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_event.dart';
part 'weight_state.dart';
part 'weight_bloc.freezed.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  WeightBloc() : super(const _Initial()) {
    on<_GetWeight>((event, emit) async {
      emit(const _Loading());
      List<WeightModel> weightModellist = [];
      var result = await ProductDetailsRepo().getWeightData(event.pid);
      result.when(
        success: (data) {
          for (var i in data) {
            weightModellist.add(WeightModel.fromJson(i));
          }
          emit(_Loaded(weightModel: weightModellist));
        },
        failure: (error) {
          emit(_Error(message: NetworkExceptions.getErrorMessage(error)));
        },
      );
    });
  }
}
