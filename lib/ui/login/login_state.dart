class LoginState {
  final bool isPasswordVisible;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  LoginState({
    required this.isPasswordVisible,
    required this.isSubmitting,
    this.errorMessage,
    required this.isSuccess,
  });

  factory LoginState.initial() => LoginState(
        isPasswordVisible: false,
        isSubmitting: false,
        isSuccess: false,
      );

  LoginState copyWith({
    bool? isPasswordVisible,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
