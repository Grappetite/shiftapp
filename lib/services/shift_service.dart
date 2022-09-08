import 'package:dio/dio.dart';

import '../Network/API.dart';
import '../model/shifts_model.dart';

class ShiftService {
  static Future<ShiftStartModel?> cancelShift(
    int shiftId,
    String endTime,
  ) async {
    var dio = Dio();

    Response response = await Api().post(
      {'execute_shift_id': shiftId.toString(), 'end_time': endTime},
      'cancelShift',
    );

    print(response.data);

    var responseObject = ShiftStartModel.fromJson(response.data);

    if (responseObject.data == null) {
      return null;
    }

    return responseObject;
  }

  static Future<bool> endShift(
      int shiftId, int processId, String unitsProduced, String endTime) async {
    Response response = await Api().post({
      'execute_shift_id': shiftId.toString(),
      'process_id': processId.toString(),
      'end_time': endTime,
      'units_produced': unitsProduced,
      'comments': 'comment'
    }, 'endShift');

    print(response.data);

    if (response.data['code'] == 200) {
      return true;
    }

    return false;
  }
}
