import 'package:dio/dio.dart' hide Headers;

class ServerError implements Exception {
  int _errorCode = 0;
  String _errorMessage = '';

  ServerError.withError({required DioError error}) {
    _handleError(error);
  }

  ServerError.withStringError({int? errorCode, required String error}) {
    _errorMessage = error;
    _errorCode = errorCode ?? 0;
  }

  int getErrorCode() {
    return _errorCode;
  }

  String getErrorMessage() {
    return _errorMessage;
  }

  String _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        _errorMessage = 'Request was cancelled';
        break;
      case DioErrorType.connectTimeout:
        _errorMessage = 'Connection timeout';
        break;
      case DioErrorType.other:
        _errorMessage = 'Connection failed due to internet connection';
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = 'Receive timeout in connection';
        break;
      case DioErrorType.response:
        _errorMessage = 'Received invalid status code: '
            '${error.response?.statusCode ?? '500'}';
        break;
      case DioErrorType.sendTimeout:
        _errorMessage = 'Receive timeout in send request';
        break;
    }
    return _errorMessage;
  }
}
