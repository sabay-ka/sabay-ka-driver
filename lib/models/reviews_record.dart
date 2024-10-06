// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i3;
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart' as _i2;

import 'base_record.dart' as _i1;
import 'empty_values.dart' as _i4;


enum ReviewsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  ride,
  reviewer,
  rating,
  comment
}

@JsonSerializable()
final class ReviewsRecord extends _i1.BaseRecord {
  ReviewsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required this.ride,
    required this.reviewer,
    required this.rating,
    this.comment,
  });

  factory ReviewsRecord.fromJson(Map<String, dynamic> json) {
    return ReviewsRecord(
      id: json['id'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      ride: json['ride'],
      reviewer: json['reviewer'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  factory ReviewsRecord.fromRecordModel(_i2.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      ReviewsRecordFieldsEnum.id.name: recordModel.id,
      ReviewsRecordFieldsEnum.created.name: recordModel.created,
      ReviewsRecordFieldsEnum.updated.name: recordModel.updated,
      ReviewsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      ReviewsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return ReviewsRecord.fromJson(extendedJsonMap);
  }

  final String ride;

  final String reviewer;

  final int rating;

  static const ratingMinValue = 1;

  static const ratingMaxValue = 5;

  final String? comment;

  static const $collectionId = 'uyelt7qc6p07orx';

  static const $collectionName = 'reviews';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'collectionId': collectionId,
      'collectionName': collectionName,
      'ride': ride,
      'reviewer': reviewer,
      'rating': rating,
      'comment': comment,
    };
  }

  ReviewsRecord copyWith({
    String? ride,
    String? reviewer,
    int? rating,
    String? comment,
  }) {
    return ReviewsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      ride: ride ?? this.ride,
      reviewer: reviewer ?? this.reviewer,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> takeDiff(ReviewsRecord other) {
    final thisInJsonMap = toJson();
    final otherInJsonMap = other.toJson();
    final Map<String, dynamic> result = {};
    final _i3.DeepCollectionEquality deepCollectionEquality =
        _i3.DeepCollectionEquality();
    for (final mapEntry in thisInJsonMap.entries) {
      final thisValue = mapEntry.value;
      final otherValue = otherInJsonMap[mapEntry.key];
      if (!deepCollectionEquality.equals(
        thisValue,
        otherValue,
      )) {
        result.addAll({mapEntry.key: otherValue});
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        ride,
        reviewer,
        rating,
        comment,
      ];

  static Map<String, dynamic> forCreateRequest({
    required String ride,
    required String reviewer,
    required int rating,
    String? comment,
  }) {
    final jsonMap = ReviewsRecord(
      id: '',
      created: _i4.EmptyDateTime(),
      updated: _i4.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      ride: ride,
      reviewer: reviewer,
      rating: rating,
      comment: comment,
    ).toJson();
    final Map<String, dynamic> result = {};
    result.addAll({
      ReviewsRecordFieldsEnum.ride.name:
          jsonMap[ReviewsRecordFieldsEnum.ride.name]
    });
    result.addAll({
      ReviewsRecordFieldsEnum.reviewer.name:
          jsonMap[ReviewsRecordFieldsEnum.reviewer.name]
    });
    result.addAll({
      ReviewsRecordFieldsEnum.rating.name:
          jsonMap[ReviewsRecordFieldsEnum.rating.name]
    });
    if (comment != null) {
      result.addAll({
        ReviewsRecordFieldsEnum.comment.name:
            jsonMap[ReviewsRecordFieldsEnum.comment.name]
      });
    }
    return result;
  }
}
