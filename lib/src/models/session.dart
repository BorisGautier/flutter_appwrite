class Session {
  String? id;
  String? userId;
  int? expire;
  String? provider;
  String? providerUid;
  String? providerToken;
  String? ip;
  String? osCode;
  String? osName;
  String? osVersion;
  String? clientType;
  String? clientCode;
  String? clientName;
  String? clientVersion;
  String? clientEngine;
  String? clientEngineVersion;
  String? deviceName;
  String? deviceBrand;
  String? deviceModel;
  String? countryCode;
  String? countryName;
  bool? current;

  Session(
      {this.id,
      this.userId,
      this.expire,
      this.provider,
      this.providerUid,
      this.providerToken,
      this.ip,
      this.osCode,
      this.osName,
      this.osVersion,
      this.clientType,
      this.clientCode,
      this.clientName,
      this.clientVersion,
      this.clientEngine,
      this.clientEngineVersion,
      this.deviceName,
      this.deviceBrand,
      this.deviceModel,
      this.countryCode,
      this.countryName,
      this.current});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['userId'];
    expire = json['expire'];
    provider = json['provider'];
    providerUid = json['providerUid'];
    providerToken = json['providerToken'];
    ip = json['ip'];
    osCode = json['osCode'];
    osName = json['osName'];
    osVersion = json['osVersion'];
    clientType = json['clientType'];
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    clientVersion = json['clientVersion'];
    clientEngine = json['clientEngine'];
    clientEngineVersion = json['clientEngineVersion'];
    deviceName = json['deviceName'];
    deviceBrand = json['deviceBrand'];
    deviceModel = json['deviceModel'];
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['userId'] = this.userId;
    data['expire'] = this.expire;
    data['provider'] = this.provider;
    data['providerUid'] = this.providerUid;
    data['providerToken'] = this.providerToken;
    data['ip'] = this.ip;
    data['osCode'] = this.osCode;
    data['osName'] = this.osName;
    data['osVersion'] = this.osVersion;
    data['clientType'] = this.clientType;
    data['clientCode'] = this.clientCode;
    data['clientName'] = this.clientName;
    data['clientVersion'] = this.clientVersion;
    data['clientEngine'] = this.clientEngine;
    data['clientEngineVersion'] = this.clientEngineVersion;
    data['deviceName'] = this.deviceName;
    data['deviceBrand'] = this.deviceBrand;
    data['deviceModel'] = this.deviceModel;
    data['countryCode'] = this.countryCode;
    data['countryName'] = this.countryName;
    data['current'] = this.current;
    return data;
  }
}
