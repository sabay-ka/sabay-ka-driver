// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// Structure describing the camera characteristics object.
///
/// {@category Sensor Data Source}
class CameraCharacteristics {
  /// The width of the captured image in pixels.
  int? resolutionWidth;

  /// The height of the captured image in pixels.
  int? resolutionHeight;

  /// The frame rate(fps) is the number of frames that camera can take per second.
  double? frameRate;

  /// The horizontal focal length in pixels.
  double? focalLengthHorizontal;

  /// The vertical focal length in pixels.
  double? focalLengthVertical;

  /// The fixed focal length in millimeter.
  double? focalLengthMinimum;

  /// The physical sensor width in millimeter.
  double? physicalSensorWidth;

  /// The physical sensor height in millimeter.
  double? physicalSensorHeight;

  /// The minimum exposure time in nanoseconds.
  double? minExposure;

  /// The maximum exposure time in nanoseconds.
  double? maxExposure;

  /// The minimum ISO value in ISO arithmetic units.
  double? minISO;

  /// The maximum ISO value in ISO arithmetic units.
  double? maxISO;

  CameraCharacteristics({
    this.resolutionWidth,
    this.resolutionHeight,
    this.frameRate,
    this.focalLengthHorizontal,
    this.focalLengthVertical,
    this.focalLengthMinimum,
    this.physicalSensorWidth,
    this.physicalSensorHeight,
    this.minExposure,
    this.maxExposure,
    this.minISO,
    this.maxISO,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (resolutionWidth != null) {
      json['resolutionWidth'] = resolutionWidth;
    }
    if (resolutionHeight != null) {
      json['resolutionHeight'] = resolutionHeight;
    }
    if (frameRate != null) {
      json['frameRate'] = frameRate;
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
    if (minExposure != null) {
      json['minExposure'] = minExposure;
    }
    if (maxExposure != null) {
      json['maxExposure'] = maxExposure;
    }
    if (minISO != null) {
      json['minISO'] = minISO;
    }
    if (maxISO != null) {
      json['maxISO'] = maxISO;
    }
    return json;
  }

  factory CameraCharacteristics.fromJson(Map<String, dynamic> json) {
    return CameraCharacteristics(
      resolutionWidth: json['resolutionWidth'],
      resolutionHeight: json['resolutionHeight'],
      frameRate: json['frameRate'],
      focalLengthHorizontal: json['focalLengthHorizontal'],
      focalLengthVertical: json['focalLengthVertical'],
      focalLengthMinimum: json['focalLengthMinimum'],
      physicalSensorWidth: json['physicalSensorWidth'],
      physicalSensorHeight: json['physicalSensorHeight'],
      minExposure: json['minExposure'],
      maxExposure: json['maxExposure'],
      minISO: json['minISO'],
      maxISO: json['maxISO'],
    );
  }
  @override
  bool operator ==(covariant CameraCharacteristics other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return resolutionWidth == other.resolutionWidth &&
        resolutionHeight == other.resolutionHeight &&
        frameRate == other.frameRate &&
        focalLengthHorizontal == other.focalLengthHorizontal &&
        focalLengthVertical == other.focalLengthVertical &&
        focalLengthMinimum == other.focalLengthMinimum &&
        physicalSensorWidth == other.physicalSensorWidth &&
        physicalSensorHeight == other.physicalSensorHeight &&
        minExposure == other.minExposure &&
        maxExposure == other.maxExposure &&
        minISO == other.minISO &&
        maxISO == other.maxISO;
  }

  @override
  int get hashCode {
    return Object.hash(
      resolutionWidth,
      resolutionHeight,
      frameRate,
      focalLengthHorizontal,
      focalLengthVertical,
      focalLengthMinimum,
      physicalSensorWidth,
      physicalSensorHeight,
      minExposure,
      maxExposure,
      minISO,
      maxISO,
    );
  }
}
