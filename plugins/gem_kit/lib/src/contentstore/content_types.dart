// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// GEM SDK content types.
///
/// {@category Content}
enum ContentType {
  /// Augmented reality car models
  carModel,

  /// View styles for high resolution displays (e.g. mobile phones)
  viewStyleHighRes,

  /// Road map
  roadMap,

  /// Human voice
  humanVoice,

  /// Computer voice
  computerVoice,

  /// View styles for low resolution displays (e.g. desktop monitors)
  viewStyleLowRes,

  /// Unknown content type
  unknown,
}

/// This class will not be documented
/// @nodoc
///
/// {@category Content}
extension ContentTypeExtension on ContentType {
  int get id {
    switch (this) {
      case ContentType.carModel:
        return 1;
      case ContentType.viewStyleHighRes:
        return 2;
      case ContentType.roadMap:
        return 3;
      case ContentType.humanVoice:
        return 4;
      case ContentType.computerVoice:
        return 5;
      case ContentType.viewStyleLowRes:
        return 6;
      case ContentType.unknown:
        return 0;
    }
  }

  static ContentType fromId(int id) {
    switch (id) {
      case 1:
        return ContentType.carModel;
      case 2:
        return ContentType.viewStyleHighRes;
      case 3:
        return ContentType.roadMap;
      case 4:
        return ContentType.humanVoice;
      case 5:
        return ContentType.computerVoice;
      case 6:
        return ContentType.viewStyleLowRes;
      case 0:
        return ContentType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}
