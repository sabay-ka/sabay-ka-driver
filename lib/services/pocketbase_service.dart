import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sabay_ka/models/bookings_record.dart';
import 'package:sabay_ka/models/payments_record.dart';
import 'package:sabay_ka/models/requests_record.dart';
import 'package:sabay_ka/models/reviews_record.dart';
import 'package:sabay_ka/models/rides_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sabay_ka/models/users_record.dart';

abstract class PocketbaseService extends ChangeNotifier {
  late PocketBase _client;
  UsersRecord? user;
  bool get isSignedIn => user != null;
  Future signInWithEmailAndPassword({required String email, required String password});
  Future signInWithGoogle();
  void signOut();
  Future<void> signUpWithGoogle({ required String firstName, required String lastName, required String phoneNumber });
  Future<List<RidesRecord>> getRides();
  Future<RidesRecord> getRide(String id);
  void subscribeToRides(Function(RecordSubscriptionEvent) callback);
  void unsubscribeToRides();
  void subscribeToRide(String id, Function(RecordSubscriptionEvent) callback);
  void unsubscribeToRide(String id);
  Future<List<ReviewsRecord>> getReviewsByDriver(String driverId);
  Future<RequestsRecord> createRequest({required String rideId, required double destLat, required double destLong, required int rowIdx, required int columnIdx});
  void subscribeToRequest(String id, Function(RecordSubscriptionEvent) callback);
  void unsubscribeToRequest(String id);
  Future<RequestsRecord> cancelRequest(String id);
  Future<BookingsRecord> getBookingByRequest(String requestId);
  Future<BookingsRecord> getUserBookings();
  Future<ReviewsRecord> createReview({required String bookingId, required String content, required double rating});
  Future<void> deleteReview(String reviewId);
  Future<List<PaymentsRecord>> getUserPayments();
}


class PocketbaseServiceImpl extends PocketbaseService {
  PocketbaseServiceImpl._create(String url, AsyncAuthStore authStore) {
    _client = PocketBase(url, authStore: authStore);
    if (_client.authStore.model != null) {
      user = UsersRecord.fromJson(_client.authStore.model.toJson());
    } else {
      user = null;
    }

    _client.authStore.onChange.listen((AuthStoreEvent event) {
      if (event.model is RecordModel) {
        user = UsersRecord.fromJson(event.model.toJson());
      } else {
        user = null;
      }
    });
  }

  static Future<PocketbaseService> create() async {
    final String? baseUrl = FlutterConfig.get('POCKETBASE_URL');
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
    Future signInWithEmailAndPassword({required String email, required String password}) async {
      await _client.collection('users').authWithPassword(email, password);
    }

  @override
    Future signInWithGoogle() async {
      await _client.collection('users').authWithOAuth2('google', (Uri uri) async {
        try {
          await launchUrl(uri, customTabsOptions: CustomTabsOptions(
            showTitle: true,
            urlBarHidingEnabled: true,
          ));
        } on Exception catch (e) {
          debugPrint(e.toString());
        }
      });
    }

  @override
    Future<void> signUpWithGoogle({required String firstName, required String lastName, required String phoneNumber}) async {
      await _client.collection('users').authWithOAuth2('google', (Uri uri) async {
        try {
          await launchUrl(uri, customTabsOptions: CustomTabsOptions(
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
      });
    }

  @override
    void signOut() {
      _client.authStore.clear();
    }

  @override
    Future<List<RidesRecord>> getRides() async {
      final rides = await _client.collection('rides').getFullList(expand: 'driver');
      return rides.map((ride) => RidesRecord.fromJson(ride.toJson())).toList();
    }

  @override
    Future<RidesRecord> getRide(String id) async {
      final ride = await _client.collection('rides').getOne(id, expand: 'driver'); 
      return RidesRecord.fromJson(ride.toJson());
    }

  @override
    void subscribeToRides(Function(RecordSubscriptionEvent) callback) {
      _client.collection('rides').subscribe("*", callback);  
    }

  @override
    void unsubscribeToRides() {
      _client.collection('rides').unsubscribe("*");
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
    Future<List<ReviewsRecord>> getReviewsByDriver(String driverId) async {
      final reviews = await _client.collection('driverReviews').getFullList(filter: 'driver = "$driverId"');
      return reviews.map((review) => ReviewsRecord.fromJson(review.toJson())).toList();
    }

  @override
    Future<RequestsRecord> createRequest({required String rideId, required double destLat, required double destLong, required int rowIdx, required int columnIdx}) async {
      if (user == null) {
        throw Exception('User is not signed in');
      }
      final request = await _client.collection('requests').create(body: {
        'ride': rideId,
        'passenger': user?.id,
        'destLat': destLat,
        'destLong': destLong,
        'rowIdx': rowIdx,
        'columnIdx': columnIdx,
        'status': 'pending',
      });
      return RequestsRecord.fromJson(request.toJson());
    }

  @override
    Future<RequestsRecord> cancelRequest(String id) async {
      final request = await _client.collection('requests').update(id, body: {
        'status': 'cancelled',
      });
      return RequestsRecord.fromJson(request.toJson());
    }

  @override
    void subscribeToRequest(String id, Function(RecordSubscriptionEvent p1) callback) {
      _client.collection('requests').subscribe(id, callback);
    }

  @override 
    void unsubscribeToRequest(String id) {
      _client.collection('requests').unsubscribe(id);
    }

  @override
    Future<BookingsRecord> getBookingByRequest(String requestId) async {
      final booking = await _client.collection('bookings').getFirstListItem('request = "$requestId"', expand: 'payment');
      return BookingsRecord.fromJson(booking.toJson());
    }

  @override
    Future<BookingsRecord> getUserBookings() async {
      final bookings = await _client.collection('bookings').getFullList(filter: 'passenger = "${user?.id}"');
      return bookings.map((booking) => BookingsRecord.fromJson(booking.toJson())).first;
    }

  @override
    Future<ReviewsRecord> createReview({required String bookingId, required String content, required double rating}) async {
      if (user == null) {
        throw Exception('User is not signed in');
      }

      final review = await _client.collection('reviews').create(body: {
        'booking': bookingId,
        'reviewer': user?.id,
        'rating': rating,
        'comment': content,
      });
      return ReviewsRecord.fromJson(review.toJson());
    }

  @override
    Future<void> deleteReview(String reviewId) async {
      return await _client.collection('reviews').delete(reviewId);
    }

  @override
    Future<List<PaymentsRecord>> getUserPayments() async {
      if (user == null) {
        throw Exception('User is not signed in');
      }

      final payments = await _client.collection('userPayments').getFullList(filter: 'user = "${user?.id}"');
      return payments.map((payment) => PaymentsRecord.fromJson(payment.toJson())).toList();
    }
}
