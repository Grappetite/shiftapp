import 'package:dio/dio.dart';

import '../Network/API.dart';
import '../config/constants.dart';
import '../model/shifts_model.dart';

class ShiftService {
  static Future<ShiftStartModel?> startShift(
      int shiftId, int processId, String startTime, String endTime) async {
    try {
      var dio = Dio();
      //final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'shifts',
        data: {
          'shift_id': shiftId.toString(),
          'process_id': processId.toString(),
          'start_time': startTime,
          'end_time': endTime
        },
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
      //     //final prefs = await SharedPreferences.getInstance();
      //   responseObject.data!.user!.lastName;

      // prefs.setString(tokenKey, responseObject.token!);

      return responseObject;
    } catch (e) {
      return null;
    }
  }
}
