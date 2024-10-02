// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

/// Turn details class
///
/// This class should not be instantiated directly. Instead, use the related methods from [RouteInstruction] or [NavigationInstruction] to obtain an instance.
///
/// {@category Routes & Navigation}
class TurnDetails {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  TurnDetails._()
      : _pointerId = -1,
        _mapId = -1;

  TurnDetails.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId;

  /// Get the abstract geometry.
  ///
  /// **Returns**
  ///
  /// * The abstract geometry
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  AbstractGeometry get abstractGeometry {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "TurnDetails", 'method': "getAbstractGeometry", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return AbstractGeometry.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the image for the abstract geometry.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  /// * **IN** *renderSettings* [AbstractGeometryImageRenderSettings] object, representing the settings of the image.
  ///
  /// **Returns**
  ///
  /// * The image for the lane abstract geometry. The API user is responsible to check if the image is valid.
  Uint8List getAbstractGeometryImage({
    Size? size,
    ImageFileFormat? format,
    AbstractGeometryImageRenderSettings renderSettings = const AbstractGeometryImageRenderSettings(),
  }) {
    return GemKitPlatform.instance.callGetImage(pointerId, "TurnDetailsGetAbstractGeometryImage",
        size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1,
        arg: jsonEncode(renderSettings));
  }

  /// Get the ID of the image for the abstract geometry.
  ///
  /// **Returns**
  ///
  /// * The ID of the image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get abstractGeometryImageUid {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "TurnDetails", 'method': "getAbstractGeometryImageUid", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get event.
  ///
  /// Result is in [TurnEvent] range.
  ///
  /// **Returns**
  ///
  /// * The turn event
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TurnEvent get event {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "TurnDetails", 'method': "getEvent", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TurnEventExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the roundabout exit number ( > 0).
  ///
  /// **Returns**
  ///
  /// * -1 when no roundabout exit number.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get roundaboutExitNumber {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "TurnDetails", 'method': "getRoundaboutExitNumber", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<TurnDetails> create(int mapId) async {
    final resultString = await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>('callObjectConstructor', jsonEncode({'class': "TurnDetails"}));
    final decodedVal = jsonDecode(resultString!);
    return TurnDetails.init(decodedVal['result'], mapId);
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "TurnDetails", 'id': _pointerId}));
}

/// AbstractGeometryItem object.
/// @nodoc
///
/// {@category Routes & Navigation}
class AbstractGeometryItem {
  // Arrow type
  ArrowType? arrowType;

  /// Arrow direction at the begin.
  ArrowDirection? beginArrowDirection;

  /// Get the slot the shape begin is attached to the anchor.
  /// The begin slot references the position where the begin shape is attached to the anchor.
  ///
  /// 12 slots are possible, -1 indicates N/A. The numbers indicate position similar to a clock face.
  /// TShapeForm::ESF_CircleSegment follows the circle from begin to end slot, TShapeForm::ESF_Line spans over the
  /// circle from begin to end slot
  int? beginSlot;

  /// Arrow direction at the end.
  ArrowDirection? endArrowDirection;

  /// Get the slot the shape end is attached to the anchor.
  /// The begin slot references the position where the end shape is attached to the anchor.
  ///
  /// 12 slots are possible, -1 indicates N/A. The numbers indicate position similar to a clock face.
  /// TShapeForm::ESF_CircleSegment follows the circle from begin to end slot, TShapeForm::ESF_Line spans over the
  /// circle from begin to end slot
  int? endSlot;

  /// Restriction type.
  RestrictionType? restrictionType;

  /// Shape form.
  ShapeForm? shapeForm;

  /// Shape type.
  ShapeType? shapeType;

  /// Slot allocation.
  /// The slot allocation indicates how many shapes are occupying a slot. The rendering should reflect this by different dividers.
  int? slotAllocation;

