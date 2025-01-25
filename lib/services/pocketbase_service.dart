import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sabay_ka/common/widget/seat_widget.dart';
import 'package:sabay_ka/models/bookings_record.dart';
import 'package:sabay_ka/models/drivers_record.dart';
import 'package:sabay_ka/models/payments_record.dart';
import 'package:sabay_ka/models/requests_record.dart';
import 'package:sabay_ka/models/rides_record.dart';
import 'package:sabay_ka/models/users_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

abstract class PocketbaseService extends ChangeNotifier {
  late PocketBase _client;
  late String _baseUrl;
  DriversRecord? user;
  bool get isSignedIn => user != null;
  Future signInWithEmailAndPassword(
      {required String email, required String password});
  Future signInWithGoogle();
  void signOut();
  Future<void> signUpWithGoogle(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required XFile plateNumber,
      required List<XFile> vehicleImages,
      required String vehicleType});
  Future<List<RidesRecord>> getPreviousRides();
  Future<UsersRecord> getUser(String id);
  Future<RidesRecord> createRide(double parkLat, double parkLng, bool isFromTomasClaudio);
  Future<RidesRecord> getRide(String id);
  Future<void> cancelRide(String id);
  Future<void> startRide(String id);
  void subscribeToRide(String id, Function(RecordSubscriptionEvent) callback);
  Future<RidesRecord> getOngoingRide();
  void unsubscribeToRide(String id);
  Future<double> getRequestPrice(
      String rideId, double destLat, double destLong);
  Future<RequestsRecord> getRequest(String id);
  void subscribeToRequest(
      String id, Function(RecordSubscriptionEvent) callback);
  void unsubscribeToRequest(String id);
  Future<BookingsRecord> getBookingByRequest(String requestId);
  Future<PaymentsRecord> getPayment(String id);
  Future<void> subscribeToPayment(
      String id, Function(RecordSubscriptionEvent) callback);
  void unsubscribeToPayment(String id);
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<void> acceptPayment(String bookingId);
  Future<void> subscribeToRequests(Function(RecordSubscriptionEvent) callback);
  Future<void> unsubscribeToRequests();
  Future<List<RequestsRecord>> getRequestsByRide(String rideId, bool isFromTomasClaudio);
  Future<List<RequestsRecord>> getOngoingRequestsByRide(String rideId);
  Future<void> completeRide(String id);
  Future<List<RecordModel>> getDriverPayments();
  Future<List<BookingsRecord>> expandBookings(List<String> bookingIds);
}

class PocketbaseServiceImpl extends PocketbaseService {
  @override
  Future<List<BookingsRecord>> expandBookings(List<String> bookingIds) async {
    final bookings = await Future.wait(bookingIds.map((id) async {
      final booking = await _client.collection('bookings').getOne(id,
          expand: 'payment,passenger');
      return BookingsRecord.fromJson(booking.toJson(),
          booking.toJson()['expand']['payment'], booking.toJson()['expand']['passenger']);
    }));
    return bookings;
  }

  @override
  Future<UsersRecord> getUser(String id) async {
    final user = await _client.collection('users').getOne(id);
    return UsersRecord.fromJson(user.toJson());
  }

  @override
  Future<void> startRide(String id) async {
    await _client.collection('rides').update(id, body: {'status': 'ongoing'});
  }

  @override
  Future<void> cancelRide(String id) async {
    await _client.collection('rides').update(id, body: {'status': 'cancelled'});
  }

  @override
  Future<List<RecordModel>> getDriverPayments() async {
    return await _client
        .collection('driverPayments')
        .getFullList(filter: 'driver = "$user"');
  }

  @override
  Future<void> completeRide(String id) async {
    await _client
        .collection('rides')
        .update(id, body: {'status': 'completed'});
  }

  @override
  Future<List<RequestsRecord>> getOngoingRequestsByRide(String rideId) async {
    final requests = await _client.collection('requests').getFullList(
        filter: 'ride = "$rideId" && status = "ongoing"', expand: 'passenger');
    return requests
        .map((request) => RequestsRecord.fromJson(request.toJson()))
        .toList();
  }

