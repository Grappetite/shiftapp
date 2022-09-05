import 'package:dio/dio.dart';

import '../Network/API.dart';
import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';

class LoginService {
  static Future<LoginResponse?> login(String username, String password) async {
    try {
      var dio = Dio();

      Response response = await dio.post(
        baseUrl + 'login',
        data: {'email': username, 'password': password},
// <<<<<<< HEAD
//           options: Options(
//             headers: {
//               authorization: mainLoginToken,
//             },
//           ));
// =======
      );

      var responseObject = LoginResponse.fromJson(response.data);

      print(response.data['data']);

      if (responseObject.data == null) {
        return null;
      }
      //final prefs = await SharedPreferences.getInstance();
      responseObject.data!.user!.lastName;

      Api().sp.write(tokenKey, responseObject.token!);

      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<ShiftsResponse?> getShifts(int processId) async {
    try {
      var dio = Dio();
      //final prefs = await SharedPreferences.getInstance();

      Response response =
          await dio.get(baseUrl + 'shifts/' + processId.toString(),
              options: Options(
                headers: {
                  authorization: 'Bearer ' + Api().sp.read(tokenKey)!,
                },
              ));

      //handle 404

      print(response.data);

      var responseObject = ShiftsResponse.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }
      if (responseObject.data!.isEmpty) {
        return null;
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }
}
