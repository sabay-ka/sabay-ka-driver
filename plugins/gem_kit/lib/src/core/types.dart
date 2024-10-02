// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';
import 'dart:core';

/// @nodoc
///
/// {@category Core}
extension Compare<T> on Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;
  bool operator >=(T other) => compareTo(other) >= 0;
  bool operator <(T other) => compareTo(other) < 0;
  bool operator >(T other) => compareTo(other) > 0;
}

/// A generic class for defining a size
///
/// {@category Core}
class SizeType<T> {
  T? width;
  T? height;
  SizeType({
    this.width,
    this.height,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (width != null) {
      json['width'] = width;
    }
    if (height != null) {
      json['height'] = height;
    }
    return json;
  }

  factory SizeType.fromJson(Map<String, dynamic> json) {
    return SizeType(
      width: json['width'],
      height: json['height'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final SizeType<T> typedOther = other as SizeType<T>;
    return width == typedOther.width && height == typedOther.height;
  }

  @override
  int get hashCode {
    return Object.hash(width, height);
  }
}

/// A generic type consisting of x and y coordinates.
///
/// {@category Core}
class XyType<T> {
  T? x;
  T? y;
  XyType({
    this.x,
    this.y,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (x != null) {
      json['x'] = x;
    }
    if (y != null) {
      json['y'] = y;
    }
    return json;
  }

  factory XyType.fromJson(Map<String, dynamic> json) {
    return XyType(
      x: json['x'],
      y: json['y'],
    );
  }

  @override
  bool operator ==(covariant XyType<T> other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode;
  }
}

/// A generic type consisting of x, y and z coordinates.
///
/// {@category Core}
class XyzType<T> {
  T? x;
  T? y;
  T? z;
  XyzType({
    this.x,
    this.y,
    this.z,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (x != null) {
      json['x'] = x;
    }
    if (y != null) {
      json['y'] = y;
    }
    if (z != null) {
      json['z'] = z;
    }
    return json;
  }

  factory XyzType.fromJson(Map<String, dynamic> json) {
    return XyzType(
      x: json['x'],
      y: json['y'],
      z: json['z'],
    );
  }

  @override
  bool operator ==(covariant XyzType<T> other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y && other.z == z;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode;
  }
}

/// A generic type consisting of x, y, width and height coordinates.
///
/// {@category Core}
class RectType<T> {
  T? x;
  T? y;
  T? width;
  T? height;
  RectType({
    this.x,
    this.y,
    this.width,
    this.height,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (x != null) {
      json['x'] = x;
    }
    if (y != null) {
      json['y'] = y;
    }
    if (width != null) {
      json['width'] = width;
    }
    if (height != null) {
      json['height'] = height;
    }
    return json;
  }

  factory RectType.fromJson(Map<String, dynamic> json) {
    return RectType(
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
    );
  }

  @override
  bool operator ==(covariant RectType<T> other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y && other.width == width && other.height == height;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ width.hashCode ^ height.hashCode;
  }
}

/// Time distance representation based on meters and seconds.
///
/// {@category Core}
class TimeDistance {
  /// Unrestricted time in seconds
  int unrestrictedTimeS;

  /// Restricted time in seconds
  int restrictedTimeS;

  /// Unrestricted distance in meters
  int unrestrictedDistanceM;

  /// Restricted distance in meters
  int restrictedDistanceM;

  /// Restricted begin/end ratio.
  double? ndBeginEndRatio;

  /// Constructor with unrestricted and restricted times and distances
  ///
  /// **Parameters**
  ///
  /// * **IN** *unrestrictedTimeS* Unrestricted time in seconds
  /// * **IN** *restrictedTimeS* Restricted time in seconds
  /// * **IN** *unrestrictedDistanceM* Unrestricted distance in meters
  /// * **IN** *restrictedDistanceM* Restricted distance in meters
  /// * **IN** *ndBeginEndRatio* Restricted begin/end ratio
  TimeDistance(
      {this.unrestrictedTimeS = 0,
      this.restrictedTimeS = 0,
      this.unrestrictedDistanceM = 0,
      this.restrictedDistanceM = 0,
      this.ndBeginEndRatio = -1.0});

  /// Total time in seconds
  int get totalTimeS => unrestrictedTimeS + restrictedTimeS;

  /// Total distance in meters
  int get totalDistanceM => unrestrictedDistanceM + restrictedDistanceM;

  /// Check if empty. Returns true if empty, false otherwise
  bool get isEmpty => totalTimeS == 0;

  /// Check if not empty. Returns true if not empty, false otherwise
  bool get isNotEmpty => !isEmpty;

  /// Check if it has different begin/end.
  /// Returns true if it has different begin/end, false otherwise
  bool get hasRestrictedBeginEndDifferentiation => ndBeginEndRatio != null && ndBeginEndRatio! >= 0;

  /// Restricted time at begin
  int get restrictedTimeAtBegin {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedTimeS * (1 - ndBeginEndRatio!)).round();
    }

    return 0;
  }

  /// Restricted time at begin
  int get restrictedTimeAtEnd {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedTimeS * ndBeginEndRatio!).round();
    }

    return 0;
  }

  /// Restricted distance at begin
  int get restrictedDistanceAtBegin {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedDistanceM * (1 - ndBeginEndRatio!)).round();
    }

    return 0;
  }

