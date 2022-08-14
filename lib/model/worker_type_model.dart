class WorkerTypeResponse {
  int? code;
  String? status;
  String? message;
  List<WorkerType>? data;

  WorkerTypeResponse({this.code, this.status, this.message, this.data});

  WorkerTypeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WorkerType>[];
      json['data'].forEach((v) {
        data!.add( WorkerType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkerType {
  int? id;
  String? name;

  WorkerType({this.id, this.name});

  WorkerType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
