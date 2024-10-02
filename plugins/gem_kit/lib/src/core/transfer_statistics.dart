// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:convert';

import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// Network types enumeration.
///
/// {@category Core}
enum NetworkType {
  /// Free of charge networks (unlimited WiFi or Wired networks, etc.)
  free,

  /// Charged per traffic/time (GPRS, EDGE, 3G, etc)
  extraCharged,
}

extension NetworkTypeExtension on NetworkType {
  int get id {
    switch (this) {
      case NetworkType.free:
        return 0;
      case NetworkType.extraCharged:
        return 1;
    }
  }

  static NetworkType fromId(int id) {
    switch (id) {
      case 0:
        return NetworkType.free;
      case 1:
        return NetworkType.extraCharged;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// TransferStatistics object.
///
/// {@category Core}
class TransferStatistics {
  int _id;
  int _mapId;
  int get id => _id;
  int get mapId => _mapId;

  TransferStatistics()
      : _id = -1,
        _mapId = -1;

  TransferStatistics.init(int id, int mapId)
      : _id = id,
        _mapId = mapId;

  int get upload {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "TransferStatistics", 'method': "getUpload", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  int get download {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "TransferStatistics", 'method': "getDownload", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  int get requests {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "TransferStatistics", 'method': "getRequests", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  int getUpload(NetworkType networkType) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _id, 'class': "TransferStatistics", 'method': "getUploadNetworkType", 'args': networkType.id}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  int getDownload(NetworkType networkType) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _id, 'class': "TransferStatistics", 'method': "getDownloadNetworkType", 'args': networkType.id}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  int getRequests(NetworkType networkType) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _id, 'class': "TransferStatistics", 'method': "getRequestsNetworkType", 'args': networkType.id}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  void reset() {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "TransferStatistics", 'method': "reset", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  void resetStatistics() {
    GemKitPlatform.instance.callObjectMethodffi(
        this, jsonEncode({'id': _id, 'class': "TransferStatistics", 'method': "resetStatistics", 'args': {}}));
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "TransferStatistics", 'id': _id}));
}
