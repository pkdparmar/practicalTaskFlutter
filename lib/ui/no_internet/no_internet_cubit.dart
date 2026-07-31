import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'no_internet_state.dart';

class NoInternetCubit extends Cubit<NoInternetState> {
  NoInternetCubit() : super(NoInternetState.initial());

  Future<void> checkConnection() async {
    emit(state.copyWith(isChecking: true));
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        emit(state.copyWith(isChecking: false, isSuccess: true));
      } else {
        emit(state.copyWith(
          isChecking: false,
          errorMessage: 'No internet connection detected. Please try again.',
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        isChecking: false,
        errorMessage: 'No internet connection detected. Please try again.',
      ));
    }
  }
}
