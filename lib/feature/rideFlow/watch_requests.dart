import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nominatim_flutter/model/request/request.dart';
import 'package:nominatim_flutter/model/response/reverse_response.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:sabay_ka/app/text_style.dart';
import 'package:sabay_ka/common/widget/custom_button.dart';
import 'package:sabay_ka/feature/dashboard/dashboard_widget.dart';
import 'package:sabay_ka/feature/rideFlow/watch_ride.dart';
import 'package:sabay_ka/main.dart';
import 'package:sabay_ka/models/requests_record.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';
import 'package:flutter/material.dart' hide Route, Animation;

class WatchRequests extends StatefulWidget {
  const WatchRequests(
      {super.key, required this.rideId, required this.isFromTomasClaudio});

  final String rideId;
  final bool isFromTomasClaudio;

  @override
  State<WatchRequests> createState() => _WatchRequestsState();
}

class ExtendedRequest {
  final RequestsRecord request;
  final double price;
  final String destination;

  ExtendedRequest(
      {required this.request, required this.price, required this.destination});
}

class _WatchRequestsState extends State<WatchRequests> {
  late final StreamController<List<ExtendedRequest>> _controller =
      StreamController<List<ExtendedRequest>>(
    onListen: () async {
      // First fetch
      if (!_controller.isClosed) {
        final requests = await locator<PocketbaseService>()
            .getRequestsByRide(widget.rideId, widget.isFromTomasClaudio);
        final extendedRequests = await Future.wait(requests.map(
          (request) async {
            final reverseRequest = ReverseRequest(
              lat: request.destLat,
              lon: request.destLong,
              addressDetails: true,
              nameDetails: true,
            );

            final [price as double, reverseResult as NominatimResponse] =
                await Future.wait([
              locator<PocketbaseService>().getRequestPrice(
                  request.ride, request.destLat, request.destLong),
              NominatimFlutter.instance.reverse(reverseRequest: reverseRequest),
            ]);

            return ExtendedRequest(
                request: request,
                price: price,
                destination: reverseResult.displayName ?? "Can't determine");
          },
        ));
        _controller.add(extendedRequests);
      }

      // Listen to changes
      locator<PocketbaseService>().subscribeToRequests((event) async {
        if (!_controller.isClosed) {
          final requests = await locator<PocketbaseService>()
              .getRequestsByRide(widget.rideId, widget.isFromTomasClaudio);
          final extendedRequests = await Future.wait(requests.map(
            (request) async {
              final reverseRequest = ReverseRequest(
                lat: request.destLat,
                lon: request.destLong,
                addressDetails: true,
                nameDetails: true,
              );

              final [price as double, reverseResult as NominatimResponse] =
                  await Future.wait([
                locator<PocketbaseService>().getRequestPrice(
                    request.ride, request.destLat, request.destLong),
                NominatimFlutter.instance
                    .reverse(reverseRequest: reverseRequest),
              ]);

              return ExtendedRequest(
                  request: request,
                  price: price,
                  destination: reverseResult.displayName ?? "Can't determine");
            },
          ));
          _controller.add(extendedRequests);
        }
      });
    },
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    locator<PocketbaseService>().unsubscribeToRequests();
    super.dispose();
  }

  Stream<List<ExtendedRequest>> get _ride => _controller.stream;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: locator<PocketbaseService>().getRide(widget.rideId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: PoppinsTextStyles.headlineLargeRegular,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final ride = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Requests'),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () async {
                  await locator<PocketbaseService>().cancelRide(ride.id);
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardWidget(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: StreamBuilder<List<ExtendedRequest>>(
                    stream: _ride,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: PoppinsTextStyles.headlineLargeRegular,
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final extendedRequests = snapshot.data!
                          .where((element) =>
                              element.request.status ==
                              RequestsRecordStatusEnum.pending)
                          .toList();
                      final acceptedRequests = snapshot.data!
                          .where((element) =>
                              element.request.status ==
                              RequestsRecordStatusEnum.accepted)
                          .toList();
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                                'Accepted Requests: ${acceptedRequests.length}',
                                style: PoppinsTextStyles.headlineMediumRegular),
                            Text(
                                'Remaining Seats: ${ride.driver.vehicle['seatNumber'] - acceptedRequests.length}',
                                style: PoppinsTextStyles.headlineMediumRegular),
                            CustomRoundedButtom(
                                title: 'Start Ride',
                                onPressed: () async {
                                  // Reject unanswered requests and start ride
                                  await Future.wait([
                                    locator<PocketbaseService>()
                                        .startRide(ride.id),
                                    ...extendedRequests
                                        .where((request) =>
                                            request.request.status ==
                                            RequestsRecordStatusEnum.pending)
                                        .map((extendedRequest) =>
                                            locator<PocketbaseService>()
                                                .rejectRequest(
                                                    extendedRequest.request.id))
                                  ]);

                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WatchRide(rideId: ride.id),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                }),
                            SizedBox(height: 16),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: extendedRequests.length,
                                itemBuilder: (context, index) {
                                  final request =
                                      extendedRequests[index].request;
                                  final price = extendedRequests[index].price;
                                  final destination =
                                      extendedRequests[index].destination;

                                  return Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: Column(children: [
                                        Text(
                                            '${request.passenger.firstName} ${request.passenger.lastName}',
                                            style: PoppinsTextStyles
                                                .headlineMediumRegular),
                                        RichText(
                                          text: TextSpan(
                                              style: PoppinsTextStyles
                                                  .bodyMediumRegular,
                                              children: [
                                                TextSpan(
                                                    text: 'Destination: ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(text: destination),
                                              ]),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: PoppinsTextStyles
                                                .bodyMediumRegular,
                                            children: [
                                              TextSpan(
                                                  text: 'Price: ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      'PHP ${price.toStringAsFixed(2)}'),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: PoppinsTextStyles
                                                .bodyMediumRegular,
                                            children: [
                                              TextSpan(
                                                  text: 'Note: ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(text: request.note),
                                            ],
                                          ),
                                        ),
                                        Row(children: [
                                          FilledButton(
                                            child: Text('Accept'),
                                            onPressed: () async {
                                              await locator<PocketbaseService>()
                                                  .acceptRequest(request.id);
                                            },
                                          ),
                                          SizedBox(width: 16),
                                          FilledButton(
                                            child: Text('Reject'),
                                            onPressed: () async {
                                              await locator<PocketbaseService>()
                                                  .rejectRequest(request.id);
                                            },
                                          ),
                                        ]),
                                      ]));
                                }),
                          ],
                        ),
                      );
                    })),
          );
        });
  }
}
