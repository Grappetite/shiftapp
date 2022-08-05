import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../model/workers_model.dart';

class WorkersService {


  static Future<WorkersListing?> getShiftWorkers(int shiftId) async {

    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      Response response = await dio.get(baseUrl + 'workers/' + shiftId.toString(),
          options: Options(
            headers: {
              authorization:
              'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));


      var responseObject = WorkersListing.fromJson(response.data);

      if(responseObject.data == null) {
        return null;
      }



      return responseObject;
    }
    catch(e) {
      return null;

    }


  }




  static Future<ShiftStartModel?> addWorkers(
      int shiftId, List<String> workerUserId, List<String> startTime, List<String> executeShiftId, List<String> efficiencyCalculation) async {
    try {

      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'shifts/workers',
        data: {
          'execute_shift_id': shiftId.toString(),
          'worker_user_id': workerUserId,
          'starttime': startTime,
          'efficiency_calculation': efficiencyCalculation
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
      //     final prefs = await SharedPreferences.getInstance();
      //   responseObject.data!.user!.lastName;

      // prefs.setString(tokenKey, responseObject.token!);

      return responseObject;
    } catch (e) {
      return null;
    }
  }



}