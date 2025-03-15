import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
import '../lib.dart';

/// API WRAPPER to call all the APIs and handle the error status codes
class ApiWrapper {
  final String _baseUrl = 'http://43.204.222.20/api/';
  final String _baseUrlHttps = 'https://43.204.222.20/api/';

  var dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: 100000),
      sendTimeout: Duration(milliseconds: 10000),
      receiveTimeout: Duration(milliseconds: 100000),
      headers: <String, dynamic>{'Content-Type': 'application/json'},
      responseType: ResponseType.plain,
    ),
  );

  ApiWrapper() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Modify the request, for example, adding an Authorization token
          print('Request URL: ${options.uri}');
          options.headers['Authorization'] = 'Bearer your_token_here';
          return handler.next(options); // continue the request
        },
        onResponse: (response, handler) {
          //access token refresh token conditon here
          print('Response Status Code: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('Request failed with error: ${e.message}');
          return handler.next(e); // continue to error handling
        },
      ),
    );
  }

  /// Method to make all the requests inside the app like GET, POST, PUT, Delete
  Future<ResponseModel> makeRequest(
    String url,
    String requestType,
    dynamic data,
    bool isLoading,
    Map<String, String>? headers, [
    bool httpFlags = false,
    bool isAlreadyCompleteUri = false,
  ]) async {
    /// To see whether the network is available or notr
    if (await Utility.isNetworkAvailable()) {
      var uri =
          isAlreadyCompleteUri
              ? url
              : httpFlags
              ? _baseUrlHttps + url
              : _baseUrl + url;
      Utility.printILog(uri);
      String request = requestType.toUpperCase();
      switch (request) {
        /// Method to make the Get type request

        case "GET":
          try {
            final response = await dio.get(
              uri,
              options: Options(headers: headers),
            );
            return _returnResponse(response);
          } on TimeoutException catch (_) {
            return ResponseModel(
              data: '{"message":"Request timed out"}',
              hasError: true,
            );
          }

        case "POST":

          /// Method to make the Post type request

          try {
            if (isLoading) Utility.showLoader();
            final response = await dio.post(
              uri,
              data: jsonEncode(data),
              options: Options(headers: headers),
            );
            return _returnResponse(response);
          } on TimeoutException catch (_) {
            return ResponseModel(
              data: '{"message":"Request timed out"}',
              hasError: true,
            );
          }

        case "PUT":

          /// Method to make the Put type request

          try {
            if (isLoading) Utility.showLoader();
            final response = await dio.put(
              uri,
              data: data,
              options: Options(headers: headers),
            );

            return _returnResponse(response);
          } on TimeoutException catch (_) {
            return ResponseModel(
              data: '{"message":"Request timed out"}',
              hasError: true,
            );
          }

        case "PATCH":
          try {
            final response = await dio.patch(
              uri,
              data: jsonEncode(data),
              options: Options(headers: headers),
            );

            return _returnResponse(response);
          } on TimeoutException catch (_) {
            return ResponseModel(
              data: '{"message":"Request timed out"}',
              hasError: true,
              errorCode: 1000,
            );
          }

        case "DELETE":
          try {
            if (isLoading) Utility.showLoader();

            final response = await dio.delete(
              uri,
              data: data,
              options: Options(headers: headers),
            );

            return _returnResponse(response);
          } on TimeoutException catch (_) {
            return ResponseModel(
              data: '{"message":"Request timed out"}',
              hasError: true,
            );
          }
        default:
          return ResponseModel(
            data: '{"message":"Invalid Request"}',
            hasError: true,
          );
      }
    }
    /// If there is no network available then instead of print can show the no internet widget too
    else {
      return ResponseModel(
        data:
            '{"message":"No internet, please enable mobile data or wi-fi in your phone settings and try again"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  /// Method to return the API response based upon the status code of the server
  ResponseModel _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return ResponseModel(
          data: response.data,
          hasError: false,
          errorCode: response.statusCode,
        );
      case 400:
      case 401:
      case 406:
      case 409:
      case 500:
      case 522:
        return ResponseModel(
          data: response.data,
          hasError: true,
          errorCode: response.statusCode,
        );

      default:
        return ResponseModel(data: response.data, hasError: true, errorCode: 0);
    }
  }
}
