// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/image_handler.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Enumerates known image file formats.
///
/// {@category Core}
enum ImageFileFormat {
  /// BMP image file format.s
  bmp,

  /// JPEG image file format.
  jpeg,

  /// GIF image file format.s
  gif,

  /// PNG image file format.
  png,

  /// TGA image file format.
  tga,

  /// WebP image file format
  pvrtc,

  /// Automatically detect image file format.
  autoDetect,
}

/// @nodoc
///
/// {@category Core}
extension ImageFileFormatExtension on ImageFileFormat {
  int get id {
    switch (this) {
      case ImageFileFormat.bmp:
        return 0;
      case ImageFileFormat.jpeg:
        return 1;
      case ImageFileFormat.gif:
        return 2;
      case ImageFileFormat.png:
        return 3;
      case ImageFileFormat.tga:
        return 4;
      case ImageFileFormat.pvrtc:
        return 5;
      case ImageFileFormat.autoDetect:
        return 6;
    }
  }

  static ImageFileFormat fromId(int id) {
    switch (id) {
      case 0:
        return ImageFileFormat.bmp;
      case 1:
        return ImageFileFormat.jpeg;
      case 2:
        return ImageFileFormat.gif;
      case 3:
        return ImageFileFormat.png;
      case 4:
        return ImageFileFormat.tga;
      case 5:
        return ImageFileFormat.pvrtc;
      case 6:
        return ImageFileFormat.autoDetect;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost image object.
///
/// {@category Core}
class SignpostImage {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  SignpostImage()
      : _pointerId = -1,
        _mapId = -1;
  SignpostImage.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  static Future<SignpostImage> create(int mapId) async {
    final resultString = await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>(
            'callObjectConstructor', jsonEncode({'class': "SignpostImage"}));
    final decodedVal = jsonDecode(resultString!);
    return SignpostImage.init(decodedVal['result'], mapId);
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor',
          jsonEncode({'class': "SignpostImage", 'id': _pointerId}));
}

/// Road info image object.
///
/// {@category Core}
class RoadInfoImage {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  RoadInfoImage()
      : _pointerId = -1,
        _mapId = -1;
  RoadInfoImage.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  static Future<RoadInfoImage> create(int mapId) async {
    final resultString = await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>(
            'callObjectConstructor', jsonEncode({'class': "RoadInfoImage"}));
    final decodedVal = jsonDecode(resultString!);
    return RoadInfoImage.init(decodedVal['result'], mapId);
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor',
          jsonEncode({'class': "RoadInfoImage", 'id': _pointerId}));
}

/// Lane image object.
///
/// {@category Core}
class LaneImage {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  LaneImage()
      : _pointerId = -1,
        _mapId = -1;

  LaneImage.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  static Future<LaneImage> create(int mapId) async {
    final resultString = await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>(
            'callObjectConstructor', jsonEncode({'class': "LaneImage"}));
    final decodedVal = jsonDecode(resultString!);
    return LaneImage.init(decodedVal['result'], mapId);
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor',
          jsonEncode({'class': "LaneImage", 'id': _pointerId}));
}

/// Abstract geometry image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class AbstractGeometryImageRenderSettings {
  /// Active turn arrow inner color. If not specified, the SDK default is used
  final Color activeInnerColor;

  /// Active turn arrow outer color. If not specified, the SDK default is used
  final Color activeOuterColor;

  /// Inactive turn arrow inner color. If not specified, the SDK default is used
  final Color inactiveInnerColor;

  /// Inactive turn arrow outer color. If not specified, the SDK default is used
  final Color inactiveOuterColor;

  /// Constructor with optional border size, border round corners and maximum rows
  ///
  /// **Parameters**
  ///
  /// * **IN** *activeInnerColor*	Active turn arrow inner color. If not specified, the SDK default is used
  /// * **IN** *activeOuterColor*	Active turn arrow outer color. If not specified, the SDK default is used
  /// * **IN** *inactiveInnerColor*	Inactive turn arrow inner color. If not specified, the SDK default is used
  /// * **IN** *inactiveOuterColor*	Inactive turn arrow outer color. If not specified, the SDK default is used
  const AbstractGeometryImageRenderSettings({
    Color? activeInnerColor,
    Color? activeOuterColor,
    Color? inactiveInnerColor,
    Color? inactiveOuterColor,
  })  : activeInnerColor =
            activeInnerColor ?? const Color.fromARGB(255, 255, 255, 255),
        activeOuterColor =
            activeOuterColor ?? const Color.fromARGB(255, 0, 0, 0),
        inactiveInnerColor =
            inactiveInnerColor ?? const Color.fromARGB(255, 128, 128, 128),
        inactiveOuterColor =
            inactiveOuterColor ?? const Color.fromARGB(255, 128, 128, 128);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['activeInnerColor'] = activeInnerColor.toRgba();
    json['activeOuterColor'] = activeOuterColor.toRgba();
    json['inactiveInnerColor'] = inactiveInnerColor.toRgba();
    json['inactiveOuterColor'] = inactiveOuterColor.toRgba();
    return json;
  }

  factory AbstractGeometryImageRenderSettings.fromJson(
      Map<String, dynamic> json) {
    return AbstractGeometryImageRenderSettings(
      activeInnerColor: json['activeInnerColor'],
      activeOuterColor: json['activeOuterColor'],
      inactiveInnerColor: json['inactiveInnerColor'],
      inactiveOuterColor: json['inactiveOuterColor'],
    );
  }

  @override
  bool operator ==(covariant AbstractGeometryImageRenderSettings other) {
    if (identical(this, other)) return true;

    return other.activeInnerColor == activeInnerColor &&
        other.activeOuterColor == activeOuterColor &&
        other.inactiveInnerColor == inactiveInnerColor &&
        other.inactiveOuterColor == inactiveOuterColor;
  }

  @override
  int get hashCode {
    return activeInnerColor.hashCode ^
        activeOuterColor.hashCode ^
        inactiveInnerColor.hashCode ^
        inactiveOuterColor.hashCode;
  }
}

/// Signpost image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class SignpostImageRenderSettings {
  /// Border size in pixels
  final int borderSize;

