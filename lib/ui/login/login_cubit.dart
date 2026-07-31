import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/data/local/pref_helper.dart';
import 'package:practicletestone/app/app_class.dart';
import 'package:practicletestone/utils/validation_helper.dart';
import 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginCubit() : super(LoginState.initial());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  String? validateEmail(String? value) => ValidationHelper.validateEmail(value);
  String? validatePassword(String? value) => ValidationHelper.validatePassword(value);

  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      emit(state.copyWith(isSubmitting: true));
      AppClass().showLoading(true);
      try {
        await Future.delayed(const Duration(seconds: 2));
        await PrefHelper.setLoggedIn(true);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: 'Login failed. Please try again.'));
      } finally {
        AppClass().showLoading(false);
      }
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
