import 'package:flutter/material.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/feature/dashboard/dashboard_widget.dart';
import 'package:sabay_ka/main.dart';
import 'package:sabay_ka/models/payments_record.dart';
import 'package:sabay_ka/models/rides_record.dart';
import 'package:sabay_ka/models/users_record.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/navigation.dart';
import 'package:gem_kit/routing.dart';
import 'package:gem_kit/sense.dart';
import 'bottom_navigation_panel.dart';
import 'top_navigation_panel.dart';
import 'utility.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Route, Animation;

class WatchRide extends StatefulWidget {
  const WatchRide({super.key, required this.rideId});

  final String rideId;

  @override
  State<WatchRide> createState() => _WatchRideState();
}

class _WatchRideState extends State<WatchRide> {
  late GemMapController _mapController;

  late NavigationInstruction currentInstruction;
  late RidesRecord ride;
  Map<String, UsersRecord> passengers = {};
  Map<String, PaymentsRecord> payments = {};
  Map<String, bool> isPassengerArrived = {};

  bool _areRoutesBuilt = false;
  bool _isNavigationActive = false;

  PermissionStatus _locationPermissionStatus = PermissionStatus.denied;
  bool _hasLiveDataSource = false;
  Coordinates? _currentLocation;

  // We use the handler to cancel the route calculation.
  TaskHandler? _routingHandler;

  // We use the handler to cancel the navigation.
  TaskHandler? _navigationHandler;

