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

    if (json['worker'] != null) {
      worker = <ShiftWorker>[];
      var workersListTemp = json['worker'];

      var mp = workersListTemp[0];

      json['worker'].forEach((v) {
        worker!.add( ShiftWorker.fromJson(v));
      });
    }
    if (json['shift_worker'] != null) {
      shiftWorker = <ShiftWorker>[];
      json['shift_worker'].forEach((v) {
        shiftWorker!.add(ShiftWorker.fromJson(v));
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

  bool isSelected = false;


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
  WorkerTempObj? data;

  AddTempResponse({this.code, this.status, this.message, this.data});

  AddTempResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? WorkerTempObj.fromJson(json['data']) : null;
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

class WorkerTempObj {
  int? id;
  String? firstName;
  String? lastName;
  int? key;

  WorkerTempObj({this.id, this.firstName, this.lastName, this.key});

  WorkerTempObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['key'] = this.key;
    return data;
  }
}
