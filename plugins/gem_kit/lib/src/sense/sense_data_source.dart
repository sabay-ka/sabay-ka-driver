// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:convert';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import '../../sense.dart';

/// Camera configuration structure
///
/// {@category Sensor Data Source}
class CameraConfiguration {
  /// Horizontal Field Of View in radians
  double? horizontalFOV;

  /// Vertical Field Of View in radians
  double? verticalFOV;

  /// Frame width in pixels
  int? frameWidth;

  /// Frame height in pixels
  int? frameHeight;

  /// The pixel format (encoding type)
  dynamic pixelFormat;

  /// The framerate value
  double? framerate;

  /// The horizontal focal length in pixels
  double? focalLengthHorizontal;

  /// The vertical focal length in pixels
  double? focalLengthVertical;

  /// The minimum possible focal length in millimeters
  double? focalLengthMinimum;

  /// The physical sensor width in millimeters
  double? physicalSensorWidth;

  /// The physical sensor height in millimeters
  double? physicalSensorHeight;

  /// The exposure in nanoseconds
  double? exposure;

  /// The minimum possible exposure in nanoseconds
  double? minExposure;

  /// The maximum possible exposure in nanoseconds
  double? maxExposure;

  /// The exposure target offset in EV units
  double? exposureTargetOffset;

  /// The actual ISO value in ISO arithmetic units
  double? isoValue;

  /// The minimum possible ISO value in ISO arithmetic units
  double? minIso;

  /// The maximum possible ISO value in ISO arithmetic units
  double? maxIso;

  CameraConfiguration({
    this.horizontalFOV,
    this.verticalFOV,
    this.frameWidth,
    this.frameHeight,
    this.pixelFormat,
    this.framerate,
    this.focalLengthHorizontal,
    this.focalLengthVertical,
    this.focalLengthMinimum,
    this.physicalSensorWidth,
    this.physicalSensorHeight,
    this.exposure,
    this.minExposure,
    this.maxExposure,
    this.exposureTargetOffset,
    this.isoValue,
    this.minIso,
    this.maxIso,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (horizontalFOV != null) {
      json['horizontalFOV'] = horizontalFOV;
    }
    if (verticalFOV != null) {
      json['verticalFOV'] = verticalFOV;
    }
    if (frameWidth != null) {
      json['frameWidth'] = frameWidth;
    }
    if (frameHeight != null) {
      json['frameHeight'] = frameHeight;
    }
    if (pixelFormat != null) {
      json['pixelFormat'] = pixelFormat;
    }
    if (framerate != null) {
      json['framerate'] = framerate;
    }
    if (focalLengthHorizontal != null) {
      json['focalLengthHorizontal'] = focalLengthHorizontal;
    }
    if (focalLengthVertical != null) {
      json['focalLengthVertical'] = focalLengthVertical;
    }
    if (focalLengthMinimum != null) {
      json['focalLengthMinimum'] = focalLengthMinimum;
    }
    if (physicalSensorWidth != null) {
      json['physicalSensorWidth'] = physicalSensorWidth;
    }
    if (physicalSensorHeight != null) {
      json['physicalSensorHeight'] = physicalSensorHeight;
    }
    if (exposure != null) {
      json['exposure'] = exposure;
    }
    if (minExposure != null) {
      json['minExposure'] = minExposure;
    }
    if (maxExposure != null) {
      json['maxExposure'] = maxExposure;
    }
    if (exposureTargetOffset != null) {
      json['exposureTargetOffset'] = exposureTargetOffset;
    }
    if (isoValue != null) {
      json['isoValue'] = isoValue;
    }
    if (minIso != null) {
      json['minIso'] = minIso;
    }
    if (maxIso != null) {
      json['maxIso'] = maxIso;
    }
    return json;
  }

  factory CameraConfiguration.fromJson(Map<String, dynamic> json) {
    return CameraConfiguration(
      horizontalFOV: json['horizontalFOV'],
      verticalFOV: json['verticalFOV'],
      frameWidth: json['frameWidth'],
      frameHeight: json['frameHeight'],
      pixelFormat: json['pixelFormat'],
      framerate: json['framerate'],
      focalLengthHorizontal: json['focalLengthHorizontal'],
      focalLengthVertical: json['focalLengthVertical'],
      focalLengthMinimum: json['focalLengthMinimum'],
      physicalSensorWidth: json['physicalSensorWidth'],
      physicalSensorHeight: json['physicalSensorHeight'],
      exposure: json['exposure'],
      minExposure: json['minExposure'],
      maxExposure: json['maxExposure'],
      exposureTargetOffset: json['exposureTargetOffset'],
      isoValue: json['isoValue'],
      minIso: json['minIso'],
      maxIso: json['maxIso'],
    );
  }
}

/// External acceleration data
///
/// {@category Sensor Data Source}
class ExternalAccelerationData {
  /// Timestamp in milliseconds
  final int timestamp;