  @override
  void initState() {
    locator<PocketbaseService>().getRide(widget.rideId).then((fetchRide) {
      for (final booking in fetchRide.bookings!) {
        locator<PocketbaseService>().getUser(booking.passenger).then((user) {
          setState(() {
            passengers[booking.passenger] = user;
          });
        });
        locator<PocketbaseService>()
            .getPayment(booking.payment)
            .then((payment) {
          setState(() {
            payments[booking.payment] = payment;
          });
        });
        setState(() {
          isPassengerArrived[booking.passenger] = false;
        });
      }
      setState(() {
        ride = fetchRide;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    GemKit.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Navigate Route", style: TextStyle(color: Colors.white)),
        backgroundColor: CustomTheme.appColor,
        actions: [
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => SimpleDialog(
                          contentPadding: const EdgeInsets.all(20),
                          title: const Text(
                              'Which user you want to complete the ride with?',
                              style: TextStyle(color: Colors.black)),
                          children: ride.bookings!
                              .where((booking) =>
                                  !isPassengerArrived[booking.passenger]!)
                              .map((booking) {
                            return SimpleDialogOption(
                              onPressed: () async {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (_) => SimpleDialog(
                                            contentPadding:
                                                const EdgeInsets.all(20),
                                            title: const Text(
                                              'Confirm completion',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            children: [
                                              Text(
                                                  'PHP ${payments[booking.payment]!.amount}'),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    await locator<
                                                            PocketbaseService>()
                                                        .acceptPayment(
                                                            booking.id);
                                                    setState(() {
                                                      isPassengerArrived[booking
                                                          .passenger] = true;
                                                    });
                                                    if (isPassengerArrived
                                                        .values
                                                        .every((element) =>
                                                            element)) {
                                                      await locator<
                                                              PocketbaseService>()
                                                          .completeRide(
                                                              ride.id);
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        await Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const DashboardWidget()),
                                                        );
                                                      }
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Confirm'))
                                            ]));
                              },
                              child: Text(
                                  '${passengers[booking.passenger]!.firstName} ${passengers[booking.passenger]!.lastName}'),
                            );
                          }).toList(),
                        ));
              },
              child: Text('Complete')),
          if (!_isNavigationActive && _areRoutesBuilt)
            IconButton(
              onPressed: _startNavigation,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
            ),
          if (_isNavigationActive)
            IconButton(
              onPressed: _stopNavigation,
              icon: const Icon(
                Icons.stop,
                color: Colors.white,
              ),
            ),
          if (!_areRoutesBuilt)
            IconButton(
              onPressed: () => _onBuildRouteButtonPressed(context),
              icon: const Icon(
                Icons.route,
                color: Colors.white,
              ),
            ),
          if (!_isNavigationActive)
            IconButton(
                onPressed: _onFollowPositionButtonPressed,
                icon: const Icon(
                  Icons.location_searching_sharp,
                  color: Colors.white,
                ))
        ],
      ),
      body: Stack(children: [
        GemMap(
          onMapCreated: _onMapCreated,
        ),
        if (_isNavigationActive)
          Positioned(
            top: 10,
            left: 10,
            child: Column(children: [
              NavigationInstructionPanel(
                instruction: currentInstruction,
              ),
              const SizedBox(
                height: 10,
              ),
              FollowPositionButton(
                onTap: () => _mapController.startFollowingPosition(),
              ),
            ]),
          ),
        if (_isNavigationActive)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            left: 0,
            child: NavigationBottomPanel(
              remainingDistance:
                  currentInstruction.getFormattedRemainingDistance(),
              remainingDuration:
                  currentInstruction.getFormattedRemainingDuration(),
              eta: currentInstruction.getFormattedETA(),
            ),
          ),
      ]),
      resizeToAvoidBottomInset: false,
    );
  }

  // The callback for when map is ready to use.
  void _onMapCreated(GemMapController controller) {
    // Save controller for further usage.
    _mapController = controller;
    controller.startFollowingPosition();
    _getCurrentLocation();
  }

  void _onBuildRouteButtonPressed(BuildContext context) {
    if (_currentLocation == null) {
      _showSnackBar(context,
          message: 'Current location is needed to compute the route.',
          duration: const Duration(seconds: 3));
      return;
    }

    final landmarks = <Landmark>[
      Landmark.withCoordinates(_currentLocation!),
      ...ride.bookings!.map((booking) => Landmark.withLatLng(
          latitude: booking.destLat, longitude: booking.destLang))
    ];

    final markers = ride.bookings!
        .map((booking) => MarkerWithRenderSettings(
            MarkerJson(coords: [
              Coordinates(
                  latitude: booking.destLat, longitude: booking.destLang)
            ]),
            MarkerRenderSettings()))
        .toList();
    final settings = MarkerCollectionRenderSettings();
    _mapController.preferences.markers
        .addList(list: markers, settings: settings, name: 'Destinations');

    // Define the route preferences.
    final routePreferences =
        RoutePreferences(avoidTraffic: TrafficAvoidance.all);
    _showSnackBar(context, message: 'The route is calculating.');

    // Calling the calculateRoute SDK method.
    // (err, results) - is a callback function that gets called when the route computing is finished.
    // err is an error enum, results is a list of routes.
    _routingHandler = RoutingService.calculateRoute(landmarks, routePreferences,
        (err, routes) {
      // If the route calculation is finished, we don't have a progress listener anymore.
      _routingHandler = null;

      ScaffoldMessenger.of(context).clearSnackBars();

      if (err == GemError.routeTooLong) {
        debugPrint(
            'The destination is too far from your current location. Change the coordinates of the destination.');
        return;
      }

      // If there aren't any errors, we display the routes.
      if (err == GemError.success) {
        // Get the routes collection from map preferences.
        final routesMap = _mapController.preferences.routes;

        // Display the routes on map.
        for (final route in routes!) {
          routesMap.add(route, route == routes.first,
              label: route.getMapLabel());
        }

        // Center the camera on routes.
        _mapController.centerOnRoutes(routes: routes);
        setState(() {
          _areRoutesBuilt = true;
        });
      }
    });
  }

  void _startNavigation() {
    final routes = _mapController.preferences.routes;

    _navigationHandler = NavigationService.startNavigation(routes.mainRoute,
        (type, instruction) async {
      if (type == NavigationEventType.destinationReached ||
          type == NavigationEventType.error) {
        // If the navigation has ended or if and error occured while navigating, remove routes.
        setState(() {
          _isNavigationActive = false;
          _cancelRoute();
        });
        return;
      }
      _isNavigationActive = true;

      if (instruction != null) {
        setState(() => currentInstruction = instruction);
      }
    });

    // Set the camera to follow position.
    _mapController.startFollowingPosition();
  }

  void _cancelRoute() {
    // Remove the routes from map.
    _mapController.preferences.routes.clear();

    if (_routingHandler != null) {
      // Cancel the calculation of the route.
      RoutingService.cancelRoute(_routingHandler!);
      _routingHandler = null;
    }

    setState(() {
      _areRoutesBuilt = false;
    });
  }

  void _stopNavigation() {
    // Cancel the navigation.
    NavigationService.cancelNavigation(_navigationHandler!);
    _navigationHandler = null;

    _cancelRoute();

    setState(() => _isNavigationActive = false);
  }

  void _onFollowPositionButtonPressed() async {
    if (kIsWeb) {
      // On web platform permission are handled differently than other platforms.
      // The SDK handles the request of permission for location.
      _locationPermissionStatus = PermissionStatus.granted;
    } else {
      // For Android & iOS platforms, permission_handler package is used to ask for permissions.
      _locationPermissionStatus = await Permission.locationWhenInUse.request();
    }

    if (_locationPermissionStatus == PermissionStatus.granted) {
      // After the permission was granted, we can set the live data source (in most cases the GPS).
      // The data source should be set only once, otherwise we'll get -5 error.
      if (!_hasLiveDataSource) {
        PositionService.instance.setLiveDataSource();
        _getCurrentLocation();
        _hasLiveDataSource = true;
      }

      // After data source is set, startFollowingPosition can be safely called.
      // Optionally, we can set an animation
      final animation = GemAnimation(type: AnimationType.linear);

      // Calling the start following position SDK method.
      _mapController.startFollowingPosition(animation: animation);
    }
    setState(() {});
  }

  void _getCurrentLocation() {
    PositionService.instance.addPositionListener((pos) {
      _currentLocation = pos.coordinates;
    });
  }

  // Method to show message in case calculate route is not finished or if current location is not available.
  void _showSnackBar(BuildContext context,
      {required String message, Duration duration = const Duration(hours: 1)}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class FollowPositionButton extends StatelessWidget {
  const FollowPositionButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.navigation),
            Text(
              'Recenter',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