  /// Restricted distance at end
  int get restrictedDistanceAtEnd {
    if (hasRestrictedBeginEndDifferentiation) {
      return (restrictedDistanceM * ndBeginEndRatio!).round();
    }

    return 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['unrestrictedTimeS'] = unrestrictedTimeS;

    json['restrictedTimeS'] = restrictedTimeS;

    json['unrestrictedDistanceM'] = unrestrictedDistanceM;

    json['restrictedDistanceM'] = restrictedDistanceM;

    if (ndBeginEndRatio != null) {
      json['ndBeginEndRatio'] = ndBeginEndRatio;
    }
    return json;
  }

  factory TimeDistance.fromJson(Map<String, dynamic> json) {
    return TimeDistance(
        unrestrictedTimeS: json['unrestrictedTimeS'],
        restrictedTimeS: json['restrictedTimeS'],
        unrestrictedDistanceM: json['unrestrictedDistanceM'],
        restrictedDistanceM: json['restrictedDistanceM'],
        ndBeginEndRatio: json['ndBeginEndRatio']);
  }

  @override
  bool operator ==(covariant TimeDistance other) {
    if (identical(this, other)) return true;

    return other.unrestrictedTimeS == unrestrictedTimeS &&
        other.restrictedTimeS == restrictedTimeS &&
        other.unrestrictedDistanceM == unrestrictedDistanceM &&
        other.restrictedDistanceM == restrictedDistanceM &&
        other.ndBeginEndRatio == ndBeginEndRatio;
  }

  @override
  int get hashCode {
    return Object.hash(unrestrictedTimeS, restrictedTimeS, unrestrictedDistanceM, restrictedDistanceM, ndBeginEndRatio);
  }

  TimeDistance operator +(TimeDistance other) {
    return TimeDistance(
      unrestrictedTimeS: unrestrictedTimeS + other.unrestrictedTimeS,
      restrictedTimeS: restrictedTimeS + other.restrictedTimeS,
      unrestrictedDistanceM: unrestrictedDistanceM + other.unrestrictedDistanceM,
      restrictedDistanceM: restrictedDistanceM + other.restrictedDistanceM,
      ndBeginEndRatio: -1,
    );
  }
}

/// This class will not be documented
/// @nodoc
///
/// {@category Core}
class Rgba {
  int r;
  int g;
  int b;
  int a;
  Rgba({this.r = 0, this.g = 0, this.b = 0, this.a = 255});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['r'] = r;
    json['g'] = g;
    json['b'] = b;
    json['a'] = a;
    return json;
  }

  factory Rgba.fromJson(Map<String, dynamic> json) {
    return Rgba(r: json['r'], g: json['g'], b: json['b'], a: json['a']);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Rgba otherRgba = other as Rgba;
    return r == otherRgba.r && g == otherRgba.g && b == otherRgba.b && a == otherRgba.a;
  }

  @override
  int get hashCode {
    return r.hashCode ^ g.hashCode ^ b.hashCode ^ a.hashCode;
  }

  @override
  String toString() {
    return 'Rgba(r: $r, g: $g, b: $b, a: $a)';
  }
}

/// @nodoc
///
/// {@category Core}
class RgbaNoColor extends Rgba {
  RgbaNoColor() : super(r: 0, g: 0, b: 0, a: 0);
}

///  SDK version representation as four ints and a text string.
///
/// {@category Core}
class SdkVersion {
  /// Minor SDK version number, such as 2 in version 1.2;
  int minor;

  /// Major SDK version number, such as 1 in version 1.2;
  int major;

  /// SDK year, decimal 1 or 2 digits
  int year;

