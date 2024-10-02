// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:flutter/material.dart';
import 'package:gem_kit/src/core/extensions.dart';

/// Line type for linear features.
///
/// {@category Maps & 3D Scene}
enum LineType {
  /// Default line style.
  styleDefault,

  /// Solid line style.
  solid,

  /// Dashed line style.
  dashed,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension LineTypeExtension on LineType {
  int get id {
    switch (this) {
      case LineType.styleDefault:
        return 0;
      case LineType.solid:
        return 1;
      case LineType.dashed:
        return 2;
    }
  }

  static LineType fromId(int id) {
    switch (id) {
      case 0:
        return LineType.styleDefault;
      case 1:
        return LineType.solid;
      case 2:
        return LineType.dashed;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Landmarks highlight display options
///
/// {@category Maps & 3D Scene}
enum HighlightOptions {
  /// Shows landmark icon & text
  showLandmark,

  /// Shows landmark impact area contour ( when available )
  ///
  /// By default, the option is enabled
  showContour,

  /// Groups landmarks
  ///
  /// This option is available only in conjunction with [showLandmark]. By default, the option is disabled.
  group,

  /// Overlap highlight over existing map data
  ///
  /// This option is available only in conjunction with [showLandmark]. By default, the option is disabled.
  overlap,

  /// Disable highlight fading in / out
  ///
  /// This option is available only in conjunction with [showLandmark]. By default, the option is disabled.
  noFading,

  /// Bubble display
  ///
  /// The highlights are displayed in a bubble with custom icon placement inside the text by using the icon place-mark `%%0%%`, e.g. `"My header text %%0%%\nMy footer text"`
  /// This option is available only in conjunction with [showLandmark]
  /// This option will automatically invalidate the [group]
  /// By default, the option is disabled
  bubble,

  /// Selectable
  ///
  /// The highlights are selectable using setCursorScreenPosition
  /// This option is available only in conjunction with [showLandmark]
  /// By default, the option is disabled
  selectable,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension HighlightOptionsExtension on HighlightOptions {
  int get id {
    switch (this) {
      case HighlightOptions.showLandmark:
        return 1;
      case HighlightOptions.showContour:
        return 2;
      case HighlightOptions.group:
        return 4;
      case HighlightOptions.overlap:
        return 8;
      case HighlightOptions.noFading:
        return 16;
      case HighlightOptions.bubble:
        return 32;
      case HighlightOptions.selectable:
        return 64;
    }
  }

  static HighlightOptions fromId(int id) {
    switch (id) {
      case 1:
        return HighlightOptions.showLandmark;
      case 2:
        return HighlightOptions.showContour;
      case 4:
        return HighlightOptions.group;
      case 8:
        return HighlightOptions.overlap;
      case 16:
        return HighlightOptions.noFading;
      case 32:
        return HighlightOptions.bubble;
      case 64:
        return HighlightOptions.selectable;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Enum for route render options.
///
/// {@category Maps & 3D Scene}
enum RouteRenderOptions {
  /// Main route.
  main,

  /// Show traffic on the route.
  showTraffic,

  /// Show turn arrows on the route.
  showTurnArrows,

  /// Show waypoints on the route.
  showWaypoints,

  /// Show highlights on the route.
  showHighlights,

  /// Show user images that were set previously to route landmarks or waypoints.
  /// For example, if this flag is set, it will take the image from landmark(user image) and show it on the route instead of the default icon.
  showUserImage,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension RouteRenderOptionsExtension on RouteRenderOptions {
  int get id {
    switch (this) {
      case RouteRenderOptions.main:
        return 1;
      case RouteRenderOptions.showTraffic:
        return 2;
      case RouteRenderOptions.showTurnArrows:
        return 4;
      case RouteRenderOptions.showWaypoints:
        return 8;
      case RouteRenderOptions.showHighlights:
        return 16;
      case RouteRenderOptions.showUserImage:
        return 32;
    }
  }

  static RouteRenderOptions fromId(int id) {
    switch (id) {
      case 1:
        return RouteRenderOptions.main;
      case 2:
        return RouteRenderOptions.showTraffic;
      case 4:
        return RouteRenderOptions.showTurnArrows;
      case 8:
        return RouteRenderOptions.showWaypoints;
      case 16:
        return RouteRenderOptions.showHighlights;
      case 32:
        return RouteRenderOptions.showUserImage;

      default:
        throw ArgumentError('Invalid id');
    }
  }

  int operator |(dynamic other) {
    if (other is RouteRenderOptions) {
      return id | other.id;
    } else if (other is int) {
      return id | other;
    } else {
      throw ArgumentError('Invalid argument');
    }
  }
}

/// Class that defines the rendering settings for a view.
///
/// {@category Maps & 3D Scene}
class RenderSettings {
  /// The set that defines what elements to show.
  Set<dynamic>? options;

  /// The color for the inner area.
  Color? innerColor;

  /// The color for the outer area.
  Color? outerColor;

  /// The size for the inner area.
  double? innerSz;

  /// The size for the outer area.
  double? outerSz;

  /// The size for the image.
  double? imgSz;

  /// The size for the text.
  double? textSz;

  /// The color for the text.
  Color? textColor;
  RenderSettings({
    this.options,
    this.innerColor,
    this.outerColor,
    this.innerSz = -1.0,
    this.outerSz = 0.0,
    this.imgSz = 0,
    this.textSz = 0,
    this.textColor,
  }) {
    innerColor = innerColor ?? Colors.transparent;
    outerColor = outerColor ?? Colors.transparent;
    textColor = textColor ?? Colors.transparent;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (options != null) {
      json['options'] = options;
    }
    if (innerColor != null) {
      json['innerColor'] = innerColor!.toRgba();
    }
    if (outerColor != null) {
      json['outerColor'] = outerColor!.toRgba();
    }
    if (innerSz != null) {
      json['innerSz'] = innerSz;
    }
    if (outerSz != null) {
      json['outerSz'] = outerSz;
    }
    if (imgSz != null) {
      json['imgSz'] = imgSz;
    }
    if (textSz != null) {
      json['textSz'] = textSz;
    }
    if (textColor != null) {
      json['textColor'] = textColor!.toRgba();
    }
    return json;
  }

  factory RenderSettings.fromJson(Map<String, dynamic> json) {
    return RenderSettings(
      options: json['options'],
      innerColor: json['innerColor'],
      outerColor: json['outerColor'],
      innerSz: json['innerSz'],
      outerSz: json['outerSz'],
      imgSz: json['imgSz'],
      textSz: json['textSz'],
      textColor: json['textColor'],
    );
  }
}

/// Highlights render settings
///
/// {@category Maps & 3D Scene}
class HighlightRenderSettings extends RenderSettings {
  HighlightRenderSettings(
      {Set<dynamic>? options,
      Color? innerColor,
      Color? outerColor,
      double? innerSz,
      double? outerSz,
      double? imgSz,
      double? textSz,
      Color? textColor}) {
    this.options =
        options ?? {HighlightOptions.showLandmark, HighlightOptions.selectable};
    this.innerColor = innerColor ?? const Color.fromARGB(255, 255, 98, 0);
    this.outerColor = outerColor ?? const Color.fromARGB(255, 255, 98, 0);
    this.innerSz = innerSz ?? 1.5;
    this.outerSz = outerSz ?? 0.0;
    this.imgSz = imgSz;
    this.textSz = textSz;
    this.textColor = textColor;
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (options != null) {
      var el1 = (options!.first as HighlightOptions).id;
      for (var option in options!.skip(1)) {
        el1 |= (option as HighlightOptions).id;
      }
      json["options"] = el1;
    }
    if (innerColor != null) {
      json['innerColor'] = innerColor!.toRgba();
    }
    if (outerColor != null) {
      json['outerColor'] = outerColor!.toRgba();
    }
    if (innerSz != null) {
      json['innerSz'] = innerSz;
    }
    if (outerSz != null) {
      json['outerSz'] = outerSz;
    }
    if (imgSz != null) {
      json['imgSz'] = imgSz;
    }
    if (textSz != null) {
      json['textSz'] = textSz;
    }
    if (textColor != null) {
      json['textColor'] = textColor!.toRgba();
    }
    return json;
  }
}
