import 'package:scango/lib.dart';

import 'package:scango/networking/api-wrapper.dart';

class ApiClient {
  ApiWrapper apiWrapper = ApiWrapper();
  Future<ResponseModel> getDummy() {
    return apiWrapper.makeRequest(
      'https://dummyjson.com/test',
      "get",
      null,
      false,
      {'Content-Type': 'application/json'},
      false,
      true,
    );
  }

  // Future<ResponseModel> sendOTP(
  //     {required String keyType1,
  //     required String value1,
  //     required String typeValue,
  //     required bool isLoading}) async {
  //   var data = {'$keyType1': '$value1', 'type': '$typeValue'};
  //   var response = await apiWrapper.makeRequest('send-otp', "get", data,
  //       isLoading, {'Content-Type': 'application/json'});
  //   return response;
  // }
}
