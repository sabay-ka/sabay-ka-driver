import 'dart:ui';

import 'package:gem_kit/src/core/types.dart';

/// Extension methods for [Color]
///
/// {@category Core}
extension ColorExtension on Color {
  /// Convert [Color] to [Map]. Used for serialization with GemKit
  Map<String, dynamic> toJson() => {
        'r': red,
        'g': green,
        'b': blue,
        'a': alpha,
      };

  /// Convert [Color] to GemKit [Rgba] class
  Rgba toRgba() => Rgba(
        r: red,
        g: green,
        b: blue,
        a: alpha,
      );

  /// Convert GemKit [Rgba] class to [Color]. Used for deserialization with GemKit
  static Color fromJson(Map<String, dynamic> json) => Color.fromARGB(
        json['a'],
        json['r'],
        json['g'],
        json['b'],
      );
}
