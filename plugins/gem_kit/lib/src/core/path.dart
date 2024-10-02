// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:typed_data';
import 'dart:ui';

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Path collection class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.paths] getter to obtain an instance.
/// 
/// {@category Core}
class MapViewPathCollection {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  MapViewPathCollection._()
      : _pointerId = -1,
        _mapId = -1;

  MapViewPathCollection.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Add a path to the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The path to be added.
  /// * **IN** *colorBorder* The color of the path border. By default the one from the current map view style is used.
  /// * **IN** *colorInner* The color of the path inner. By default the one from the current map view style is used.
  /// * **IN** *szBorder* The size of the path border in mm. If < 0 the one from the current map view style is used.
  /// * **IN** *szInner* The size of the path inner in mm. If < 0 the one from the current map view style is used.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void add(
    Path path, {
    Color? colorBorder,
    Color? colorInner,
    double? szBorder,
    double? szInner,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "add",
            'args': {
              'path': path.pointerId,
              if (colorBorder != null) 'colorBorder': colorBorder.toRgba(),
              if (colorInner != null) 'colorInner': colorInner.toRgba(),
              if (szBorder != null) 'szBorder': szBorder,
              if (szInner != null) 'szInner': szInner
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all paths from the collection.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "clear",
            'args': {}
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the border color for the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The border color
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color getBorderColorAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "getBorderColorAt",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the border size for the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The border size
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double getBorderSizeAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "getBorderSizeAt",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the inner color for the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The inner color
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color getFillColorAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "getFillColorAt",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the inner size for the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The inner size
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double getInnerSizeAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "getInnerSizeAt",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  /// **Returns**
  ///
  /// * The path
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Path getPathAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "getPathAt",
            'args': index
          }));
      final decodedVal = jsonDecode(resultString!);
      return Path.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the path specified by name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The path name
  ///
  /// **Returns**
  ///
  /// * The path
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Path getPathByName(String name) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "getPathByName",
            'args': name
          }));
      final decodedVal = jsonDecode(resultString!);
      return Path.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the number of paths in this collection.
  ///
  /// **Returns**
  ///
  /// * The number of paths
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "MapViewPathCollection",
        'method': "size",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the path from the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *path* The path to be
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void remove(Path path) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "remove",
            'args': path.pointerId
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the path specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The path index
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void removeAt(int index) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewPathCollection",
            'method': "removeAt",
            'args': index
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  static Future<MapViewPathCollection> create(int mapId) async {
    final resultString = await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>('callObjectConstructor',
            jsonEncode({'class': "MapViewPathCollection"}));
    final decodedVal = jsonDecode(resultString!);
    return MapViewPathCollection.init(decodedVal['result'], mapId);
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor',
          jsonEncode({'class': "MapViewPathCollection", 'id': _pointerId}));
}

/// Path import supported formats.
///
/// {@category Core}
enum PathFileFormat {
  /// GPX
  gpx,

  /// KML
  kml,

  /// NMEA
  nmea,

  /// GeoJSON
  geoJson,

  /// Latitude, Longitude lines in txt file (debug purposes)
  latLonTxt,

  /// Longitude, Latitude lines in txt file (debug purposes)
  lonLatTxt,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
extension PathFileFormatExtension on PathFileFormat {
  int get id {
    switch (this) {
      case PathFileFormat.gpx:
        return 0;
      case PathFileFormat.kml:
        return 1;
      case PathFileFormat.nmea:
        return 2;
      case PathFileFormat.geoJson:
        return 3;
      case PathFileFormat.latLonTxt:
        return 4;
      case PathFileFormat.lonLatTxt:
        return 5;
    }
  }

