import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/data/local/pref_helper.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()) {
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await PrefHelper.isLoggedIn();
    if (loggedIn) {
      emit(NavigateToDashboard());
    } else {
      emit(NavigateToLogin());
    }
  }
}
