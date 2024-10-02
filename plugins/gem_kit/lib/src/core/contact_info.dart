// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Contact info field type
///
/// {@category Places}
enum ContactInfoFieldType {
  /// Phone number
  phone,

  /// Email address
  email,

  /// URL
  url,

  /// Booking URL
  bookingUrl,

  /// Opening hours
  openingHours,

  /// Last field
  last,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Places}
extension ContactInfoFieldTypeExtension on ContactInfoFieldType {
  int get id {
    switch (this) {
      case ContactInfoFieldType.phone:
        return 0;
      case ContactInfoFieldType.email:
        return 1;
      case ContactInfoFieldType.url:
        return 2;
      case ContactInfoFieldType.bookingUrl:
        return 3;
      case ContactInfoFieldType.openingHours:
        return 4;
      case ContactInfoFieldType.last:
        return 5;
    }
  }

  static ContactInfoFieldType fromId(int id) {
    switch (id) {
      case 0:
        return ContactInfoFieldType.phone;
      case 1:
        return ContactInfoFieldType.email;
      case 2:
        return ContactInfoFieldType.url;
      case 3:
        return ContactInfoFieldType.bookingUrl;
      case 4:
        return ContactInfoFieldType.openingHours;
      case 5:
        return ContactInfoFieldType.last;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Contact info class
///
/// {@category Places}
class ContactInfo {
  final dynamic _pointerId;
  final int _mapId;

  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  factory ContactInfo() {
    return ContactInfo._create();
  }

  ContactInfo.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Add a new field
  ///
  /// **Parameters**
  ///
  /// * **IN** *type* Field's type
  /// * **IN** *value* Field's value
  /// * **IN** *name* Field's name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void addField(
      {required ContactInfoFieldType type,
      required String value,
      required String name}) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContactInfo",
            'method': "addField",
            'args': {'type': type.id, 'value': value, 'name': name}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the field count.
  ///
  /// **Returns**
  ///
  /// * The field count
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get fieldsCount {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContactInfo",
            'method': "getFieldsCount",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the field name/short description.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Returns**
  ///
  /// * The field name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String? getFieldName(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContactInfo",
            'method': "getFieldName",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      final name = decodedVal['result'] as String;
      return name.isNotEmpty ? name : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the field value.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Returns**
  ///
  /// * The field value
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String? getFieldValue(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContactInfo",
            'method': "getFieldValue",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      final value = decodedVal['result'] as String;
      return value.isNotEmpty ? value : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the field type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  /// **Returns**
  ///
  /// * The field type
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  ContactInfoFieldType? getFieldType(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContactInfo",
            'method': "getFieldType",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      try{
      return ContactInfoFieldTypeExtension.fromId(decodedVal['result']);
      } catch (e) {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sets field type, value and name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  /// * **IN** *type* Field's type
  /// * **IN** *value* Field's value
  /// * **IN** *name* Field's name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setField(
      {required int index,
      required ContactInfoFieldType type,
      required String value,
      required String name}) {
    try {
      if (index < fieldsCount) {
        GemKitPlatform.instance.safecallObjectMethodffi(
            this,
            jsonEncode({
              'id': _pointerId,
              'class': "ContactInfo",
              'method': "setField",
              'args': {
                'index': index,
                'type': type.id,
                'value': value,
                'name': name
              }
            }));
      } else {
        addField(type: type, value: value, name: name);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Removes a field specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Field index
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void removeField(int index) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ContactInfo",
            'method': "removeField",
            'args': index
          }));
    } catch (e) {
      rethrow;
    }
  }

  static ContactInfo _create() {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "ContactInfo"}));
    final decodedVal = jsonDecode(resultString!);
    return ContactInfo.init(decodedVal['result'], 0);
  }
}
