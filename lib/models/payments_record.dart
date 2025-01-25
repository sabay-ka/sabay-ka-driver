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


enum PaymentsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  amount,
  method,
  status,
  booking,
}

enum PaymentsRecordMethodEnum {
  @JsonValue('cash')
  cash,
  @JsonValue('credit card')
  creditCard
}

enum PaymentsRecordStatusEnum {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed
}

@JsonSerializable()
final class PaymentsRecord extends _i1.BaseRecord {
  PaymentsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required this.amount,
    required this.method,
    required this.status,
    required this.booking,
  });

  factory PaymentsRecord.fromJson(Map<String, dynamic> json) {
    return PaymentsRecord(
      id: json['id'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      booking: json['booking'],
      amount: (json['amount'] as num).toDouble(),
      method: PaymentsRecordMethodEnum.values.firstWhere(
          (e) => e.toString() == 'PaymentsRecordMethodEnum.${json['method']}'),
      status: PaymentsRecordStatusEnum.values.firstWhere(
          (e) => e.toString() == 'PaymentsRecordStatusEnum.${json['status']}'),
    );
  }

  factory PaymentsRecord.fromRecordModel(_i2.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      PaymentsRecordFieldsEnum.id.name: recordModel.id,
      PaymentsRecordFieldsEnum.created.name: recordModel.created,
      PaymentsRecordFieldsEnum.updated.name: recordModel.updated,
      PaymentsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      PaymentsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return PaymentsRecord.fromJson(extendedJsonMap);
  }

  final double amount;

  final PaymentsRecordMethodEnum method;

  final PaymentsRecordStatusEnum status;

  final String booking;

  static const $collectionId = 'x1ty19tv5a0ujee';

  static const $collectionName = 'payments';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
      'collectionId': collectionId,
      'collectionName': collectionName,
      'amount': amount,
      'method': method,
      'status': status,
      'booking': booking,
    };
  }

  PaymentsRecord copyWith({
    double? amount,
    PaymentsRecordMethodEnum? method,
    PaymentsRecordStatusEnum? status,
    String? booking,
  }) {
    return PaymentsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      booking: booking ?? this.booking,
    );
  }

  Map<String, dynamic> takeDiff(PaymentsRecord other) {
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
        amount,
        method,
        status,
        booking,
      ];

  static Map<String, dynamic> forCreateRequest({
    required double amount,
    required PaymentsRecordMethodEnum method,
    required PaymentsRecordStatusEnum status,
    required String booking,
  }) {
    final jsonMap = PaymentsRecord(
      id: '',
      created: _i4.EmptyDateTime(),
      updated: _i4.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      amount: amount,
      method: method,
      status: status,
      booking: booking,
    ).toJson();
    final Map<String, dynamic> result = {};
    result.addAll({
      PaymentsRecordFieldsEnum.amount.name:
          jsonMap[PaymentsRecordFieldsEnum.amount.name]
    });
    result.addAll({
      PaymentsRecordFieldsEnum.method.name:
          jsonMap[PaymentsRecordFieldsEnum.method.name]
    });
    result.addAll({
      PaymentsRecordFieldsEnum.status.name:
          jsonMap[PaymentsRecordFieldsEnum.status.name]
    });
    result.addAll({
      PaymentsRecordFieldsEnum.booking.name:
          jsonMap[PaymentsRecordFieldsEnum.booking.name]
    });
    return result;
  }
}
