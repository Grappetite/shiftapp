import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/ppe_model.dart';
import 'package:shiftapp/services/login_service.dart';

class PPEService {
  static Future<PpeModel>? getPPE(int processId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(baseUrl + 'ppe/',
          queryParameters: {"process_id": processId.toString()},
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = PpeModel.fromJson(response.data);

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static postPpe({Datum? ppe, comment, check, int? processId}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      var list = "";
      ppe!.details!.forEach((element) {
        list = list + element.id.toString() + ",";
      });
      Response response = await dio.post(baseUrl + "ppe",
          data: FormData.fromMap({
            // "sop_id": sopDetail.id,
            "ppe_id": list.substring(0, list.length - 1),
            "worker_type_id": ppe.workerTypeId,
            "update_required": check,
            "comments": comment,
            "process_id": processId,
          }),
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
              Headers.acceptHeader: "application/json",
            },
            contentType: 'multipart/form-data',
          ));
      if (response.statusCode == 200) {
        print(true);
      }
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }
}