  static PathFileFormat fromId(int id) {
    switch (id) {
      case 0:
        return PathFileFormat.gpx;
      case 1:
        return PathFileFormat.kml;
      case 2:
        return PathFileFormat.nmea;
      case 3:
        return PathFileFormat.geoJson;
      case 4:
        return PathFileFormat.latLonTxt;
      case 5:
        return PathFileFormat.lonLatTxt;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Path class
///
/// {@category Core}
class Path {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  Path._()
      : _pointerId = -1,
        _mapId = -1;

  Path.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Clone reverse order path. Does not change the original path.
  ///
  /// **Returns**
  ///
  /// * The reversed path
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Path cloneReverse() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "cloneReverse",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Path.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Clone path from the given coordinates.
  ///
  /// Set start = end to create a circuit track.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* The start coordiantes
  /// * **IN** *end* Field coordinates
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Path cloneStartEnd(Coordinates start, Coordinates end) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "cloneStartEnd",
            'args': {'first': start, 'second': end}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Path.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Export path coordinates in the requested data format.
  ///
  /// **Parameters**
  ///
  /// * **IN** *format* Data format, see [PathFileFormat].
  ///
  /// **Returns**
  ///
  /// * The data buffer with the path coordinates
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List exportAs(PathFileFormat pathFileFormat) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "exportAs",
            'args': pathFileFormat.id
          }));
      final decodedVal = jsonDecode(resultString!);
      return Uint8List.fromList(utf8.encode(decodedVal['result']));
    } catch (e) {
      rethrow;
    }
  }

  /// Get path rectangle.
  ///
  /// **Returns**
  ///
  /// * The path rectangle, [RectangleGeographicArea] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get area {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "getArea",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get read-only access to the internal coordinates list.
  ///
  /// **Returns**
  ///
  /// * The coordinates list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Coordinates> get coordinates {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "getCoordinates",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<Coordinates> retList = listJson
          .map((categoryJson) => Coordinates.fromJson(categoryJson))
          .toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get a coordinate along the path given by a fraction of the path length between 0.0 (departure point) and 1.0 (destination).
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The path coordinates list.
  /// * **IN** *percent* The size percent (fraction) in the range {0, 1}, e.g. 0.5 will return the coordinates of the point in the middle of the path.
  ///
  /// **Returns**
  ///
  /// * The coordinates at the given percent
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Coordinates getCoordinatesAtPercent(
      List<Coordinates> coords, double percent) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "Path",
            'method': "getCoordinatesAtPercent",
            'args': {'coords': coords, 'percent': percent}
          }));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get path name.
  ///
  /// **Returns**
  ///
  /// * The path name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "getName",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get read-only access to the internal waypoint list.
  ///
  /// **Returns**
  ///
  /// * The waypoint list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<int> get wayPoints {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "getWayPoints",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      final listJson = (decodedVal['result'] as List<dynamic>)
          .map((item) => item as int)
          .toList();
      return listJson;
    } catch (e) {
      rethrow;
    }
  }

  /// Set path name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The path name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set name(String name) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Path",
            'method': "setName",
            'args': name
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Create a path from a data buffer of a given format.
  ///
  /// **Parameters**
  /// * **IN** *data* The data buffer
  /// * **IN** *format* The data format
  static Path create({List<int>? data, int? format}) {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({
      'class': "Path",
      'args': {
        if (data != null) 'data': data,
        if (format != null) 'format': format
      }
    }));
    final decodedVal = jsonDecode(resultString!);
    return Path.init(decodedVal['result'], 0);
  }

  /// Create a new landmark list from a path.
  ///
  /// **Returns**
  ///
  /// * The landmark list
  List<Landmark> toLandmarkList() {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "Path",
          'method': "toLandmarkList",
          'args': {}
        }));
    final decodedVal = jsonDecode(resultString!);
    return LandmarkList.init(decodedVal['result'], 0).toList();
  }

  Future<void> dispose() async {
    await GemKitPlatform.instance.getChannel(mapId: mapId).invokeMethod<String>(
        'callObjectDestructor',
        jsonEncode({'class': "Path", 'id': _pointerId}));
  }
}
