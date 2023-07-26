class FirebaseNotificationResponce {
  int? multicastId;
  int? success;
  int? failure;
  int? canonicalIds;
  List<Results>? results;

  FirebaseNotificationResponce(
      {this.multicastId,
      this.success,
      this.failure,
      this.canonicalIds,
      this.results});

  FirebaseNotificationResponce.fromJson(Map<String, dynamic> json) {
    if (json["multicast_id"] is int) multicastId = json["multicast_id"];
    if (json["success"] is int) success = json["success"];
    if (json["failure"] is int) failure = json["failure"];
    if (json["canonical_ids"] is int) canonicalIds = json["canonical_ids"];
    if (json["results"] is List)
      results = json["results"] == null
          ? null
          : (json["results"] as List).map((e) => Results.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["multicast_id"] = multicastId;
    data["success"] = success;
    data["failure"] = failure;
    data["canonical_ids"] = canonicalIds;
    if (results != null)
      data["results"] = results!.map((e) => e.toJson()).toList();
    return data;
  }
}

class Results {
  String? messageId;

  Results({this.messageId});

  Results.fromJson(Map<String, dynamic> json) {
    if (json["message_id"] is String) messageId = json["message_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message_id"] = messageId;
    return data;
  }
}
