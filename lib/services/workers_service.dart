import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';

class WorkersService {
  static Future<WorkersListing?> getShiftWorkers(int? shiftId,int processId) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "newWorkerList/" + processId.toString();
      if (shiftId!= null) {
        url = baseUrl + 'manageWorkerLisiting/' + shiftId.toString();
      }

      var token = prefs.getString(tokenKey);
      print('');


      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = WorkersListing.fromJson(response.data);


      if (responseObject.data == null) {
        return null;
      }

      if(responseObject.data!.shiftWorker == null){
        responseObject.data!.shiftWorker = [];
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<WorkersListing?> searchWorkers(String searchId) async {
    //{{shift_url}I/searchWorker/2
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      String url = baseUrl + 'searchWorker/' + searchId;

      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );
      print(response.data);

      var responseObject = WorkersListing.fromJson(response.data,isSearch: true);
      if (responseObject.searchWorker == null) {
        return null;
      }
      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addWorkers(
      int shiftId,
      List<String> workerUserId,
      List<String> startTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'shifts/addWorkers',
        data: {
          'execute_shift_id': shiftId.toString(),
          'worker_user_id': workerUserId,
          'starttime': startTime,
          'efficiency_calculation': efficiencyCalculation,
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      if(response.data['code'] == 200){
        return true;
      }

      return false;

    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeWorkers(
      int shiftId,
      List<String> workerUserId,
      List<String> endTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString(tokenKey)!;

      Response response = await dio.post(
        baseUrl + 'shifts/removeWorkers',
        data: {
          'execute_shift_id': shiftId.toString(),
          'worker_user_id': workerUserId,
          'endtime': endTime,
          'efficiency_calculation': efficiencyCalculation
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      if(response.data['code'] == 200){
        return true;
      }

      return false;

    } catch (e) {
      return false;
    }
  }


  static Future<bool> endShift(
      int shiftId,
      int processId,
      String unitsProduced,
      String comment,
      String endTime) async {
    try {

      var logger = Logger();

      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'endShift',
        data: {
          'execute_shift_id': shiftId.toString(),
          'process_id': processId.toString(),
          'end_time': endTime,
          'units_produced': unitsProduced,
          'comments' : 'comment'
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );


      print(response.data);

      if(response.data['code'] == 200){
        return true;
      }

      return false;

    } catch (e) {
      return false;
    }
  }



  static Future<AddWorkersResponse?> addShiftWorker(
      int shiftId,
      int processId ,
      String startTime,
      String endTime,
      List<String> workerUserId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'addShiftWorker',
        data: {
          'shift_id': shiftId.toString(),
          'process_id': processId.toString(),
          'start_time': startTime,
          'end_time' : endTime,
          'worker_user_id' : workerUserId,
          'efficiency_calculation': efficiencyCalculation
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      var responseObject = AddWorkersResponse.fromJson(response.data);

      if (responseObject.code != 200) {
        return null;
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }


  static Future<WorkerTypeResponse?> getWorkTypes(String shiftId,String processId) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      Response response = await dio.get(baseUrl + 'workerType/' + processId,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      var responseObject = WorkerTypeResponse.fromJson(response.data);

      print(response.data);

      if (responseObject.data == null) {
        return null;
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<AddTempResponse?> addTempWorkers(
      String firstName, String lastName, String key, String workerType,String shiftId , String startTime) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      // ,
      Response response = await dio.post(
        baseUrl + 'workers',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'key': key,
          'worker_type': workerType,
          'execute_shift_id' : shiftId ,
          'start_time' : startTime
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      var responseObject = AddTempResponse.fromJson(response.data);

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