  /// The week of the year, decimal 1 or 2 digits
  int week;

  /// SDK revision string
  String revision;

  SdkVersion({this.minor = 0, this.major = 0, this.year = 0, this.week = 0, this.revision = ""});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['minor'] = minor;
    json['major'] = major;
    json['year'] = year;
    json['week'] = week;
    json['revision'] = revision;
    return json;
  }

  factory SdkVersion.fromJson(Map<String, dynamic> json) {
    return SdkVersion(
        minor: json['minor'], major: json['major'], week: json['week'], year: json['year'], revision: json['revision']);
  }
}

/// Define the content version with major and minor.
///
/// {@category Core}
class Version implements Comparable<Version> {
  /// Minor version number
  int minor;

  /// Major version number
  int major;

  /// Encoded version number
  int encodedVersion;

  Version({this.minor = 0, this.major = 0, this.encodedVersion = 0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['fields']['minor'] = minor;
    json['fields']['major'] = major;
    return json;
  }

  factory Version.fromJson(Map<String, dynamic> json) {
    int lminor = (json['version'] >> 16) & 0xFFFF;
    int lmajor = json['version'] & 0xFFFF;
    return Version(minor: lminor, major: lmajor, encodedVersion: json['version']);
  }
  @override
  int compareTo(Version other) {
    if (major == other.major) {
      return minor.compareTo(other.minor);
    }
    return major.compareTo(other.major);
  }

  @override
  bool operator ==(covariant Version other) {
    if (identical(this, other)) return true;

    return major == other.major && minor == other.minor;
  }

  @override
  int get hashCode => major.hashCode ^ minor.hashCode;
}

/// @nodoc
///
/// {@category Core}
class AutoDisposableObject<T> {
  final Finalizer<T> _finalizer;

  AutoDisposableObject._(this._finalizer);

  factory AutoDisposableObject.create(T obj, Finalizer<T> finalizer) {
    final wrapper = AutoDisposableObject<T>._(finalizer);
    // Get finalizer callback when `wrapper` is no longer reachable.
    finalizer.attach(wrapper, obj, detach: wrapper);
    return wrapper;
  }
  void destructor() {}
  void dispose() {
    // User requested disposal.
    destructor();
    // Detach from finalizer, no longer needed.
    _finalizer.detach(this);
  }

  // Some useful methods.
}

/// @nodoc
///
/// {@category Core}
class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    final Pair<T1, T2> typedOther = other as Pair<T1, T2>;
    return first == typedOther.first && second == typedOther.second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

/// @nodoc
///
/// {@category Core}
class GemList<T> implements Iterable<T> {
  final dynamic _pointerId;
  final int _mapId;
  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;
  final T Function(dynamic, int) _initializer;
  final String _className;

  GemList(this._pointerId, this._mapId, this._className, this._initializer);

  GemList.init(this._pointerId, this._mapId, this._className, this._initializer) {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  @override
  Iterator<T> get iterator => GenericIterator<T>(_pointerId, _mapId, size(), _className, _initializer);

  int size() {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({'id': _pointerId, 'class': _className, 'method': "size", 'args': {}}),
      );
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  T operator [](int index) => at(index);
  T at(int position) {
    if (position > length - 1) {
      throw RangeError.range(position, 0, length - 1, "Index out of bounds");
    } else {
      try {
        final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({'id': _pointerId, 'class': _className, 'method': "at", 'args': position}),
        );
        final decodedVal = jsonDecode(resultString!);
        return _initializer(decodedVal['result'], _mapId);
      } catch (e) {
        rethrow;
      }
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': _className, 'id': _pointerId}));
  }

  @override
  bool any(bool Function(T element) test) {
    for (var item in this) {
      if (test(item)) {
        return true;
      }
    }
    return false;
  }

  @override
  Iterable<R> cast<R>() {
    throw UnimplementedError();
  }

  @override
  bool contains(Object? element) {
    for (var route in this) {
      if (route == element) {
        return true;
      }
    }
    return false;
  }

  @override
  T elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }
    return at(index)!;
  }

  @override
  bool every(bool Function(T element) test) {
    for (var item in this) {
      if (!test(item)) {
        return false;
      }
    }
    return true;
  }

  @override
  Iterable<R> expand<R>(Iterable<R> Function(T element) toElements) sync* {
    for (var element in this) {
      yield* toElements(element);
    }
  }

