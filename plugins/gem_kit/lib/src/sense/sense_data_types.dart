// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// Known sense data types
///
/// {@category Sensor Data Source}
enum DataType {
  /// Acceleration
  acceleration,

  /// Activity
  activity,

  /// Altitude
  altitude,

  /// Battery
  battery,

  /// Camera
  camera,

  /// Compass
  compass,

  /// MagneticField
  magneticField,

  /// Orientation
  orientation,

  /// Position
  position,

  /// ImprovedPosition
  improvedPosition,

  /// RotationRate
  rotationRate,

  /// Temperature
  temperature,

  /// Notification
  notification,

  /// MountInformation
  mountInformation,

  /// Unknown
  unknown,

  /// Same as rotationRate
  gyroscope,
}

/// @nodoc
///
/// {@category Sensor Data Source}
extension DataTypeExtension on DataType {
  int get id {
    switch (this) {
      case DataType.acceleration:
        return 1;
      case DataType.activity:
        return 2;
      case DataType.altitude:
        return 4;
      case DataType.battery:
        return 8;
      case DataType.camera:
        return 16;
      case DataType.compass:
        return 32;
      case DataType.magneticField:
        return 64;
      case DataType.orientation:
        return 128;
      case DataType.position:
        return 256;
      case DataType.improvedPosition:
        return 512;
      case DataType.rotationRate:
        return 1024;
      case DataType.temperature:
        return 2048;
      case DataType.notification:
        return 4096;
      case DataType.mountInformation:
        return 8192;
      case DataType.unknown:
        return 16384;
      case DataType.gyroscope:
        return 1024;
    }
  }

  static DataType fromId(int id) {
    switch (id) {
      case 1:
        return DataType.acceleration;
      case 2:
        return DataType.activity;
      case 4:
        return DataType.altitude;
      case 8:
        return DataType.battery;
      case 16:
        return DataType.camera;
      case 32:
        return DataType.compass;
      case 64:
        return DataType.magneticField;
      case 128:
        return DataType.orientation;
      case 256:
        return DataType.position;
      case 512:
        return DataType.improvedPosition;
      case 1024:
        return DataType.rotationRate;
      case 2048:
        return DataType.temperature;
      case 4096:
        return DataType.notification;
      case 8192:
        return DataType.mountInformation;
      case 16384:
        return DataType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
