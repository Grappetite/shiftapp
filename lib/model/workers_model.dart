class WorkersListing {
  int? code;
  String? status;
  String? message;
  WorkersData? data;

  List<ShiftWorker>? searchWorker;

  WorkersListing({this.code, this.status, this.message, this.data});

  WorkersListing.fromJson(Map<String, dynamic> json,{bool isSearch = false}) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if(isSearch) {
      searchWorker = [];

      json['data'].forEach((v) {
        searchWorker!.add( ShiftWorker.fromJson(v));
      });

      print(searchWorker);

    }
    else {
      data = json['data'] != null ? WorkersData.fromJson(json['data']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WorkersData {
  List<ShiftWorker>? worker;
  List<ShiftWorker>? shiftWorker;

  WorkersData({this.worker, this.shiftWorker});

  WorkersData.fromJson(Map<String, dynamic> json) {
    print(json);

    shiftWorker = <ShiftWorker>[];

    worker = <ShiftWorker>[];

    if (json['worker'] != null) {
      var workersListTemp = json['worker'];

      json['worker'].forEach((v) {
        var toAddAdd =  ShiftWorker.fromJson(v);

        if(toAddAdd.workerTypeId != null)  {
          worker!.add( ShiftWorker.fromJson(v));
        }

      });
    }
    if (json['shift_worker'] != null) {
      json['shift_worker'].forEach((v) {
        var toAddAdd =  ShiftWorker.fromJson(v);
        if(toAddAdd.workerTypeId != null)  {
          shiftWorker!.add(ShiftWorker.fromJson(v));
        }
      });
    }
    else {
      shiftWorker = <ShiftWorker>[];

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (worker != null) {
      data['worker'] = worker!.map((v) => v.toJson()).toList();
    }
    if (shiftWorker != null) {
      data['shift_worker'] = shiftWorker!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ShiftWorker {
  int? id;
  int? userId;
  int? workerTypeId;
  String? workerType;
  String? firstName;
  String? lastName;
  String? key;
  int? efficiencyCalculation;

  String picture = '';

  bool isSelected = false;

  bool newAdded = false;
  bool newRemove = false;


  ShiftWorker(
      {this.id,
        this.userId,
        this.workerTypeId,
        this.workerType,
        this.firstName,
        this.lastName,
        this.key,
        this.efficiencyCalculation});

  ShiftWorker.fromJson(Map<String, dynamic> json) {


    id = json['id'];
    userId = json['userId'];
    workerTypeId = json['workerTypeId'];
    workerType = json['workerType'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    key = json['key'];
    efficiencyCalculation = json['efficiencyCalculation'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['workerTypeId'] = workerTypeId;
    data['workerType'] = workerType;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['key'] = key;
    data['efficiencyCalculation'] = efficiencyCalculation;
    return data;
  }
}

class AddTempResponse {
  int? code;
  String? status;
  String? message;
  ShiftWorker? data;

  AddTempResponse({this.code, this.status, this.message, this.data});

  AddTempResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ShiftWorker.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


class AddWorkersResponse {
  int? code;
  String? status;
  String? message;
  AddWorkerData? data;

  AddWorkersResponse({this.code, this.status, this.message});

  AddWorkersResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new AddWorkerData.fromJson(json['data']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}


class AddWorkerData {
  int? executeShiftId;
  int? shiftId;
  int? processId;

  AddWorkerData({this.executeShiftId, this.shiftId, this.processId});

  AddWorkerData.fromJson(Map<String, dynamic> json) {
    executeShiftId = json['execute_shift_id'];
    shiftId = json['shift_id'];
    processId = json['process_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['execute_shift_id'] = this.executeShiftId;
    data['shift_id'] = this.shiftId;
    data['process_id'] = this.processId;
    return data;
  }

}