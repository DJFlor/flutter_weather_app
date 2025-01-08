class APIResponse<T> {
  final T? data;
  final bool isError;
  final String? errorMessage;

  APIResponse({this.data, this.isError = false, this.errorMessage});
}
