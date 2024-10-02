class Request {
  Request({
    required this.id,
    required this.created,
    required this.updated,
    required this.collectionId,
    required this.collectionName,
    required this.avatar,
    required this.email,
    required this.emailVisibility,
    required this.username,
    required this.verified,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.token,
  });

  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final String? collectionId;
  final String? collectionName;
  final String? avatar;
  final String? email;
  final bool? emailVisibility;
  final String? username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool? verified;
  String? token;

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json["id"],
      created: DateTime.tryParse(json["created"] ?? ""),
      updated: DateTime.tryParse(json["updated"] ?? ""),
      collectionId: json["collectionId"],
      collectionName: json["collectionName"],
      avatar: json["avatar"],
      email: json["email"],
      emailVisibility: json["emailVisibility"],
      username: json["username"],
      verified: json["verified"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "collectionId": collectionId,
        "collectionName": collectionName,
        "avatar": avatar,
        "email": email,
        "emailVisibility": emailVisibility,
        "username": username,
        "verified": verified,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "token": token,
      };
}
