import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../Network/API.dart';
import '../config/constants.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';

class WorkersService {
  static Future<WorkersListing?> getShiftWorkers(
      int? shiftId, int processId) async {
    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    String url = "newWorkerList/" + processId.toString();
    if (shiftId != null) {
      url = 'manageWorkerLisiting/' + shiftId.toString();
    }
    var token = Api().sp.read(tokenKey);
    print('');

    Response response = await Api().get(
      url,
    );

    print(response.data);

    if (response.statusCode != 200) {
      print(response.data);

      var responseObject = WorkersListing.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      if (responseObject.data!.shiftWorker == null) {
        responseObject.data!.shiftWorker = [];
      }

      return responseObject;
    }
    var responseObject = WorkersListing.fromJson(response.data);

    if (responseObject.data!.shiftWorker == null) {
      responseObject.data!.shiftWorker = [];
    }

    return responseObject;
  }

  static Future<WorkersListing?> searchWorkers(String searchId) async {
    //{{shift_url}I/searchWorker/2

    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();
    String url = baseUrl + 'searchWorker/' + searchId;

    Response response = await Api().get(
      url,
    );
    print(response.data);

    if (response.statusCode != 200) {
      var responseObject =
          WorkersListing.fromJson(response.data, isSearch: true);
      if (responseObject.searchWorker == null) {
        return null;
      }
      return responseObject;
    }
    var responseObject = WorkersListing.fromJson(response.data, isSearch: true);

    return responseObject;
  }

  static Future<bool> addWorkers(
      int shiftId,
      List<String> workerUserId,
      List<String> startTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    Response response = await Api().post(
      {
        'execute_shift_id': shiftId.toString(),
        'worker_user_id': workerUserId,
        'starttime': startTime,
        'efficiency_calculation': efficiencyCalculation,
      },
      'shifts/addWorkers',
    );

    print(response.data);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<bool> removeWorkers(
      int shiftId,
      List<String> workerUserId,
      List<String> endTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    var token = Api().sp.read(tokenKey)!;

    Response response = await Api().post(
      {
        'execute_shift_id': shiftId.toString(),
        'worker_user_id': workerUserId,
        'endtime': endTime,
        'efficiency_calculation': efficiencyCalculation
      },
      'shifts/removeWorkers',
    );

    print(response.data);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<bool> endShift(int shiftId, int processId, String unitsProduced,
      String comment, String endTime) async {
    var logger = Logger();

    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    var ccc = Api().sp.read(tokenKey)!;

    logger.e('Bearer ' + Api().sp.read(tokenKey)!);

    logger.e(shiftId.toString());

    logger.e(endTime);
    logger.e(unitsProduced);
    logger.e(comment);

    Response response = await Api().post(
      {
        'execute_shift_id': shiftId.toString(),
        'process_id': processId.toString(),
        'end_time': endTime,
        'units_produced': unitsProduced,
        'comments': 'comment'
      },
      'endShift',
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<AddWorkersResponse?> addShiftWorker(
      int shiftId,
      int processId,
      String startTime,
      String endTime,
      List<String> workerUserId,
      List<String> efficiencyCalculation,
      String comment) async {
    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    Response response = await Api().post(
      {
        'shift_id': shiftId.toString(),
        'process_id': processId.toString(),
        'start_time': startTime,
        'end_time': endTime,
        'worker_user_id': workerUserId,
        'efficiency_calculation': efficiencyCalculation,
        'comment': comment,
      },
      'addShiftWorker',
    );

    // print(response!.data);

    if (response!.statusCode != 200) {
      var responseObject = AddWorkersResponse.fromJson(response.data);

      return responseObject;
    }
  }

  static Future<WorkerTypeResponse?> getWorkTypes(
      String shiftId, String processId) async {
    var dio = Dio();
    // final prefs = await SharedPreferences.getInstance();
    Response response = await Api().get(
      'workerType/' + processId,
    );

    print(response.data);

    if (response.statusCode != 200) {
      return null;
    }
    var responseObject = WorkerTypeResponse.fromJson(response.data);

    return responseObject;
  }

  static Future<AddTempResponse?> addTempWorkers(
      String firstName,
      String lastName,
      String key,
      String workerType,
      String shiftId,
      String startTime) async {
    var dio = Dio();
    //final prefs = await SharedPreferences.getInstance();

    // ,
    Response response = await Api().post(
      {
        'first_name': firstName,
        'last_name': lastName,
        'key': key,
        'worker_type': workerType,
        'execute_shift_id': shiftId,
        'start_time': startTime
      },
      'workers',
    );
    print(response.data);

    if (response.statusCode != 200) {
      return null;
    }
    var responseObject = AddTempResponse.fromJson(response.data);

    //     //final prefs = await SharedPreferences.getInstance();
    //   response.statusCode!.user!.lastName;

    // prefs.setString(tokenKey, responseObject.token!);

    return responseObject;
  }
}
