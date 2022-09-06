import 'package:dio/dio.dart';

import '../Network/API.dart';
import '../config/constants.dart';
import '../model/shifts_model.dart';

class ShiftService {
  static Future<ShiftStartModel?> cancelShift(
    int shiftId,
    String endTime,
  ) async {
    try {
      var dio = Dio();

      var cc = Api().sp.read(tokenKey);

      Response response = await dio.post(
        baseUrl + 'cancelShift',
        data: {'execute_shift_id': shiftId.toString(), 'end_time': endTime},
        options: Options(
          headers: {
            authorization: 'Bearer ' + Api().sp.read(tokenKey)!,
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

  static Future<bool> endShift(int shiftId, int processId, String unitsProduced,
      String comment, String endTime) async {
    try {
      var dio = Dio();
      // final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'endShift',
        data: {
          'execute_shift_id': shiftId.toString(),
          'process_id': processId.toString(),
          'end_time': endTime,
          'units_produced': unitsProduced,
          'comments': 'comment'
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + Api().sp.read(tokenKey)!,
          },
        ),
      );

      print(response.data);

      if (response.data['code'] == 200) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
