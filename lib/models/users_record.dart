// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i3;
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart' as _i2;

import 'auth_record.dart' as _i1;
import 'empty_values.dart' as _i4;


enum UsersRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  username,
  email,
  emailVisibility,
  verified,

  /// THIS FIELD IS ONLY FOR CREATING AN AUTH TYPE RECORD
  password,

  /// THIS FIELD IS ONLY FOR CREATING AN AUTH TYPE RECORD
  passwordConfirm,
  firstName,
  lastName,
  phoneNumber,
  avatar
}

@JsonSerializable()
final class UsersRecord extends _i1.AuthRecord {
  UsersRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required super.username,
    required super.email,
    required super.emailVisibility,
    required super.verified,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.avatar,
  });

  factory UsersRecord.fromJson(Map<String, dynamic> json) {
    return UsersRecord(
      id: json['id'], 
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
      collectionId: json['collectionId'] as String? ?? '',
      collectionName: json['collectionName'] as String? ?? '',
      username: json['username'] as String,
      email: json['email'] as String,
      emailVisibility: json['emailVisibility'] as bool,
      verified: json['verified'] as bool,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      avatar: json['avatar'] as String?
    );
  }

  factory UsersRecord.fromRecordModel(_i2.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      UsersRecordFieldsEnum.id.name: recordModel.id,
      UsersRecordFieldsEnum.created.name: recordModel.created,
      UsersRecordFieldsEnum.updated.name: recordModel.updated,
      UsersRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      UsersRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return UsersRecord.fromJson(extendedJsonMap);
  }

  final String firstName;

  final String lastName;

  final String phoneNumber;

  final String? avatar;

  static const $collectionId = '_pb_users_auth_';

  static const $collectionName = 'users';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'collectionId': collectionId,
      'collectionName': collectionName,
      'username': username,
      'email': email,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'avatar': avatar
    };
  } 

  UsersRecord copyWith({
    String? username,
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatar,
  }) {
    return UsersRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> takeDiff(UsersRecord other) {
    final thisInJsonMap = toJson();
    final otherInJsonMap = other.toJson();
    final Map<String, dynamic> result = {};
    final _i3.DeepCollectionEquality deepCollectionEquality =
        _i3.DeepCollectionEquality();
    for (final mapEntry in thisInJsonMap.entries) {
      final thisValue = mapEntry.value;
      final otherValue = otherInJsonMap[mapEntry.key];
      if (!deepCollectionEquality.equals(
        thisValue,
        otherValue,
      )) {
        result.addAll({mapEntry.key: otherValue});
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        firstName,
        lastName,
        phoneNumber,
        avatar,
      ];

  static Map<String, dynamic> forCreateRequest({
    required String username,
    required String email,
    required bool emailVisibility,
    required bool verified,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? avatar,
  }) {
    final jsonMap = UsersRecord(
      id: '',
      created: _i4.EmptyDateTime(),
      updated: _i4.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      username: username,
      email: email,
      emailVisibility: emailVisibility,
      verified: verified,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      avatar: avatar,
    ).toJson();
    final Map<String, dynamic> result = {};
    result.addAll({
      UsersRecordFieldsEnum.username.name:
          jsonMap[UsersRecordFieldsEnum.username.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.email.name:
          jsonMap[UsersRecordFieldsEnum.email.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.emailVisibility.name:
          jsonMap[UsersRecordFieldsEnum.emailVisibility.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.verified.name:
          jsonMap[UsersRecordFieldsEnum.verified.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.firstName.name:
          jsonMap[UsersRecordFieldsEnum.firstName.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.lastName.name:
          jsonMap[UsersRecordFieldsEnum.lastName.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.phoneNumber.name:
          jsonMap[UsersRecordFieldsEnum.phoneNumber.name]
    });
    if (avatar != null) {
      result.addAll({
        UsersRecordFieldsEnum.avatar.name:
            jsonMap[UsersRecordFieldsEnum.avatar.name]
      });
    }
    return result;
  }
}
