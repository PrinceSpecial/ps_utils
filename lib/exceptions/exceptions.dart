class PSException implements Exception {
  final String message;
  final int? errorCode; // Optional error code for more granularity

  // Constructor for the exception
  PSException({required this.message, this.errorCode});

  @override
  String toString() {
    // if (errorCode != null) {
    //   return 'An error occurred (Code: $errorCode): $message';
    // }
    return 'An error occurred: $message';
  }
}