  /// Acceleration in the x axis
  final double x;

  /// Acceleration in the y axis
  final double y;

  /// Acceleration in the z axis
  final double z;

  /// Unit of measurement
  final String unit;

  ExternalAccelerationData({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
    required this.unit,
  });

  factory ExternalAccelerationData.fromJson(Map<String, dynamic> json) {
    return ExternalAccelerationData(
      timestamp: json['timestamp'],
      x: json['x'],
      y: json['y'],
      z: json['z'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'x': x,
      'y': y,
      'z': z,
      'unit': unit,
    };
  }

  @override
  bool operator ==(covariant ExternalAccelerationData other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return timestamp == other.timestamp &&
        x == other.x &&
        y == other.y &&
        z == other.z &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    return Object.hash(timestamp, x, y, z, unit);
  }
}

/// External position data
///
/// {@category Sensor Data Source}
class ExternalPositionData {
  /// Timestamp in milliseconds
  final int timestamp;

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  /// Altitude (m)
  final double altitude;

  /// Heading (degrees east of north)
  final double heading;

  /// Speed (m/s)
  final double speed;

  ExternalPositionData({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.heading,
    required this.speed,
  });

  factory ExternalPositionData.fromJson(Map<String, dynamic> json) {
    return ExternalPositionData(
      timestamp: json['timestamp'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      heading: json['heading'],
      speed: json['speed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
    };
  }

  @override
  bool operator ==(covariant ExternalPositionData other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return timestamp == other.timestamp &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        altitude == other.altitude &&
        heading == other.heading &&
        speed == other.speed;
  }

  @override
  int get hashCode {
    return Object.hash(
      timestamp,
      latitude,
      longitude,
      altitude,
      heading,
      speed,
    );
  }
}

/// SensorDataSource
///
/// Through this interface data can be obtained from sensors, log files or any other means
///
/// {@category Sensor Data Source}
class DataSource {
  late int _pointerId;

  DataSource(List<DataType> dataTypes) {
    List<int> intList = dataTypes.map((dataType) => dataType.id).toList();
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({
      'class': "DataSourceContainer",
      'args': {'availableDataType': intList}
    }));
    final result = jsonDecode(resultString!);
    _pointerId = result['result'];
  }

  int get pointerId => _pointerId;

  /// Start the source
  ///
  /// **Returns**
  ///
  /// * [GemError] error code
  GemError start() {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "DataSourceContainer",
          'method': "start",
          'args': {}
        }));
    final decodedVal = jsonDecode(resultString!);
    return GemErrorExtension.fromCode(decodedVal['result']);
  }

  /// Stop the source
  ///
  /// **Returns**
  ///
  /// * [GemError] error code
  GemError stop() {
    final resultString = GemKitPlatform.instance.callObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "DataSourceContainer",
          'method': "stop",
          'args': {}
        }));
    final decodedVal = jsonDecode(resultString!);
    return GemErrorExtension.fromCode(decodedVal['result']);
  }

  /// Push the data
  ///
  /// **Parameters**
  ///
  /// * **IN** *accelerationData* The external acceleration data
  /// * **IN** *positionData* The external position data
  ///
  /// **Returns**
  ///
  /// * false if the push data type is not available
  /// * true if the push data type is available
  bool pushData(
      {ExternalAccelerationData? accelerationData,
      ExternalPositionData? positionData}) {
    final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "DataSourceContainer",
          'method': "pushData",
          'args': {
            if (accelerationData != null) 'accelerationData': accelerationData,
            if (positionData != null) 'positionData': positionData
          }
        }));
    final decodedVal = jsonDecode(resultString!);
    return decodedVal['result'];
  }
}
