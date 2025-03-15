import 'package:flutter/material.dart';
import 'package:scango/lib.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  Future<void> callApi() async {
    final apiClient = ApiClient();
    final response = await apiClient.getDummy();
    Utility.printLog(response.data);
  }

  @override
  Widget build(BuildContext context) {
    callApi();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: const Text('Sign Up Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
