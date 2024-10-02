// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:flutter/foundation.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Address field enumeration
///
/// {@category Places}
enum AddressField {
  /// Address field denoting address extension, e.g. flat (apt, unit) number.
  extension,

  /// Address field denoting a building floor.
  buildingFloor,

  /// Address field denoting a building name.
  buildingName,

  /// Address field denoting a building room.
  buildingRoom,

  /// Address field denoting a building zone.
  buildingZone,

  /// Address field denoting a street/road name.
  streetName,

  /// Address field denoting a street number.
  streetNumber,

  /// Address field denoting zip or postal code.
  postalCode,

  /// Address field denoting a settlement.
  settlement,

  /// Address field denoting town or city name.
  city,

  /// Address field denoting a county, which is an intermediate entity between a state and a city.
  county,

  /// Address field denoting state or province.
  state,

  /// Abbreviation for state.
  stateCode,

  /// Address field denoting country.
  country,

  /// Address field denoting country as a three-letter ISO 3166-1 alpha-3 code.
  countryCode,

  /// Address field denoting a municipal district.
  district,

  /// Address field denoting a street in a crossing.
  crossing1,

  /// Address field denoting a street in a crossing.
  crossing2,

  /// Address field denoting the road segment.
  segmentName,

  /// Last item of this enumeration
  addrLast,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Places}
extension AddressFieldExtension on AddressField {
  int get id {
    switch (this) {
      case AddressField.extension:
        return 0;
      case AddressField.buildingFloor:
        return 1;
      case AddressField.buildingName:
        return 2;
      case AddressField.buildingRoom:
        return 3;
      case AddressField.buildingZone:
        return 4;
      case AddressField.streetName:
        return 5;
      case AddressField.streetNumber:
        return 6;
      case AddressField.postalCode:
        return 7;
      case AddressField.settlement:
        return 8;
      case AddressField.city:
        return 9;
      case AddressField.county:
        return 10;
      case AddressField.state:
        return 11;
      case AddressField.stateCode:
        return 12;
      case AddressField.country:
        return 13;
      case AddressField.countryCode:
        return 14;
      case AddressField.district:
        return 15;
      case AddressField.crossing1:
        return 16;
      case AddressField.crossing2:
        return 17;
      case AddressField.segmentName:
        return 18;
      case AddressField.addrLast:
        return 19;
    }
  }

  static AddressField fromId(int id) {
    switch (id) {
      case 0:
        return AddressField.extension;
      case 1:
        return AddressField.buildingFloor;
      case 2:
        return AddressField.buildingName;
      case 3:
        return AddressField.buildingRoom;
      case 4:
        return AddressField.buildingZone;
      case 5:
        return AddressField.streetName;
      case 6:
        return AddressField.streetNumber;
      case 7:
        return AddressField.postalCode;
      case 8:
        return AddressField.settlement;
      case 9:
        return AddressField.city;
      case 10:
        return AddressField.county;
      case 11:
        return AddressField.state;
      case 12:
        return AddressField.stateCode;
      case 13:
        return AddressField.country;
      case 14:
        return AddressField.countryCode;
      case 15:
        return AddressField.district;
      case 16:
        return AddressField.crossing1;
      case 17:
        return AddressField.crossing2;
      case 18:
        return AddressField.segmentName;
      case 19:
        return AddressField.addrLast;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Address info class
///
/// {@category Places}
class AddressInfo {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  factory AddressInfo() {
    return AddressInfo.create();
  }

  AddressInfo.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Set address field name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *excludeFields* Fields to be excluded from result. If not specified nothing is excluded.
  /// * **IN** *includeFields* Fields to be included from result. If not specified all are included.
  ///
  /// **Returns**
  ///
  /// * Formatted string
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String format({
    dynamic excludeFields,
    dynamic includeFields,
  }) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "AddressInfo",
            'method': "format",
            'args': {
              if (excludeFields != null) 'excludeFields': excludeFields,
              if (includeFields != null) 'includeFields': includeFields
            }
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get address field name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *field* Address field requested.
  ///
  /// **Returns**
  ///
  /// * Field name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String getField(AddressField field) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "AddressInfo",
            'method': "getField",
            'args': field.id
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Set address field name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *str* New value of the address field.
  /// * **IN** *field* Address field requested.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setField(String str, AddressField field) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "AddressInfo",
            'method': "setField",
            'args': {'str': str, 'field': field.id}
          }));
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool operator ==(covariant AddressInfo other) {
    if (identical(this, other)) return true;

    Map<AddressField, String> thisMap = _getAsMap();
    Map<AddressField, String> otherMap = other._getAsMap();

    return mapEquals(thisMap, otherMap);
  }

  @override
  int get hashCode {
    var hash = 0;
    for (final entry in _getAsMap().entries) {
      final key = entry.key;
      final value = entry.value;
      hash = hash ^ value.hashCode ^ key.hashCode;
    }

    return hash;
  }

  Map<AddressField, String> _getAsMap() {
    Map<AddressField, String> thisMap = {};

    for (final field in AddressField.values) {
      final thisFieldValue = getField(field);
      thisMap[field] = thisFieldValue;
    }

    return thisMap;
  }

  static AddressInfo create() {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "AddressInfo"}));
    final decodedVal = jsonDecode(resultString!);
    final retVal = AddressInfo.init(decodedVal['result'], 0);
    return retVal;
  }
}
