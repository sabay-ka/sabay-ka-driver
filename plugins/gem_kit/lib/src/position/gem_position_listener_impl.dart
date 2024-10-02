// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/position/gem_position.dart';
import 'package:gem_kit/src/position/gem_position_listener.dart';

/// Gem Position Listener
///
/// {@category Sensor Data Source}
class GemPositionListener extends IGemPositionListener {
  void Function(GemPosition position)? onNewPositionCallback;
  GemPositionListener(this.onNewPositionCallback);

  ///	Notification sent when a new position is available.
  ///
  /// **Parameters**
  ///
  /// * **IN** *pos* [GemPosition] object
  @override
  void onNewPosition(GemPosition pos) {
    if (onNewPositionCallback != null) {
      onNewPositionCallback!(pos);
    }
  }
}