  AbstractGeometryItem({
    this.arrowType,
    this.beginArrowDirection,
    this.beginSlot,
    this.endArrowDirection,
    this.endSlot,
    this.restrictionType,
    this.shapeForm,
    this.shapeType,
    this.slotAllocation,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (arrowType != null) {
      json['arrowtype'] = arrowType!.id;
    }
    if (beginArrowDirection != null) {
      json['beginarrowdirection'] = beginArrowDirection!.id;
    }
    if (beginSlot != null) {
      json['beginslot'] = beginSlot;
    }
    if (endArrowDirection != null) {
      json['endarrowdirection'] = endArrowDirection!.id;
    }
    if (endSlot != null) {
      json['endslot'] = endSlot;
    }
    if (restrictionType != null) {
      json['restrictiontype'] = restrictionType!.id;
    }
    if (shapeForm != null) {
      json['shapeform'] = shapeForm!.id;
    }
    if (shapeType != null) {
      json['shapetype'] = shapeType!.id;
    }
    if (slotAllocation != null) {
      json['slotallocation'] = slotAllocation;
    }
    return json;
  }

  factory AbstractGeometryItem.fromJson(Map<String, dynamic> json) {
    return AbstractGeometryItem(
      arrowType: ArrowTypeExtension.fromId(json['arrowtype']),
      beginArrowDirection: ArrowDirectionExtension.fromId(json['beginarrowdirection']),
      beginSlot: json['beginslot'],
      endArrowDirection: ArrowDirectionExtension.fromId(json['endarrowdirection']),
      endSlot: json['endslot'],
      restrictionType: RestrictionTypeExtension.fromId(json['restrictiontype']),
      shapeForm: ShapeFormExtension.fromId(json['shapeform']),
      shapeType: ShapeTypeExtension.fromId(json['shapetype']),
      slotAllocation: json['slotallocation'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AbstractGeometryItem typedOther = other as AbstractGeometryItem;
    return arrowType == typedOther.arrowType &&
        beginArrowDirection == typedOther.beginArrowDirection &&
        beginSlot == typedOther.beginSlot &&
        endArrowDirection == typedOther.endArrowDirection &&
        endSlot == typedOther.endSlot &&
        restrictionType == typedOther.restrictionType &&
        shapeForm == typedOther.shapeForm &&
        shapeType == typedOther.shapeType &&
        slotAllocation == typedOther.slotAllocation;
  }

  @override
  int get hashCode {
    return arrowType.hashCode ^
        beginArrowDirection.hashCode ^
        beginSlot.hashCode ^
        endArrowDirection.hashCode ^
        endSlot.hashCode ^
        restrictionType.hashCode ^
        shapeForm.hashCode ^
        slotAllocation.hashCode;
  }
}

/// AbstractGeometry object.
///
/// {@category Routes & Navigation}
class AbstractGeometry {
  // Anchor type
  AnchorType? anchorType;

  /// Drive side
  DriveSide? driveSide;

  /// List of geometry items
  List<AbstractGeometryItem>? items;

  // Get the number of left side intermediate turns.
  int? leftIntermediateTurns;

  // Get the number of right side intermediate turns.
  int? rightIntermediateTurns;
  AbstractGeometry({
    this.anchorType,
    this.driveSide,
    this.items,
    this.leftIntermediateTurns,
    this.rightIntermediateTurns,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (anchorType != null) {
      json['anchortype'] = anchorType!.id;
    }
    if (driveSide != null) {
      json['driveside'] = driveSide!.id;
    }
    if (items != null) {
      json['items'] = items;
    }
    if (leftIntermediateTurns != null) {
      json['leftintermediateturns'] = leftIntermediateTurns;
    }
    if (rightIntermediateTurns != null) {
      json['rightintermediateturns'] = rightIntermediateTurns;
    }
    return json;
  }

  factory AbstractGeometry.fromJson(Map<String, dynamic> json) {
    return AbstractGeometry(
      anchorType: AnchorTypeExtension.fromId(json['anchortype']),
      driveSide: DriveSideExtension.fromId(json['driveside']),
      items: (json['items'] as List<dynamic>)
          .map((item) => AbstractGeometryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      leftIntermediateTurns: json['leftintermediateturns'],
      rightIntermediateTurns: json['rightintermediateturns'],
    );
  }
}

/// Navigation turn events
///
/// {@category Routes & Navigation}
enum TurnEvent {
  /// Turn type not available
  na,

  /// Continue straight ahead
  straight,

  /// Turn right
  right,

  /// Turn right
  right1,

  /// Turn right
  right2,

  /// Turn left
  left,

  /// Turn left
  left1,

  /// Turn left
  left2,

  ///Turn half left
  lightLeft,

  /// Turn half left
  lightLeft1,

  ///Turn half left
  lightLeft2,

  ///Turn half right
  lightRight,

  ///Turn half right
  lightRight1,

  ///Turn half right
  lightRight2,

  /// Turn sharp right
  sharpRight,

  /// Turn sharp right
  sharpRight1,

  /// Turn sharp right
  sharpRight2,

  /// Turn sharp left
  sharpLeft,

  /// Turn sharp left
  sharpLeft1,

  /// Turn sharp left
  sharpLeft2,

  /// Leave the roundabout to the right
  roundaboutExitRight,

  /// Continue on the roundabout
  roundabout,

  /// Make a U-turn
  roundRight,

  /// Make a U-turn
  roundLeft,

  /// Take the exit
  exitRight,

  /// Take the exit
  exitRight1,

  /// Take the exit
  exitRight2,

  /// Generic info
  infoGeneric,

  /// Drive on
  driveOn,

  /// Take exit number
  exitNr,

  /// Take the exit
  exitLeft,

  /// Take the exit
  exitLeft1,

  /// Take the exit
  exitLeft2,

  /// Leave the roundabout to the left
  roundaboutExitLeft,

  /// Leave the roundabout at the ... exit
  intoRoundabout,

  /// Continue straight ahead
  stayOn,

  /// Take the ferry
  boatFerry,

  /// Take the car transport by train
  railFerry,

  /// Lane info
  infoLane,

  /// Info sign
  infoSign,

  /// Left and then turn right
  leftRight,

  /// Right and then turn left
  rightLeft,

  /// Bear left
  keepLeft,

  /// Bear right
  keepRight,

  /// Start waypoint
  start,

  /// Intermediate waypoint
  intermediate,

  /// Stop waypoint
  stop,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension TurnEventExtension on TurnEvent {
  int get id {
    switch (this) {
      case TurnEvent.na:
        return 0;
      case TurnEvent.straight:
        return 1;
      case TurnEvent.right:
        return 2;
      case TurnEvent.right1:
        return 3;
      case TurnEvent.right2:
        return 4;
      case TurnEvent.left:
        return 5;
      case TurnEvent.left1:
        return 6;
      case TurnEvent.left2:
        return 7;
      case TurnEvent.lightLeft:
        return 8;
      case TurnEvent.lightLeft1:
        return 9;
      case TurnEvent.lightLeft2:
        return 10;
      case TurnEvent.lightRight:
        return 11;
      case TurnEvent.lightRight1:
        return 12;
      case TurnEvent.lightRight2:
        return 13;
      case TurnEvent.sharpRight:
        return 14;
      case TurnEvent.sharpRight1:
        return 15;
      case TurnEvent.sharpRight2:
        return 16;
      case TurnEvent.sharpLeft:
        return 17;
      case TurnEvent.sharpLeft1:
        return 18;
      case TurnEvent.sharpLeft2:
        return 19;
      case TurnEvent.roundaboutExitRight:
        return 20;
      case TurnEvent.roundabout:
        return 21;
      case TurnEvent.roundRight:
        return 22;
      case TurnEvent.roundLeft:
        return 23;
      case TurnEvent.exitRight:
        return 24;
      case TurnEvent.exitRight1:
        return 25;
      case TurnEvent.exitRight2:
        return 26;
      case TurnEvent.infoGeneric:
        return 27;
      case TurnEvent.driveOn:
        return 28;
      case TurnEvent.exitNr:
        return 29;
      case TurnEvent.exitLeft:
        return 30;
      case TurnEvent.exitLeft1:
        return 31;
      case TurnEvent.exitLeft2:
        return 32;
      case TurnEvent.roundaboutExitLeft:
        return 33;
      case TurnEvent.intoRoundabout:
        return 34;
      case TurnEvent.stayOn:
        return 35;
      case TurnEvent.boatFerry:
        return 36;
      case TurnEvent.railFerry:
        return 37;
      case TurnEvent.infoLane:
        return 38;
      case TurnEvent.infoSign:
        return 39;
      case TurnEvent.leftRight:
        return 40;
      case TurnEvent.rightLeft:
        return 41;
      case TurnEvent.keepLeft:
        return 42;
      case TurnEvent.keepRight:
        return 43;
      case TurnEvent.start:
        return 44;
      case TurnEvent.intermediate:
        return 45;
      case TurnEvent.stop:
        return 46;
    }
  }

  static TurnEvent fromId(int id) {
    switch (id) {
      case 0:
        return TurnEvent.na;
      case 1:
        return TurnEvent.straight;
      case 2:
        return TurnEvent.right;
      case 3:
        return TurnEvent.right1;
      case 4:
        return TurnEvent.right2;
      case 5:
        return TurnEvent.left;
      case 6:
        return TurnEvent.left1;
      case 7:
        return TurnEvent.left2;
      case 8:
        return TurnEvent.lightLeft;
      case 9:
        return TurnEvent.lightLeft1;
      case 10:
        return TurnEvent.lightLeft2;
      case 11:
        return TurnEvent.lightRight;
      case 12:
        return TurnEvent.lightRight1;
      case 13:
        return TurnEvent.lightRight2;
      case 14:
        return TurnEvent.sharpRight;
      case 15:
        return TurnEvent.sharpRight1;
      case 16:
        return TurnEvent.sharpRight2;
      case 17:
        return TurnEvent.sharpLeft;
      case 18:
        return TurnEvent.sharpLeft1;
      case 19:
        return TurnEvent.sharpLeft2;
      case 20:
        return TurnEvent.roundaboutExitRight;
      case 21:
        return TurnEvent.roundabout;
      case 22:
        return TurnEvent.roundRight;
      case 23:
        return TurnEvent.roundLeft;
      case 24:
        return TurnEvent.exitRight;
      case 25:
        return TurnEvent.exitRight1;
      case 26:
        return TurnEvent.exitRight2;
      case 27:
        return TurnEvent.infoGeneric;
      case 28:
        return TurnEvent.driveOn;
      case 29:
        return TurnEvent.exitNr;
      case 30:
        return TurnEvent.exitLeft;
      case 31:
        return TurnEvent.exitLeft1;
      case 32:
        return TurnEvent.exitLeft2;
      case 33:
        return TurnEvent.roundaboutExitLeft;
      case 34:
        return TurnEvent.intoRoundabout;
      case 35:
        return TurnEvent.stayOn;
      case 36:
        return TurnEvent.boatFerry;
      case 37:
        return TurnEvent.railFerry;
      case 38:
        return TurnEvent.infoLane;
      case 39:
        return TurnEvent.infoSign;
      case 40:
        return TurnEvent.leftRight;
      case 41:
        return TurnEvent.rightLeft;
      case 42:
        return TurnEvent.keepLeft;
      case 43:
        return TurnEvent.keepRight;
      case 44:
        return TurnEvent.start;
      case 45:
        return TurnEvent.intermediate;
      case 46:
        return TurnEvent.stop;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The type of the shape.
/// Use the type to render the shape in different width and color.
///
/// {@category Routes & Navigation}
enum ShapeForm {
  /// Line is a simple line with width defined by [ShapeType],
  line,

  /// CircleSegment (clock wise or counter clock wise depending on drive side) is a part of a [AnchorType.circle]
  circleSegment,

  /// Point is a maker (e.g. Waypoint place) outside the anchor and not connected by a line. Get the index of the next route instruction on the current route segment.
  point,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ShapeFormExtension on ShapeForm {
  int get id {
    switch (this) {
      case ShapeForm.line:
        return 0;
      case ShapeForm.circleSegment:
        return 1;
      case ShapeForm.point:
        return 2;
    }
  }

  static ShapeForm fromId(int id) {
    switch (id) {
      case 0:
        return ShapeForm.line;
      case 1:
        return ShapeForm.circleSegment;
      case 2:
        return ShapeForm.point;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The type of the shape.
/// Use the type to render the shape in different width and color.
/// [ShapeType.route] should be rendered over [ShapeType.street]
///
/// {@category Routes & Navigation}
enum ShapeType {
  /// Route
  route,

  /// Street
  street,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ShapeTypeExtension on ShapeType {
  int get id {
    switch (this) {
      case ShapeType.route:
        return 0;
      case ShapeType.street:
        return 1;
    }
  }

  static ShapeType fromId(int id) {
    switch (id) {
      case 0:
        return ShapeType.route;
      case 1:
        return ShapeType.street;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The arrow type of the shape.
///
/// The arrow is either attached to the anchor side [begin], or the opposite side [end].
///
/// {@category Routes & Navigation}
enum ArrowType {
  /// None
  none,

  /// Begin
  begin,

  /// End
  end,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ArrowTypeExtension on ArrowType {
  int get id {
    switch (this) {
      case ArrowType.none:
        return 0;
      case ArrowType.begin:
        return 1;
      case ArrowType.end:
        return 2;
    }
  }

  static ArrowType fromId(int id) {
    switch (id) {
      case 0:
        return ArrowType.none;
      case 1:
        return ArrowType.begin;
      case 2:
        return ArrowType.end;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The restriction type of the shape.
///
/// The restriction type can be used to visualize the restriction for the connected street.
///
/// {@category Routes & Navigation}
enum RestrictionType {
  /// No restriction
  none,

  /// Direction restriction
  direction,

  /// Maneuver restriction
  manoeuvre,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RestrictionTypeExtension on RestrictionType {
  int get id {
    switch (this) {
      case RestrictionType.none:
        return 0;
      case RestrictionType.direction:
        return 1;
      case RestrictionType.manoeuvre:
        return 2;
    }
  }

  static RestrictionType fromId(int id) {
    switch (id) {
      case 0:
        return RestrictionType.none;
      case 1:
        return RestrictionType.direction;
      case 2:
        return RestrictionType.manoeuvre;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The arrow direction of the shape.
///
/// The arrow direction will be only valid for [ShapeForm.circleSegment] and some combined turns
///
/// {@category Routes & Navigation}
enum ArrowDirection {
  /// None
  none,

  /// Left
  left,

  /// Straight
  straight,

  /// Right
  right,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension ArrowDirectionExtension on ArrowDirection {
  int get id {
    switch (this) {
      case ArrowDirection.none:
        return 0;
      case ArrowDirection.left:
        return 1;
      case ArrowDirection.straight:
        return 2;
      case ArrowDirection.right:
        return 3;
    }
  }

  static ArrowDirection fromId(int id) {
    switch (id) {
      case 0:
        return ArrowDirection.none;
      case 1:
        return ArrowDirection.left;
      case 2:
        return ArrowDirection.straight;
      case 3:
        return ArrowDirection.right;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The anchor type.
///
/// The anchor is a point (all intersections), a circle (roundabout, complex traffic figure) or a waypoint.
///
/// {@category Routes & Navigation}
enum AnchorType {
  /// Point
  point,

  /// Circle
  circle,

  /// Waypoint
  waypoint,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension AnchorTypeExtension on AnchorType {
  int get id {
    switch (this) {
      case AnchorType.point:
        return 0;
      case AnchorType.circle:
        return 1;
      case AnchorType.waypoint:
        return 2;
    }
  }

  static AnchorType fromId(int id) {
    switch (id) {
      case 0:
        return AnchorType.point;
      case 1:
        return AnchorType.circle;
      case 2:
        return AnchorType.waypoint;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// The drive side of the abstract geometry.
///
/// The drive side allows to render the correct U-Turn shape.
///
/// {@category Routes & Navigation}
enum DriveSide {
  /// Left
  left,

  /// Right
  right,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension DriveSideExtension on DriveSide {
  int get id {
    switch (this) {
      case DriveSide.left:
        return 0;
      case DriveSide.right:
        return 1;
    }
  }

  static DriveSide fromId(int id) {
    switch (id) {
      case 0:
        return DriveSide.left;
      case 1:
        return DriveSide.right;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
