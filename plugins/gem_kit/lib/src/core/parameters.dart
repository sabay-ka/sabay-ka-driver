// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Types of values.
///
/// {@category Core}
enum ValueType {
  /// Invalid type.
  invalid,

  /// Bool value.
  bool,

  /// 64 bit int value.
  int,

  /// Double value
  real,

  /// String value
  string,

  /// List value
  list,
}

/// @nodoc
///
/// {@category Core}
extension ValueTypeExtension on ValueType {
  int get id {
    switch (this) {
      case ValueType.invalid:
        return 0;
      case ValueType.bool:
        return 1;
      case ValueType.int:
        return 2;
      case ValueType.real:
        return 3;
      case ValueType.string:
        return 4;
      case ValueType.list:
        return 5;
    }
  }

  static ValueType fromId(int id) {
    switch (id) {
      case 0:
        return ValueType.invalid;
      case 1:
        return ValueType.bool;
      case 2:
        return ValueType.int;
      case 3:
        return ValueType.real;
      case 4:
        return ValueType.string;
      case 5:
        return ValueType.list;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// {@category Core}
/// A parameter is a tuple ( key, value, name ).
///
/// [key] is the string parameter identifier
///
/// [value] is the parameter variant value.
///
/// [name] is the string parameter name. When parameters are returned from SDK the name is translated in the SDK language
class GemParameter {
  ValueType? type;
  dynamic value;
  String? name;
  String? key;

  /// Construct a parameter object with key & value & name ( optional )
  /// **Parameters**
  /// * **IN** *type*	Parameter type
  /// * **IN** *key*	Parameter key
  /// * **IN** *value*	Parameter value
  /// * **IN** *name*	Parameter name
  GemParameter({
    this.type,
    this.value,
    this.name,
    this.key,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (type != null) {
      json['type'] = type;
    }
    if (value != null) {
      json['value'] = value;
    }
    if (name != null) {
      json['name'] = name;
    }
    if (key != null) {
      json['key'] = key;
    }
    return json;
  }

  factory GemParameter.fromJson(Map<String, dynamic> json) {
    return GemParameter(
      type: ValueTypeExtension.fromId(json['type']),
      value: json['value'],
      name: json['name'],
      key: json['key'],
    );
  }

  @override
  bool operator ==(covariant GemParameter other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.value == value &&
        other.name == name &&
        other.key == key;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        type.hashCode ^
        value.hashCode ^
        name.hashCode ^
        key.hashCode;
  }
}

/// Searchable parameters list.
///
/// {@category Core}
class ParameterList extends GemList<GemParameter> {
  ParameterList(dynamic id, int mapId)
      : super(id, mapId, "ParameterList",
            (data, mapId) => GemParameter.fromJson(data)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  ParameterList.init(dynamic id, int mapId)
      : super(id, mapId, "ParameterList",
            (data, mapId) => GemParameter.fromJson(data)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  static ParameterList create() {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "ParameterList"}));
    final decodedVal = jsonDecode(resultString!);
    return ParameterList.init(decodedVal['result'], 0);
  }
}

/// Searchable parameters list.
///
/// Container for different types of values.
///
/// {@category Core}
class SearchableParameterList extends GemList<GemParameter> {
  SearchableParameterList(dynamic id, int mapId)
      : super(id, mapId, "SearchableParameterList",
            (data, mapId) => GemParameter.fromJson(data)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  SearchableParameterList.init(dynamic id, int mapId)
      : super(id, mapId, "SearchableParameterList",
            (data, mapId) => GemParameter.fromJson(data)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Search for first occurrence of a parameter identifier and get value.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	Parameter key as string
  ///
  /// **Returns**
  ///
  /// * The name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String find(String key) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': pointerId,
        'class': "SearchableParameterList",
        'method': "find",
        'args': key
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Search for all occurrences of a parameter identifier in a list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	Parameter key as string
  ///
  /// **Returns**
  ///
  /// * The list of paramteres
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  ParameterList findAll(String key) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': pointerId,
        'class': "SearchableParameterList",
        'method': "findAll",
        'args': key
      }));
      final decodedVal = jsonDecode(resultString!);
      return ParameterList.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Search for first occurrence of a parameter identifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *key*	Parameter key as string
  ///
  /// **Returns**
  ///
  /// * [GemParameter] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemParameter findParameter(String key) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': pointerId,
        'class': "SearchableParameterList",
        'method': "findParameter",
        'args': key
      }));
      final decodedVal = jsonDecode(resultString!);
      return GemParameter.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  static SearchableParameterList create(int mapId) {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "SearchableParameterList"}));
    final decodedVal = jsonDecode(resultString!);
    return SearchableParameterList.init(decodedVal['result'], mapId);
  }

  @override
  void dispose() => GemKitPlatform.instance.callDeleteObject(
      jsonEncode({'class': "SearchableParameterList", 'id': pointerId}));
}
