class ThrowIfNoSuccess {
  int status;
  Result result;
  String message;
  int code;
  String path;
  String method;
  String timestamp;

  ThrowIfNoSuccess(
      {this.status,
        this.result,
        this.message,
        this.code,
        this.path,
        this.method,
        this.timestamp});

  ThrowIfNoSuccess.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    message = json['message'];
    code = json['code'];
    path = json['path'];
    method = json['method'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    data['path'] = this.path;
    data['method'] = this.method;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Result {
  Error error;

  Result({this.error});

  Result.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class Error {
  String response;
  int status;
  String message;

  Error({this.response, this.status, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}