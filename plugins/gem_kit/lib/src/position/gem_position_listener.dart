// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/position/gem_position.dart';

import 'dart:convert';

/// Position listener interface.
///
/// {@category Sensor Data Source}
abstract class IGemPositionListener extends EventHandler {
  int id = 0;

  @override
  void handleEvent(dynamic arguments) {
    Map<String, dynamic> json;
    if (arguments is String) {
      json = jsonDecode(arguments);
    } else {
      json = arguments;
    }
    if (json['eventType'] == 'positionEvent') {
      //decode position
      onNewPosition(GemPosition.fromJson(json));
    }
  }

  ///	Notification sent when a new position is available.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* [GemPosition] object
  void onNewPosition(GemPosition pos) {
    throw UnimplementedError('onNewPosition() has not been implemented.');
  }
}
