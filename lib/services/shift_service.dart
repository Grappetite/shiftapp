import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import 'package:logger/logger.dart';


class ShiftService {


  static Future<ShiftStartModel?> cancelShift(
      int shiftId , String endTime, ) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      var cc = prefs.getString(tokenKey);

      Response response = await dio.post(
        baseUrl + 'cancelShift',
        data: {
          'execute_shift_id': shiftId.toString(),
          'end_time': endTime
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      var responseObject = ShiftStartModel.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }

}