  /// Round corners border
  final bool borderRoundCorners;

  /// Maximum rows of details in the signpost
  final int maxRows;

  /// Small mode. The image is generated for small size usage
  final bool smallMode;

  /// Constructor with optional border size, border round corners and maximum rows
  ///
  /// **Parameters**
  ///
  /// * **IN** *borderSize*	Border size in pixels
  /// * **IN** *borderRoundCorners*	Round corners border
  /// * **IN** *maxRows* Maximum rows of details in the signpost
  /// * **IN** *smallMode* Small mode. The image is generated for small size usage
  const SignpostImageRenderSettings({
    this.borderSize = 10,
    this.borderRoundCorners = true,
    this.maxRows = 3,
    this.smallMode = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['borderSize'] = borderSize;

    json['borderRoundCorners'] = borderRoundCorners;

    json['maxRows'] = maxRows;

    json['smallMode'] = smallMode;

    return json;
  }

  factory SignpostImageRenderSettings.fromJson(Map<String, dynamic> json) {
    return SignpostImageRenderSettings(
      borderSize: json['borderSize'],
      borderRoundCorners: json['borderRoundCorners'],
      maxRows: json['maxRows'],
      smallMode: json['smallMode'],
    );
  }

  @override
  bool operator ==(covariant SignpostImageRenderSettings other) {
    if (identical(this, other)) return true;

    return other.borderSize == borderSize &&
        other.borderRoundCorners == borderRoundCorners &&
        other.maxRows == maxRows &&
        other.smallMode == smallMode;
  }

  @override
  int get hashCode {
    return borderSize.hashCode ^
        borderRoundCorners.hashCode ^
        maxRows.hashCode ^
        smallMode.hashCode;
  }
}

/// Road info image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class RoadInfoImageRenderSettings {
  /// Background color hint
  final Color? backgroundColor;