  @override
  T get first {
    if (isEmpty) {
      throw StateError("No elements");
    }
    return at(0)!;
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    for (var item in this) {
      if (test(item)) {
        return item;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError("No matching element");
  }

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) {
    R result = initialValue;
    for (var route in this) {
      result = combine(result, route);
    }
    return result;
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return [...this, ...other];
  }

  @override
  void forEach(void Function(T element) action) {
    for (var item in this) {
      action(item);
    }
  }

  @override
  bool get isEmpty => length == 0;

  @override
  bool get isNotEmpty => length > 0;

  @override
  String join([String separator = ""]) {
    throw UnimplementedError();
  }

  @override
  T get last {
    if (isEmpty) {
      throw StateError("No elements");
    }
    return at(length - 1)!;
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    for (var i = length - 1; i >= 0; i--) {
      var item = at(i);
      if (test(item)) {
        return item;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError("No matching element");
  }

  @override
  int get length => size();

  @override
  T reduce(T Function(T value, T element) combine) {
    if (isEmpty) {
      throw StateError("No elements");
    }
    var result = first;
    for (var i = 1; i < length; i++) {
      result = combine(result, at(i)!);
    }
    return result;
  }

  @override
  T get single {
    if (length != 1) {
      throw StateError("Not a single element");
    }
    return first;
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    T? result;
    for (var item in this) {
      if (test(item)) {
        if (result != null) {
          throw StateError("More than one matching element");
        }
        result = item;
      }
    }
    if (result != null) {
      return result;
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError("No matching element");
  }

  @override
  Iterable<T> skip(int count) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> take(int count) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    throw UnimplementedError();
  }

  @override
  List<T> toList({bool growable = true}) {
    var list = <T>[];
    for (var item in this) {
      list.add(item);
    }
    return list;
  }

  @override
  Set<T> toSet() {
    var set = <T>{};
    for (var item in this) {
      set.add(item);
    }
    return set;
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return [
      for (var item in this)
        if (test(item)) item
    ];
  }

  @override
  Iterable<U> whereType<U>() {
    throw UnimplementedError();
  }

  @override
  Iterable<R> map<R>(R Function(T e) toElement) {
    List<R> result = [];
    for (var route in this) {
      result.add(toElement(route));
    }
    return result;
  }
}

/// This class will not be documented
/// @nodoc
///
/// {@category Core}
class GenericIterator<T> implements Iterator<T> {
  final dynamic _listId;
  final int _mapId;

  int _currentIndex = -1;
  final int _currentSize;
  final String _className;
  final T Function(dynamic, int) _initializer;
  GenericIterator(this._listId, int mapId, this._currentSize, this._className, this._initializer) : _mapId = mapId;

  @override
  T get current {
    if (_currentIndex == -1) {
      throw StateError("No current element");
    }
    if (_currentIndex >= _currentSize) {
      throw StateError("No more elements");
    }

    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({'id': _listId, 'class': _className, 'method': 'at', 'args': _currentIndex}),
      );
      final decodedVal = jsonDecode(resultString!);
      return _initializer(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool moveNext() {
    _currentIndex++;
    return _currentIndex < _currentSize;
  }
}

/// A point in 3d space, consisting of x, y and z coordinates.
///
/// {@category Core}
class Point3d {
  double x;
  double y;
  double z;
  Point3d({this.x = 0.0, this.y = 0.0, this.z = 0.0});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['x'] = x;
    json['y'] = y;
    json['z'] = z;
    return json;
  }

  factory Point3d.fromJson(Map<String, dynamic> json) {
    return Point3d(x: json['x'], y: json['y'], z: json['z']);
  }

  @override
  String toString() {
    return 'Point3d(x: $x, y: $y, z: $z)';
  }

  @override
  bool operator ==(covariant Point3d other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y && other.z == z;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode;
  }
}

/// A point in 4d space, consisting of x, y, z and w coordinates.
///
/// {@category Core}
class Point4d {
  double x;
  double y;
  double z;
  double w;
  Point4d({this.x = 0.0, this.y = 0.0, this.z = 0.0, this.w = 0.0});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['x'] = x;
    json['y'] = y;
    json['z'] = z;
    json['w'] = w;
    return json;
  }

  factory Point4d.fromJson(Map<String, dynamic> json) {
    return Point4d(x: json['x'], y: json['y'], z: json['z'], w: json['w']);
  }

  @override
  String toString() {
    return 'Point4d(x: $x, y: $y, z: $z, w: $w)';
  }

  @override
  bool operator ==(covariant Point4d other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y && other.z == z && other.w == w;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode ^ w.hashCode;
  }
}
