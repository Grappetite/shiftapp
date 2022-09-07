import 'package:dio/dio.dart';

import '../Network/API.dart';
import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';

class LoginService {
  static Future<LoginResponse?> login(String username, String password) async {
    // try {
    var dio = Dio();

    Response response = await Api().post(
      {'email': username, 'password': password}, 'login',

// <<<<<<< HEAD
//           options: Options(
//             headers: {
//               authorization: mainLoginToken,
//             },
//           ));
// =======
    );

    print(response.data['data']);

    if (response.statusCode != 200) {
      var responseObject = LoginResponse.fromJson(response.data);

      print(response.data['data']);
      responseObject.data!.user!.lastName;

      Api().sp.write(tokenKey, responseObject.token!);

      return responseObject;
    }

    // } catch (e) {
    //   return null;
    // }
  }

  static Future<ShiftsResponse?> getShifts(int processId) async {
    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    Response response = await Api().get(
      'shifts/' + processId.toString(),
    );

    //handle 404

    print(response.data);

    if (response.statusCode == null) {
      return null;
    }
    var responseObject = ShiftsResponse.fromJson(response.data);

    if (responseObject.data!.isEmpty) {
      return null;
    }

    return responseObject;
  }
}
