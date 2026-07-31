class NoInternetState {
  final bool isChecking;
  final bool isSuccess;
  final String? errorMessage;

  NoInternetState({
    required this.isChecking,
    required this.isSuccess,
    this.errorMessage,
  });

  factory NoInternetState.initial() => NoInternetState(
        isChecking: false,
        isSuccess: false,
      );

  NoInternetState copyWith({
    bool? isChecking,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return NoInternetState(
      isChecking: isChecking ?? this.isChecking,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}
