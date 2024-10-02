// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc
import 'package:gem_kit/src/core/event_handler.dart';
import 'package:gem_kit/src/core/progress_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// {@category Core}
class EventDrivenProgressListener extends ProgressListener implements EventHandler {
  void Function(int err, String hint, Map<dynamic, dynamic> json)? onCompleteWithDataCallback;
  void Function(dynamic)? onNotifyCustom;
  void Function(int progress)? onProgressCallback;
  void Function(int status)? onNotifyStatusChanged;

  EventDrivenProgressListener() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "ProgressListener"}));
    final decodedVal = jsonDecode(resultString!);
    id = decodedVal['result'];
  }

  EventDrivenProgressListener.init(dynamic id) {
    this.id = id;
  }

  @override
  void registerOnCompleteWithDataCallback(void Function(int err, String hint, Map<dynamic, dynamic> json) callback) {
    onCompleteWithDataCallback = callback;
  }

  @override
  void registerOnProgressCallback(void Function(int progress) callback) {
    onProgressCallback = callback;
  }

  @override
  void registerOnNotifyCustom(void Function(dynamic) callback) {
    onNotifyCustom = callback;
  }

  @override
  void registerOnNotifyStatusChanged(void Function(int status) callback) {
    onNotifyStatusChanged = callback;
  }

  @override
  void notifyComplete(int err, String hint) async {
    if (err == 0) {}
  }

  @override
  void notifyCompleteWithData(int err, String hint, Map<dynamic, dynamic> json) {
    if (onCompleteWithDataCallback != null) {
      onCompleteWithDataCallback!(err, hint, json);
    }
  }

  @override
  void notifyProgress(int progress) {
    if (onProgressCallback != null) {
      onProgressCallback!(progress);
    }
  }

  @override
  void notifyStart(bool hasProgress) {
    if (hasProgress) {}
  }

  @override
  void notifyCustom(dynamic json) {
    if (onNotifyCustom != null) {
      onNotifyCustom!(json);
    }
  }

  @override
  void notifyStatusChanged(int status) {
    if (onNotifyStatusChanged != null) {
      onNotifyStatusChanged!(status);
    }
  }

  @override
  void handleEvent(dynamic arguments) {
    Map<String, dynamic> json;

    if (arguments is String) {
      json = jsonDecode(arguments);
    } else {
      json = arguments;
    }

    if (json['eventType'] == 'startEvent') {
      notifyStart(false);
    } else if (json['eventType'] == 'completeEvent') {
      final err = json['errCode'];
      notifyCompleteWithData(err, '', json);
    } else if (json['eventType'] == 'notifyProgress') {
      notifyProgress(json['progress']);
    } else if (json['eventType'] == 'statusEvent') {
      notifyStatusChanged(json['status']);
    } else {
      notifyCustom(json);
    }
  }
}