  @override
  Future<List<RequestsRecord>> getRequestsByRide(String rideId, bool isFromTomasClaudio) async {
    final requests = await _client
        .collection('requests')
        .getFullList(filter: 'ride = "$rideId"', expand: 'passenger');
    return requests
        .map((request) => RequestsRecord.fromJson(request.toJson()))
        .toList();
  }

  @override
  Future<void> subscribeToRequests(
      Function(RecordSubscriptionEvent) callback) async {
    _client.collection('requests').subscribe('*', callback);
  }

  @override
  Future<void> unsubscribeToRequests() async {
    _client.collection('requests').unsubscribe('*');
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await http.post(
      Uri.parse('$_baseUrl/api/requests/$requestId/reject'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${_client.authStore.token}',
      },
    );
  }

  @override
  Future<void> acceptPayment(String bookingId) async {
    await http.post(Uri.parse('$_baseUrl/api/bookings/$bookingId/cash'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_client.authStore.token}',
        });
  }

  @override
  Future<String> acceptRequest(String requestId) async {
    final res = await http.post(
        Uri.parse('$_baseUrl/api/requests/$requestId/accept'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_client.authStore.token}',
        });
    return jsonDecode(res.body)['bookingId'];
  }

  @override
  Future<RidesRecord> getOngoingRide() async {
    if (user == null) {
      throw Exception('User is not signed in');
    }
    final ride = await _client.collection('rides').getFirstListItem(
        '(status = "ongoing" || status = "waiting" ) && driver = "${user!.id}"',
        expand: 'driver,bookings');
    return RidesRecord.fromJson(ride.toJson());
  }

  @override
  Future<RidesRecord> getRide(String id) async {
    final ride =
        await _client.collection('rides').getOne(id, expand: 'driver,bookings');
    return RidesRecord.fromJson(ride.toJson());
  }

  @override
  Future<RidesRecord> createRide(double parkLat, double parkLng, bool isFromTomasClaudio) async {
    final ride = await _client.collection('rides').create(body: {
      'parkingLat': parkLat,
      'parkingLng': parkLng,
      'driver': user!.id,
      'status': 'waiting',
      'isFromTomasClaudio': isFromTomasClaudio,
    }, expand: 'driver, bookings');
    return RidesRecord.fromJson(ride.toJson());
  }

  PocketbaseServiceImpl._create(String url, AsyncAuthStore authStore) {
    _client = PocketBase(url, authStore: authStore);
    _baseUrl = url;
    if (_client.authStore.model != null) {
      user = DriversRecord.fromJson(_client.authStore.model.toJson());
    } else {
      user = null;
    }

    _client.authStore.onChange.listen((AuthStoreEvent event) {
      if (event.model is RecordModel) {
        user = DriversRecord.fromJson(event.model.toJson());
      } else {
        user = null;
      }
    });
  }

  static Future<PocketbaseService> create() async {
    final String? baseUrl = dotenv.env['POCKETBASE_URL'];
    if (baseUrl == null) {
      throw Exception('POCKETBASE_URL is not set in .env');
    }

    final prefs = await SharedPreferences.getInstance();
    final authStore = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    return PocketbaseServiceImpl._create(baseUrl, authStore);
  }

  @override
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _client.collection('drivers').authWithPassword(email, password);
  }

  @override
  Future signInWithGoogle() async {
    await _client.collection('drivers').authWithOAuth2('google',
        (Uri uri) async {
      try {
        await launchUrl(uri,
            customTabsOptions: CustomTabsOptions(
              showTitle: true,
              urlBarHidingEnabled: true,
            ));
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  Future<void> signUpWithGoogle(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required XFile plateNumber,
      required List<XFile> vehicleImages,
      required String vehicleType}) async {
    final parsedVehicleImages =
        await Future.wait(vehicleImages.map((image) async {
      return http.MultipartFile.fromBytes(
          'vehicleImages', await image.readAsBytes(),
          filename: image.name);
    }));

    String vehicle;
    if (vehicleType == 'Car') {
      vehicle = jsonEncode({
        'seatNumber': 5,
        'rows': 2,
        'cols': 3,
        'seats': [
          [
            SeatState.unselected.index,
            SeatState.unselected.index,
            SeatState.unselected.index,
          ],
          [
            SeatState.unselected.index,
            SeatState.empty.index,
            SeatState.unselected.index
          ]
        ]
      });
    } else if (vehicleType == 'Tricycle') {
      vehicle = jsonEncode({
        'seatNumber': 3,
        'rows': 2,
        'cols': 3,
        'seats': [
          [
            SeatState.unselected.index,
            SeatState.unselected.index,
            SeatState.unselected.index,
          ],
          [
            SeatState.empty.index,
            SeatState.empty.index,
            SeatState.disabled.index,
          ]
        ]
      });
    } else {
      // UV
      vehicle = jsonEncode({
        'seatNumber': 8,
        'rows': 4,
        'cols': 3,
        'seats': [
          [
            SeatState.unselected.index,
            SeatState.unselected.index,
            SeatState.unselected.index,
          ],
          [
            SeatState.empty.index,
            SeatState.unselected.index,
            SeatState.unselected.index,
          ],
          [
            SeatState.empty.index,
            SeatState.unselected.index,
            SeatState.unselected.index,
          ],
          [
            SeatState.unselected.index,
            SeatState.unselected.index,
            SeatState.disabled.index,
          ]
        ]
      });
    }

    final res = await _client.collection('drivers').authWithOAuth2('google',
        (Uri uri) async {
      try {
        await launchUrl(uri,
            customTabsOptions: CustomTabsOptions(
              showTitle: true,
              urlBarHidingEnabled: true,
            ));
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }, createData: {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'vehicle': vehicle,
      'emailVisibility': true,
    });

    // Upload vehicle images and plate number
    await _client.collection('drivers').update(res.record!.id, files: [
      http.MultipartFile.fromBytes(
          'plateNumber', await plateNumber.readAsBytes(),
          filename: plateNumber.name),
      ...parsedVehicleImages,
    ]);
  }

  @override
  void signOut() {
    _client.authStore.clear();
  }

  @override
  Future<List<RidesRecord>> getPreviousRides() async {
    if (user == null) {
      throw Exception('User is not signed in');
    }
    final rides = await _client.collection('rides').getFullList(
        filter: 'status = "completed" && driver = "${user!.id}"',
        expand: 'driver');
    return rides.map((ride) => RidesRecord.fromJson(ride.toJson())).toList();
  }

  @override
  void subscribeToRide(String id, Function(RecordSubscriptionEvent) callback) {
    _client.collection('rides').subscribe(id, callback);
  }

  @override
  void unsubscribeToRide(String id) {
    _client.collection('rides').unsubscribe(id);
  }

  @override
  Future<double> getRequestPrice(
      String rideId, double destLat, double destLong) async {
    final res = await http.get(
      Uri.parse(
          '$_baseUrl/api/rides/$rideId/price?destLat=$destLat&destLng=$destLong'),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to get price');
    }

    return jsonDecode(res.body)["amount"] as double;
  }

  @override
  Future<RequestsRecord> getRequest(String id) async {
    final request =
        await _client.collection('requests').getOne(id, expand: 'passenger');
    return RequestsRecord.fromJson(request.toJson());
  }

  @override
  void subscribeToRequest(
      String id, Function(RecordSubscriptionEvent p1) callback) {
    _client.collection('requests').subscribe(id, callback);
  }

  @override
  void unsubscribeToRequest(String id) {
    _client.collection('requests').unsubscribe(id);
  }

  @override
  Future<BookingsRecord> getBookingByRequest(String requestId) async {
    final booking = await _client
        .collection('bookings')
        .getFirstListItem('request = "$requestId"', expand: 'payment');
    return BookingsRecord.fromJson(
        booking.toJson(), booking.toJson()['expand']['payment']);
  }

  @override
  Future<void> subscribeToPayment(
      String id, Function(RecordSubscriptionEvent p1) callback) async {
    _client.collection('payments').subscribe(id, callback);
  }

  @override
  Future<void> unsubscribeToPayment(String id) async {
    _client.collection('payments').unsubscribe(id);
  }

  @override
  Future<PaymentsRecord> getPayment(String id) async {
    final payment = await _client.collection('payments').getOne(id);
    debugPrint(payment.toString());
    return PaymentsRecord.fromJson(payment.toJson());
  }
}