  /// Constructor with optional background color
  ///
  /// **Parameters**
  ///
  /// * **IN** *backgroundColor* Background color hint
  RoadInfoImageRenderSettings({
    this.backgroundColor,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (backgroundColor != null) {
      json['backgroundColor'] = backgroundColor!.toRgba();
    }
    return json;
  }

  factory RoadInfoImageRenderSettings.fromJson(Map<String, dynamic> json) {
    return RoadInfoImageRenderSettings(
      backgroundColor: json['backgroundColor'],
    );
  }

  @override
  bool operator ==(covariant RoadInfoImageRenderSettings other) {
    if (identical(this, other)) return true;

    return other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode;
  }
}

/// Lane image render settings.
///
/// Initialized with default optimal values
///
/// {@category Core}
class LaneImageRenderSettings {
  /// Background color
  final Color backgroundColor;

  /// Active lanes color
  final Color activeColor;

  /// Inactive lanes color
  final Color inactiveColor;

  /// Constuctor
  ///
  /// **Parameters**
  ///
  /// * **IN** *backgroundColor* Background color
  /// * **IN** *activeColor* Active lanes color
  /// * **IN** *inactiveColor* Inactive lanes color
  const LaneImageRenderSettings({
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
  })  : backgroundColor = backgroundColor ?? const Color.fromARGB(150, 0, 0, 0),
        activeColor = activeColor ?? const Color.fromRGBO(255, 0, 0, 0),
        inactiveColor =
            inactiveColor ?? const Color.fromARGB(255, 175, 175, 175);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['backgroundColor'] = backgroundColor.toRgba();
    json['activeColor'] = activeColor.toRgba();
    json['inactiveColor'] = inactiveColor.toRgba();
    return json;
  }

  factory LaneImageRenderSettings.fromJson(Map<String, dynamic> json) {
    return LaneImageRenderSettings(
      backgroundColor: json['backgroundColor'],
      activeColor: json['activeColor'],
      inactiveColor: json['inactiveColor'],
    );
  }

  @override
  bool operator ==(covariant LaneImageRenderSettings other) {
    if (identical(this, other)) return true;

    return other.backgroundColor == backgroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode ^
        activeColor.hashCode ^
        inactiveColor.hashCode;
  }
}

/// @nodoc
///
/// {@category Core}
class OffscreenBitmap {
  final int _pointerId;
  final int _width;
  final int _height;

  int get pointerId => _pointerId;

  OffscreenBitmap()
      : _pointerId = -1,
        _width = -1,
        _height = -1;

  OffscreenBitmap.init(int id, int width, int height)
      : _pointerId = id,
        _width = width,
        _height = height {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  static OffscreenBitmap create(int width, int height) {
    return OffscreenBitmap.init(
        GemKitPlatform.instance.callBitmapConstructor(width, height),
        width,
        height);
  }

  Uint8List get bitmapData {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
    return GemKitPlatform.instance
        .callGetBitmapBuffer(pointerId, _width, _height);
  }

  Future<ui.Image?> get image {
    final dataBuffer = bitmapData;
    return ImageHandler.decodeImageData(dataBuffer,
        width: _width, height: _height);
  }
}

/// @nodoc
///
/// {@category Core}
class GemImage {
  final Uint8List? image;
  final ImageFileFormat? format;
  final int? imageId;
  GemImage({this.image, this.format, this.imageId = -1});

  // Method to convert GemImage to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (image != null) {
      json['image'] = image!;
    }
    if (format != null) {
      json['format'] = format!.id;
    }
    if (imageId != null) {
      json['imageId'] = imageId;
    }
    return json;
  }

  static GemImage fromJson(Map<String, dynamic> json) {
    return GemImage(
        image: utf8.encode(json['image']),
        format: ImageFileFormatExtension.fromId(json['format']),
        imageId: json['imageId']);
  }

  @override
  bool operator ==(covariant GemImage other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.format == format &&
        other.imageId == imageId;
  }

  @override
  int get hashCode {
    return image.hashCode ^ format.hashCode ^ imageId.hashCode;
  }
}
