// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:ui';

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

/// Map coverage
///
/// {@category Maps & 3D Scene}
enum MapCoverage {
  /// Data covered by an offline map available on the device. No connection required.
  coverageOffline,

  /// Data covered by the online cache available on the device. No connection required.
  ///
  /// Data is volatile and may be erased after a cache cleanup operation
  coverageOnlineTile,

  /// Exist data coverage but is not available on the device. Server connection required.
  coverageOnlineNoData,

  /// There is no map coverage available on device and cannot determine if coverage is available on the server.
  coverageUnknown,
}

/// This class will not be documented
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MapCoverageExtension on MapCoverage {
  int get id {
    switch (this) {
      case MapCoverage.coverageOffline:
        return 0;
      case MapCoverage.coverageOnlineTile:
        return 1;
      case MapCoverage.coverageOnlineNoData:
        return 2;
      case MapCoverage.coverageUnknown:
        return 3;
    }
  }

  static MapCoverage fromId(int id) {
    switch (id) {
      case 0:
        return MapCoverage.coverageOffline;
      case 1:
        return MapCoverage.coverageOnlineTile;
      case 2:
        return MapCoverage.coverageOnlineNoData;
      case 3:
        return MapCoverage.coverageUnknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Map details class
///
/// {@category Maps & 3D Scene}
abstract class MapDetails {
  /// Get the ISO 3166-1 alpha-3 country code for the specified WGS.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates
  ///
  /// **Returns**
  ///
  /// * The country code as [String]
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryCode(Coordinates coords) {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getCountryCode", 'args': coords}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the country flag for the isoCode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countryCode* ISO 3166-1 alpha-3 country code
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Returns**
  ///
  /// * Country flag image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Uint8List getCountryFlag({required String countryCode, Size? size, ImageFileFormat? format}) {
    try {
      return GemKitPlatform.instance.callGetImage(
          0, "MapDetailsgetCountryFlag", size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1,
          arg: countryCode);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the map coverage for the country specified by ISO 3166-1 alpha-3 country code.
  ///
  /// This function checks the map coverage status using only the information available on the device. No server connection is performed. This check is performed fast
  ///
  /// **Parameters**
  ///
  /// * **IN** *code* ISO 3166-1 alpha-3 country code
  ///
  /// **Returns**
  ///
  /// * [MapCoverage.coverageOffline] - Entire country map is available on the device.
  /// * [MapCoverage.coverageOnlineNoData] - Country map is available but not all tiles are on the device.
  /// * [MapCoverage.coverageOnlineTile] -
  /// * [MapCoverage.coverageUnknown] - No map coverage available on device and cannot determine if there exists content on the server.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static MapCoverage getCountryMapCoverage(String code) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getCountryMapCoverage", 'args': code}));
      final decodedVal = jsonDecode(resultString!);
      return MapCoverageExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the country name for the specified coordinates (WGS).
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates
  ///
  /// **Returns**
  ///
  /// * Country name as string
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryName(Coordinates coords) {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getCountryName", 'args': coords}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the country name for the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The country index
  ///
  /// **Returns**
  ///
  /// * Country name as string
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static String getCountryNameByIndex(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getCountryNameByIndex", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the map coverage for the region specified by WGS84 coordinates.
  ///
  /// This function checks the map coverage status using only the information available on the device. No server connection is performed. This check is performed fast
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The list of coordinates
  ///
  /// **Returns**
  ///
  /// * [MapCoverage.coverageOffline] - Entire map is available on the device.
  /// * [MapCoverage.coverageOnlineNoData] - Map is available but not all tiles are on the device.
  /// * [MapCoverage.coverageOnlineTile] -
  /// * [MapCoverage.coverageUnknown] - No map coverage available on device and cannot determine if there exists content on the server.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static MapCoverage getMapCoverage(List<Coordinates> coords) {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getMapCoverage", 'args': coords}));
      final decodedVal = jsonDecode(resultString!);
      return MapCoverageExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the map version.
  ///
  /// **Returns**
  ///
  /// * The map version
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Version get mapVersion {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getMapVersion", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Version.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get latest online map version.
  ///
  /// **Returns**
  ///
  /// * Latest online map version
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Version get latestOnlineMapVersion {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "MapDetails", 'method': "getLatestOnlineMapVersion", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Version.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }
}
