// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// Route result
///
/// {@category Routes & Navigation}
enum RouteResultType {
  /// Path route result type - navigable route.
  path,

  /// Route range ( Isochrone ) result type - reachable area within a range of travel costs.
  range,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteResultTypeExtension on RouteResultType {
  int get id {
    switch (this) {
      case RouteResultType.path:
        return 0;
      case RouteResultType.range:
        return 1;
    }
  }

  static RouteResultType fromId(int id) {
    switch (id) {
      case 0:
        return RouteResultType.path;
      case 1:
        return RouteResultType.range;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Route type
///
/// {@category Routes & Navigation}
enum RouteType {
  /// Route type - fastest - default route type.
  fastest,

  /// Route type - shortest route type.
  shortest,

  /// Route type - economical route type.
  economic,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteTypeExtension on RouteType {
  int get id {
    switch (this) {
      case RouteType.fastest:
        return 0;
      case RouteType.shortest:
        return 1;
      case RouteType.economic:
        return 2;
    }
  }

  static RouteType fromId(int id) {
    switch (id) {
      case 0:
        return RouteType.fastest;
      case 1:
        return RouteType.shortest;
      case 2:
        return RouteType.economic;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Transport mode
///
/// {@category Routes & Navigation}
enum RouteTransportMode {
  /// Transport mode - car.
  car,

  /// Transport mode - lorry/truck.
  lorry,

  /// Transport mode - on foot.
  pedestrian,

  /// Transport mode - bike.
  bicycle,

  /// Transport mode - public transport.
  public,

  /// Transport mode - shared vehicles.
  sharedVehicles,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteTransportModeExtension on RouteTransportMode {
  int get id {
    switch (this) {
      case RouteTransportMode.car:
        return 0;
      case RouteTransportMode.lorry:
        return 1;
      case RouteTransportMode.pedestrian:
        return 2;
      case RouteTransportMode.bicycle:
        return 3;
      case RouteTransportMode.public:
        return 4;
      case RouteTransportMode.sharedVehicles:
        return 5;
    }
  }

  static RouteTransportMode fromId(int id) {
    switch (id) {
      case 0:
        return RouteTransportMode.car;
      case 1:
        return RouteTransportMode.lorry;
      case 2:
        return RouteTransportMode.pedestrian;
      case 3:
        return RouteTransportMode.bicycle;
      case 4:
        return RouteTransportMode.public;
      case 5:
        return RouteTransportMode.sharedVehicles;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic avoidance options
///
/// {@category Routes & Navigation}
enum TrafficAvoidance {
  /// Disable traffic avoidance.
  none,

  /// Avoid all traffic events: congestions and roadblocks.
  all,

  /// Avoid only roadblock traffic events.
  roadblocks,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficAvoidanceExtension on TrafficAvoidance {
  int get id {
    switch (this) {
      case TrafficAvoidance.none:
        return 0;
      case TrafficAvoidance.all:
        return 1;
      case TrafficAvoidance.roadblocks:
        return 2;
    }
  }

  static TrafficAvoidance fromId(int id) {
    switch (id) {
      case 0:
        return TrafficAvoidance.none;
      case 1:
        return TrafficAvoidance.all;
      case 2:
        return TrafficAvoidance.roadblocks;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Bike profile
///
/// {@category Routes & Navigation}
enum BikeProfile {
  /// Bike profile - road.
  road,

  /// Bike profile - cross.
  cross,

  /// Bike profile - city.
  city,

  /// Bike profile - mountain.
  mountain,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension BikeProfileExtension on BikeProfile {
  int get id {
    switch (this) {
      case BikeProfile.road:
        return 0;
      case BikeProfile.cross:
        return 1;
      case BikeProfile.city:
        return 2;
      case BikeProfile.mountain:
        return 3;
    }
  }

  static BikeProfile fromId(int id) {
    switch (id) {
      case 0:
        return BikeProfile.road;
      case 1:
        return BikeProfile.cross;
      case 2:
        return BikeProfile.city;
      case 3:
        return BikeProfile.mountain;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// eBike type
///
/// {@category Routes & Navigation}
enum ElectricBikeType {
  /// Electric bike type - none.
  none,

  /// Electric bike type - pedelec.
  pedelec,

  /// Electric bike type - power on demand.
  powerOnDemand,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension ElectricBikeTypeExtension on ElectricBikeType {
  int get id {
    switch (this) {
      case ElectricBikeType.none:
        return 0;
      case ElectricBikeType.pedelec:
        return 1;
      case ElectricBikeType.powerOnDemand:
        return 2;
    }
  }

  static ElectricBikeType fromId(int id) {
    switch (id) {
      case 0:
        return ElectricBikeType.none;
      case 1:
        return ElectricBikeType.pedelec;
      case 2:
        return ElectricBikeType.powerOnDemand;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Pedestrian profile
///
/// {@category Routes & Navigation}
enum PedestrianProfile {
  /// Pedestrian profile - walk.
  walk,

  /// Pedestrian profile - hike.
  hike,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension PedestrianProfileExtension on PedestrianProfile {
  int get id {
    switch (this) {
      case PedestrianProfile.walk:
        return 0;
      case PedestrianProfile.hike:
        return 1;
    }
  }

  static PedestrianProfile fromId(int id) {
    switch (id) {
      case 0:
        return PedestrianProfile.walk;
      case 1:
        return PedestrianProfile.hike;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Routing result details
///
/// {@category Routes & Navigation}
enum RouteResultDetails {
  /// Path and guidance
  full,

  /// Path time / distance only
  timeDistance,

  /// Path time / distance and geometry
  path,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteResultDetailsExtension on RouteResultDetails {
  int get id {
    switch (this) {
      case RouteResultDetails.full:
        return 0;
      case RouteResultDetails.timeDistance:
        return 1;
      case RouteResultDetails.path:
        return 2;
    }
  }

  static RouteResultDetails fromId(int id) {
    switch (id) {
      case 0:
        return RouteResultDetails.full;
      case 1:
        return RouteResultDetails.timeDistance;
      case 2:
        return RouteResultDetails.path;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Alternative routes scheme
///
/// {@category Routes & Navigation}
enum RouteAlternativesSchema {
  /// Alternative routes scheme - Service default - depending on selected transport, route type & result details
  defaultSchema,

  /// Alternative routes scheme - never
  never,

  /// Alternative routes scheme - always ( even if not recommended, e.g. for shortest etc )
  always,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteAlternativesSchemaExtension on RouteAlternativesSchema {
  int get id {
    switch (this) {
      case RouteAlternativesSchema.defaultSchema:
        return 0;
      case RouteAlternativesSchema.never:
        return 1;
      case RouteAlternativesSchema.always:
        return 2;
    }
  }

  static RouteAlternativesSchema fromId(int id) {
    switch (id) {
      case 0:
        return RouteAlternativesSchema.defaultSchema;
      case 1:
        return RouteAlternativesSchema.never;
      case 2:
        return RouteAlternativesSchema.always;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Path calculation algorithm
/// {@category Routes & Navigation}
enum RoutePathAlgorithm {
  /// Path calculation algorithm - Service default - Magic Lane routing algorithm
  me,

  /// Path calculation algorithm - External CH routing algorithm
  externalCH,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension RoutePathAlgorithmExtension on RoutePathAlgorithm {
  int get id {
    switch (this) {
      case RoutePathAlgorithm.me:
        return 0;
      case RoutePathAlgorithm.externalCH:
        return 1;
    }
  }

  static RoutePathAlgorithm fromId(int id) {
    switch (id) {
      case 0:
        return RoutePathAlgorithm.me;
      case 1:
        return RoutePathAlgorithm.externalCH;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Bike and Electric bike routing profile
/// 
/// {@category Routes & Navigation}
class BikeProfileElectricBikeProfile {
  /// Selected bike profile.
  /// Default is [BikeProfile.city].
  BikeProfile? profile;

  /// Selected e-bike profile.
  ElectricBikeProfile? eProfile;

  BikeProfileElectricBikeProfile({this.profile, this.eProfile});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (profile != null) {
      json['profile'] = profile!.id;
    }
    if (eProfile != null) {
      json['eprofile'] = eProfile;
    }
    return json;
  }

  factory BikeProfileElectricBikeProfile.fromJson(Map<String, dynamic> json) {
    return BikeProfileElectricBikeProfile(
      profile: BikeProfileExtension.fromId(json['profile']),
      eProfile: json['eprofile'] is ElectricBikeProfile
          ? json['eprofile'] as ElectricBikeProfile
          : ElectricBikeProfile.fromJson(json['eprofile']),
    );
  }

  @override
  bool operator ==(covariant BikeProfileElectricBikeProfile other) {
    return other.profile == profile && other.eProfile == eProfile;
  }

  @override
  int get hashCode => profile.hashCode ^ eProfile.hashCode;
}

/// Preferences regarding building terrain profile 
/// 
/// {@category Routes & Navigation}
class BuildTerrainProfile {
  /// Enable / disable terrain profile build
  /// Default is false
  final bool? enable;

  /// The minimum elevation variation to be registered for total up / total down statistics
  /// A value < 0 lets the SDK to choose a proper value
  /// Default is 0
  final double minVariation;

  const BuildTerrainProfile({this.enable, this.minVariation = -1});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (enable != null) {
      json['b'] = enable;
    }
    if (enable != null) {
      json['minVariation'] = minVariation;
    }
    return json;
  }

  factory BuildTerrainProfile.fromJson(Map<String, dynamic> json) {
    return BuildTerrainProfile(enable: json['b'], minVariation: json['minVariation']);
  }

  @override
  bool operator ==(covariant BuildTerrainProfile other) {
    return other.enable == enable && other.minVariation == minVariation;
  }

  @override
  int get hashCode => enable.hashCode ^ minVariation.hashCode;
}

/// Departure heading
///
/// {@category Routes & Navigation}
class DepartureHeading {
  /// The departure heading in degrees.
  ///
  /// Values are in 0 - 360 interval with 0 representing the magnetic north.
  /// Value -1 means no departure heading is specified
  final double heading;

  /// The departure heading accuracy, in degrees.
  /// Values are in 0 - 90 interval. A typical value is 25 degrees
  final double accuracy;

  const DepartureHeading({
    this.heading = -1,
    this.accuracy = -1,
  });

  factory DepartureHeading.fromJson(Map<String, dynamic> json) {
    return DepartureHeading(
      heading: json['first'],
      accuracy: json['second'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': heading,
      'second': accuracy,
    };
  }

  @override
  bool operator ==(covariant DepartureHeading other) {
    return other.heading == heading && other.accuracy == accuracy;
  }

  @override
  int get hashCode => heading.hashCode ^ accuracy.hashCode;
}

/// Route preferences - contains the preferences used for route calculation.
///
/// {@category Routes & Navigation}
class RoutePreferences {
  /// Track accurate match.
  bool accurateTrackMatch;

  /// Enable/disable alternative routes balanced sorting.
  bool alternativeRoutesBalancedSorting;

  /// Alternative schema.
  RouteAlternativesSchema? alternativesSchema;

  /// Timestamp automatic mode.
  /// For public transit routes the departure timestamp is set to the local time of the departing waypoint
  bool automaticTimestamp;

  /// Avoid biking hill factor 0.f - no avoidance, 1.f - full avoidance.
  /// Default is 0.5
  double avoidBikingHillFactor;

  /// Avoid carpool lanes flag.
  /// Default is false.
  bool avoidCarpoolLanes;

  /// Avoid ferries flag.
  /// Default is false.
  bool avoidFerries;

  /// Avoid motorways flag.
  /// Default is false.
  bool avoidMotorways;

  /// Avoid toll roads flag.
  /// Default is false.
  bool avoidTollRoads;

  /// Route calculation traffic avoidance method.
  /// Default is [TrafficAvoidance.none]
  TrafficAvoidance avoidTraffic;

  /// Avoid turnaround instruction flag.
  ///
  /// If set to true then the message "Turnaround when possible" will be avoided during navigation.
  /// This preference is always overridden in car / truck navigation route recalculations, in which case the current
  /// driving direction is used, except for the case when emergency mode is activated.
  ///
  /// For car / truck this preference is used when setting a user roadblock during navigation.
  /// If set to false, a turn around instruction may be generated
  ///
  /// Default is true for car/truck transport modes and false for the rest
  /// If emergency mode is active, default value is always false
  bool avoidTurnAroundInstruction;

  /// Avoid unpaved roads flag.
  /// Default is false.
  bool avoidUnpavedRoads;

  /// Bike profile.
  BikeProfileElectricBikeProfile? bikeProfile;

  /// Build terrain profile.
  BuildTerrainProfile buildTerrainProfile;

  /// Car profile.
  CarProfile? carProfile;

  /// The departure heading.
  DepartureHeading departureHeading;

  /// The extra freedom levels for emergency vehicles, packed in an integer value.
  int emergencyVehicleExtraFreedomLevels;

  /// The emergency vehicle mode, true for activation
  /// Emergency mode set the default AvoidTurnAroundInstruction setting to false also for car/truck
  /// Emergency mode enables access to emergency dedicated links and enables a more relaxed routing set of constraints
  bool emergencyVehicleMode;

  /// The EV profile
  EVProfile? evProfile;

  /// The ignore map restrictions in route-over-track mode.
  bool ignoreRestrictionsOverTrack;

  /// Service maximum distance constraint.
  /// Maximum distance constraint depends on transport and result details. Default is active
  bool maximumDistanceConstraint;

  /// Maximum transfer time in minutes
  /// Refers to the transfer time between two means of transportation.
  ///
  /// Enable the user to specify the desired maximum amount of minutes between the arrival of one means of
  /// transportation and the departure of the next one.
  ///
  /// Default is 300.
  int maximumTransferTimeInMinutes;

  /// Maximum walk distance.
  /// Default is 4000.
  int maximumWalkDistance;

  /// Get minimum transfer time in minutes.
  /// Refers to the transfer time between two means of transportation.
  ///
  /// Enable the user to specify the desired minimum amount of minutes between the arrival of one means of
  /// transportation and the departure of the next one.
  ///
  /// Default is 0.
  int minimumTransferTimeInMinutes;

  /// Path algorithm.
  /// Default is [RoutePathAlgorithm.me]
  RoutePathAlgorithm pathAlgorithm;

  /// Pedestrian profile.
  PedestrianProfile? pedestrianProfile;

  /// Result details.
  /// Default is [RouteResultDetails.full]
  RouteResultDetails? resultDetails;

  /// Route ranges list.
  /// Range units depend on route type: [RouteType.fastest] - seconds, [RouteType.shortest] - meters, [RouteType.economic] - Wh
  List<int> routeRanges;

  /// Range result quality must a valid integer in the 0 - 100 range, where 0 = lowest quality, 100 = highest quality
  /// Default is 100 (max quality)
  int routeRangesQuality;

  /// Route result type.
  /// Default is [RouteResultType.path]
  RouteResultType? routeResultType;

  /// The route type.
  /// Default is [RouteType.fastest]
  RouteType? routeType;

  /// Route type preferences.
  /// Default is 0 - no special preference for one route type
  int? routeTypePreferences;

  /// Strict track follow mode ( route-over-track case )
  /// Default is false
  @Deprecated('This preferences is no longer used')
  bool strictTrackFollow;

  /// The timestamp.
  /// Get departure timestamp.
  DateTime? timestamp;

  /// Route transport mode.
  /// Default is [RouteTransportMode.car]
  RouteTransportMode transportMode;

  /// Truck profile.
  TruckProfile? truckProfile;

  /// Group ids for earlier/later trip.
  dynamic routeGroupIdsEarlierLater;

  /// Option toggle to use bike.
  /// Default is false
  bool useBikes;

  /// Option toggle to use wheelchair.
  /// Default is false
  bool useWheelchair;

  RoutePreferences({
    this.accurateTrackMatch = true,
    this.alternativeRoutesBalancedSorting = true,
    this.alternativesSchema = RouteAlternativesSchema.defaultSchema,
    this.automaticTimestamp = true,
    this.avoidBikingHillFactor = 0.5,
    this.avoidCarpoolLanes = false,
    this.avoidFerries = false,
    this.avoidMotorways = false,
    this.avoidTollRoads = false,
    this.avoidTraffic = TrafficAvoidance.none,
    this.avoidTurnAroundInstruction = false,
    this.avoidUnpavedRoads = false,
    this.bikeProfile,
    this.buildTerrainProfile = const BuildTerrainProfile(enable: false),
    this.carProfile,
    this.departureHeading = const DepartureHeading(heading: -1, accuracy: -1),
    this.emergencyVehicleExtraFreedomLevels = 0,
    this.emergencyVehicleMode = false,
    this.evProfile,
    this.ignoreRestrictionsOverTrack = false,
    this.maximumDistanceConstraint = true,
    this.maximumTransferTimeInMinutes = 300,
    this.maximumWalkDistance = 5000,
    this.minimumTransferTimeInMinutes = 1,
    this.pathAlgorithm = RoutePathAlgorithm.me,
    this.pedestrianProfile,
    this.resultDetails,
    this.routeGroupIdsEarlierLater,
    this.routeRanges = const [],
    this.routeRangesQuality = 100,
    this.routeResultType,
    this.routeType,
    this.routeTypePreferences,
    this.strictTrackFollow = true,
    this.timestamp,
    this.transportMode = RouteTransportMode.car,
    this.truckProfile,
    this.useBikes = false,
    this.useWheelchair = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['accuratetrackmatch'] = accurateTrackMatch;

    json['alternativeroutesbalancedsorting'] = alternativeRoutesBalancedSorting;

    if (alternativesSchema != null) {
      json['alternativesschema'] = alternativesSchema!.id;
    }

    json['automatictimestamp'] = automaticTimestamp;

    json['avoidbikinghillFactor'] = avoidBikingHillFactor;

    json['avoidcarpoollanes'] = avoidCarpoolLanes;

    json['avoidferries'] = avoidFerries;

    json['avoidmotorways'] = avoidMotorways;

    json['avoidtollroads'] = avoidTollRoads;

    json['avoidtraffic'] = avoidTraffic.id;

    json['avoidturnaroundinstruction'] = avoidTurnAroundInstruction;

    json['avoidunpavedroads'] = avoidUnpavedRoads;

    if (bikeProfile != null) {
      json['bikeprofile'] = bikeProfile;
    }

    json['buildterrainprofile'] = buildTerrainProfile;

    if (carProfile != null) {
      json['carprofile'] = carProfile;
    }

    json['departureheading'] = departureHeading;
    json['emergencyVehicleMode'] = <String, dynamic>{};
    json['emergencyVehicleMode']['extraFreedom'] = emergencyVehicleExtraFreedomLevels;
    json['emergencyVehicleMode']['enable'] = emergencyVehicleMode;

    if (evProfile != null) {
      json['evprofile'] = evProfile;
    }

    json['ignorerestrictionsovertrack'] = ignoreRestrictionsOverTrack;

    json['maximumdistanceconstraint'] = maximumDistanceConstraint;

    json['maximumtransfertimeInminutes'] = maximumTransferTimeInMinutes;

    json['maximumwalkdistance'] = maximumWalkDistance;

    json['minimumtransfertimeInminutes'] = minimumTransferTimeInMinutes;

    json['pathalgorithm'] = pathAlgorithm.id;

    if (pedestrianProfile != null) {
      json['pedestrianprofile'] = pedestrianProfile!.id;
    }
    if (resultDetails != null) {
      json['resultdetails'] = resultDetails!.id;
    }
    if (routeGroupIdsEarlierLater != null) {
      json['routegroupidsearlierlater'] = routeGroupIdsEarlierLater;
    }
    json['routeranges'] = <String, dynamic>{};
    json['routeranges']['list'] = routeRanges;
    json['routeranges']['quality'] = routeRangesQuality;

    if (routeResultType != null) {
      json['routeresulttype'] = routeResultType!.id;
    }
    if (routeType != null) {
      json['routetype'] = routeType!.id;
    }
    if (routeTypePreferences != null) {
      json['routetypepreferences'] = routeTypePreferences;
    }

    json['stricttrackfollow'] = strictTrackFollow;

    if (timestamp != null) {
      json['timestamp'] = timestamp!.millisecondsSinceEpoch;
    }

    json['transportmode'] = transportMode.id;

    if (truckProfile != null) {
      json['truckprofile'] = truckProfile;
    }

    json['usebikes'] = useBikes;

    json['usewheelchair'] = useWheelchair;

    return json;
  }

  factory RoutePreferences.fromJson(Map<String, dynamic> json) {
    return RoutePreferences(
      accurateTrackMatch: json['accuratetrackmatch'],
      alternativeRoutesBalancedSorting: json['alternativeroutesbalancedsorting'],
      alternativesSchema: RouteAlternativesSchemaExtension.fromId(json['alternativesschema']),
      automaticTimestamp: json['automatictimestamp'],
      avoidBikingHillFactor: json['avoidbikinghillFactor'],
      avoidCarpoolLanes: json['avoidcarpoollanes'],
      avoidFerries: json['avoidferries'],
      avoidMotorways: json['avoidmotorways'],
      avoidTollRoads: json['avoidtollroads'],
      avoidTraffic: TrafficAvoidanceExtension.fromId(json['avoidtraffic']),
      avoidTurnAroundInstruction: json['avoidturnaroundinstruction'],
      avoidUnpavedRoads: json['avoidunpavedroads'],
      bikeProfile: BikeProfileElectricBikeProfile.fromJson(json['bikeprofile']),
      buildTerrainProfile: BuildTerrainProfile.fromJson(json['buildterrainprofile']),
      carProfile: CarProfile.fromJson(json['carprofile']),
      departureHeading: DepartureHeading.fromJson(json['departureheading']),
      emergencyVehicleExtraFreedomLevels: json['emergencyVehicleMode']['extraFreedom'],
      emergencyVehicleMode: json['emergencyVehicleMode']['enable'],
      evProfile: EVProfile.fromJson(json['evprofile']),
      ignoreRestrictionsOverTrack: json['ignorerestrictionsovertrack'],
      maximumDistanceConstraint: json['maximumdistanceconstraint'],
      maximumTransferTimeInMinutes: json['maximumtransfertimeInminutes'],
      maximumWalkDistance: json['maximumwalkdistance'],
      minimumTransferTimeInMinutes: json['minimumtransfertimeInminutes'],
      pathAlgorithm: RoutePathAlgorithmExtension.fromId(json['pathalgorithm']),
      pedestrianProfile: PedestrianProfileExtension.fromId(json['pedestrianprofile']),
      resultDetails: RouteResultDetailsExtension.fromId(json['resultdetails']),
      routeGroupIdsEarlierLater: json['routegroupidsearlierlater'],
      routeRanges: (json['routeranges']['list'] as List<dynamic>).map((item) => item as int).toList(),
      routeRangesQuality: json['routeranges']['quality'],
      routeResultType: RouteResultTypeExtension.fromId(json['routeresulttype']),
      routeType: RouteTypeExtension.fromId(json['routetype']),
      routeTypePreferences: json['routetypepreferences'],
      strictTrackFollow: json['stricttrackfollow'],
      timestamp: json['timestamp'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['timestamp'], isUtc: true),
      transportMode: RouteTransportModeExtension.fromId(json['transportmode']),
      truckProfile: TruckProfile.fromJson(json['truckprofile']),
      useBikes: json['usebikes'],
      useWheelchair: json['usewheelchair'],
    );
  }
}

/// eBike profile
///
/// {@category Routes & Navigation}
class ElectricBikeProfile {
  /// Ebike type
  ElectricBikeType type;

  /// Bike mass in kg. If 0, a default value is used
  double bikeMass;

  /// Biker mass in kg. If 0, a default value is used
  double bikerMass;

  /// Bike auxiliary power consumption during day in Watts. If 0, a default value is used
  double auxConsumptionDay;

  /// Bike auxiliary power consumption during night in Watts. If 0, a default value is used
  double auxConsumptionNight;

  /// Ignore country based legal restrictions related to e-bikes
  bool ignoreLegalRestrictions;

  /// Default constructor ElectricBikeProfile
  ///
  /// **Parameters**
  /// * **IN** *type* eBike type
  /// * **IN** *bikeMass* bike mass in kg
  /// * **IN** *bikerMass* biker mass in kg
  /// * **IN** *auxConsumptionDay* bike auxiliary power consumption during day in Watts
  /// * **IN** *auxConsumptionNight* bike auxiliary power consumption during night in Watts
  /// * **IN** *ignoreLegalRestrictions* ignore country based legal restrictions related to e-bikes
  ElectricBikeProfile({
    this.type = ElectricBikeType.pedelec,
    this.bikeMass = 0.0,
    this.bikerMass = 0.0,
    this.auxConsumptionDay = 0.0,
    this.auxConsumptionNight = 0.0,
    this.ignoreLegalRestrictions = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['type'] = type.id;

    json['bikeMass'] = bikeMass;

    json['bikerMass'] = bikerMass;

    json['auxConsumptionDay'] = auxConsumptionDay;

    json['auxConsumptionNight'] = auxConsumptionNight;

    json['ignoreLegalRestrictions'] = ignoreLegalRestrictions;
    return json;
  }

  factory ElectricBikeProfile.fromJson(Map<String, dynamic> json) {
    return ElectricBikeProfile(
      type: ElectricBikeTypeExtension.fromId(json['type']),
      bikeMass: json['bikeMass'],
      bikerMass: json['bikerMass'],
      auxConsumptionDay: json['auxConsumptionDay'],
      auxConsumptionNight: json['auxConsumptionNight'],
      ignoreLegalRestrictions: json['ignoreLegalRestrictions'],
    );
  }

  @override
  bool operator ==(covariant ElectricBikeProfile other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.bikeMass == bikeMass &&
        other.bikerMass == bikerMass &&
        other.auxConsumptionDay == auxConsumptionDay &&
        other.auxConsumptionNight == auxConsumptionNight &&
        other.ignoreLegalRestrictions == ignoreLegalRestrictions;
  }

  @override
  int get hashCode {
    return Object.hash(type, bikeMass, bikerMass, auxConsumptionDay, auxConsumptionNight, ignoreLegalRestrictions);
  }
}

/// EV routing profile
///
/// {@category Routes & Navigation}
class EVProfile {
  /// Model unique id
  int id;

  /// Battery usable capacity Wh
  double batteryCapacity;

  /// Maximum weight available on vehicle towbar
  int? towbarPossible;

  /// Vehicle range in meters
  int? vehicleRange;

  /// Consumption in Wh / km
  int? efficiency;

  /// How many km charged in one hour (10 - 80 interval)
  int? fastCharge;

  /// Supported charging ports, a combination of 1 or more [EVChargingConnector]
  int ports;

  /// Departure battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double? departureSoc;

  /// Destination min battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double? destinationSoc;

  /// Charger destination min battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double? chargerDestSoc;

  /// Charger departure max battery state of charge, from 0.f ( empty ) to 1.f ( full )
  double? chargerDepSoc;

  /// Charger time overhead in minutes
  int? chargerOverheadMins;

  /// Battery health, from 0.f ( nonfunctional ) to 1.f ( brand new )
  double? batteryHealth;

  /// List of [EVChargingConnector]
  List<EVChargingConnector> get connectors {
    List<EVChargingConnector> result = [];

    for (final connector in EVChargingConnector.values) {
      if ((ports & connector.id) != 0) {
        result.add(connector);
      }
    }

    return result;
  }

  /// List of [EVChargingConnector]
  set connectors(List<EVChargingConnector> connectors) {
    int result = 0;

    for (final connector in connectors) {
      result |= connector.id;
    }

    ports = result;
  }

  EVProfile({
    this.ports = 0,
    this.departureSoc,
    this.destinationSoc,
    this.chargerDestSoc,
    this.chargerDepSoc,
    this.chargerOverheadMins,
    this.batteryHealth,
    this.id = 0,
    this.batteryCapacity = 0.0,
    this.towbarPossible,
    this.vehicleRange,
    this.efficiency,
    this.fastCharge,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['id'] = id;

    json['ports'] = ports;

    if (departureSoc != null) {
      json['departureSoc'] = departureSoc;
    }
    if (destinationSoc != null) {
      json['destinationSoc'] = destinationSoc;
    }
    if (chargerDestSoc != null) {
      json['chargerDestSoc'] = chargerDestSoc;
    }
    if (chargerDepSoc != null) {
      json['chargerDepSoc'] = chargerDepSoc;
    }
    if (chargerOverheadMins != null) {
      json['chargerOverheadMins'] = chargerOverheadMins;
    }
    if (batteryHealth != null) {
      json['battery_Health'] = batteryHealth;
    }
    json['batteryCapacity'] = batteryCapacity;
    if (towbarPossible != null) {
      json['towbarPossible'] = towbarPossible;
    }
    if (vehicleRange != null) {
      json['vehicleRange'] = vehicleRange;
    }
    if (efficiency != null) {
      json['efficiency'] = efficiency;
    }
    if (fastCharge != null) {
      json['fastCharge'] = fastCharge;
    }
    return json;
  }

  factory EVProfile.fromJson(Map<String, dynamic> json) {
    return EVProfile(
      id: json['id'],
      ports: json['ports'],
      departureSoc: json['departureSoc'],
      destinationSoc: json['destinationSoc'],
      chargerDestSoc: json['chargerDestSoc'],
      chargerDepSoc: json['chargerDepSoc'],
      chargerOverheadMins: json['chargerOverheadMins'],
      batteryHealth: json['battery_Health'],
      batteryCapacity: json['batteryCapacity'],
      towbarPossible: json['towbarPossible'],
      vehicleRange: json['vehicleRange'],
      efficiency: json['efficiency'],
      fastCharge: json['fastCharge'],
    );
  }

  @override
  bool operator ==(covariant EVProfile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ports == ports &&
        other.departureSoc == departureSoc &&
        other.destinationSoc == destinationSoc &&
        other.chargerDestSoc == chargerDestSoc &&
        other.chargerDepSoc == chargerDepSoc &&
        other.chargerOverheadMins == chargerOverheadMins &&
        other.batteryHealth == batteryHealth &&
        other.batteryCapacity == batteryCapacity &&
        other.towbarPossible == towbarPossible &&
        other.vehicleRange == vehicleRange &&
        other.efficiency == efficiency &&
        other.fastCharge == fastCharge;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      ports,
      departureSoc,
      destinationSoc,
      chargerDestSoc,
      chargerDepSoc,
      chargerOverheadMins,
      batteryHealth,
      batteryCapacity,
      towbarPossible,
      vehicleRange,
      efficiency,
      fastCharge
    ]);
  }
}

/// Fuel Type
///
/// {@category Routes & Navigation}
enum FuelType {
  /// Petrol fuel type
  petrol,

  /// Diesel fuel type
  diesel,

  /// LPG (Liquid Petroleum Gas) fuel type
  lpg,

  /// Electric fuel type
  electric
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension FuelTypeExtension on FuelType {
  int get id {
    switch (this) {
      case FuelType.petrol:
        return 0;
      case FuelType.diesel:
        return 1;
      case FuelType.lpg:
        return 2;
      case FuelType.electric:
        return 3;
    }
  }

  static FuelType fromId(int id) {
    switch (id) {
      case 0:
        return FuelType.petrol;
      case 1:
        return FuelType.diesel;
      case 2:
        return FuelType.lpg;
      case 3:
        return FuelType.electric;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
enum EVChargingConnector {
  /// J1772 connector
  j1772,

  /// Mennekes connector
  mennekes,

  /// Type 2 connector
  type2,

  /// Type 3 connector
  type3,

  /// GBT AC connector
  gbtAc,

  /// GBT DC connector
  gbtDc,

  /// CHAdeMO connector
  chaemo,

  /// CSS1 connector
  css1,

  /// CSS2 connector
  css2,

  /// Tesla connector
  tesla,

  /// Super Tesla connector
  superTesla,

  /// Super Tesla CCS connector
  superTeslaCCS,

  /// Tesla destination charger connector
  teslaDestination,
}

/// @nodoc
///
/// {@category Routes & Navigation}
extension EVChargingConnectorExtension on EVChargingConnector {
  int get id {
    switch (this) {
      case EVChargingConnector.j1772:
        return 0x1;
      case EVChargingConnector.mennekes:
        return 0x2;
      case EVChargingConnector.type2:
        return 0x4;
      case EVChargingConnector.type3:
        return 0x8;
      case EVChargingConnector.gbtAc:
        return 0x10;
      case EVChargingConnector.gbtDc:
        return 0x20;
      case EVChargingConnector.chaemo:
        return 0x40;
      case EVChargingConnector.css1:
        return 0x80;
      case EVChargingConnector.css2:
        return 0x100;
      case EVChargingConnector.tesla:
        return 0x200;
      case EVChargingConnector.superTesla:
        return 0x400;
      case EVChargingConnector.superTeslaCCS:
        return 0x800;
      case EVChargingConnector.teslaDestination:
        return 0x1000;
      default:
        throw ArgumentError('Invalid id');
    }
  }

  static EVChargingConnector fromId(int id) {
    switch (id) {
      case 0x1:
        return EVChargingConnector.j1772;
      case 0x2:
        return EVChargingConnector.mennekes;
      case 0x4:
        return EVChargingConnector.type2;
      case 0x8:
        return EVChargingConnector.type3;
      case 0x10:
        return EVChargingConnector.gbtAc;
      case 0x20:
        return EVChargingConnector.gbtDc;
      case 0x40:
        return EVChargingConnector.chaemo;
      case 0x80:
        return EVChargingConnector.css1;
      case 0x100:
        return EVChargingConnector.css2;
      case 0x200:
        return EVChargingConnector.tesla;
      case 0x400:
        return EVChargingConnector.superTesla;
      case 0x800:
        return EVChargingConnector.superTeslaCCS;
      case 0x1000:
        return EVChargingConnector.teslaDestination;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Truck routing profile
///
/// {@category Routes & Navigation}
class TruckProfile {
  /// Truck mass in kg. By default it is 0 and is not considered in routing
  int mass;

  /// Truck height in cm. By default it is 0 and is not considered in routing
  int height;

  /// Truck length in cm. By default it is 0 and is not considered in routing
  int length;

  /// Truck width in cm. By default it is 0 and is not considered in routing
  int width;

  /// Truck axle load in kg. By default it is 0 and is not considered in routing
  int axleLoad;

  /// Truck max speed in m/s. By default it is 0 and is not considered in routing
  double? maxSpeed;

  /// Truck profile constructor with predefined FT_Diesel as fuel type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mass* Mass in kg.
  /// * **IN** *height* Height in cm.
  /// * **IN** *length* Length in cm.
  /// * **IN** *width* Width in cm.
  /// * **IN** *axleLoad* Axle load in kg.
  /// * **IN** *maxSpeed* Max speed in m/s.
  TruckProfile({
    this.mass = 0,
    this.height = 0,
    this.length = 0,
    this.width = 0,
    this.axleLoad = 0,
    this.maxSpeed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['mass'] = mass;
    json['height'] = height;
    json['length'] = length;
    json['width'] = width;
    json['axleLoad'] = axleLoad;
    if (maxSpeed != null) {
      json['maxSpeed'] = maxSpeed;
    }
    return json;
  }

  factory TruckProfile.fromJson(Map<String, dynamic> json) {
    return TruckProfile(
      mass: json['mass'],
      height: json['height'],
      length: json['length'],
      width: json['width'],
      axleLoad: json['axleLoad'],
      maxSpeed: json['maxSpeed'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final TruckProfile typedOther = other as TruckProfile;
    return mass == typedOther.mass &&
        height == typedOther.height &&
        length == typedOther.length &&
        width == typedOther.width &&
        axleLoad == typedOther.axleLoad &&
        maxSpeed == typedOther.maxSpeed;
  }

  @override
  int get hashCode {
    return Object.hash(
      mass,
      height,
      length,
      width,
      axleLoad,
      maxSpeed,
    );
  }
}

/// Car routing profile
///
/// {@category Routes & Navigation}
class CarProfile {
  /// Car mass in kg. By default it is 0 and is not considered in routing
  int mass;

  /// Car fuel type. By default it is petrol
  FuelType? fuel;

  /// Car max speed in m/s. By default it is 0 and is not considered in routing
  double? maxSpeed;

  /// Car profile constructor with predefined FT_Diesel as fuel type.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mass* Mass in kg.
  /// * **IN** *fuel* Fuel type.
  /// * **IN** *maxSpeed* Max speed in m/s.
  CarProfile({
    this.mass = 0,
    this.fuel = FuelType.petrol,
    this.maxSpeed = 0.0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['mass'] = mass;
    if (fuel != null) {
      json['fuel'] = fuel!.id;
    }
    if (maxSpeed != null) {
      json['maxSpeed'] = maxSpeed;
    }
    return json;
  }

  factory CarProfile.fromJson(Map<String, dynamic> json) {
    return CarProfile(
      mass: json['mass'],
      fuel: FuelTypeExtension.fromId(json['fuel']),
      maxSpeed: json['maxSpeed'],
    );
  }

  @override
  bool operator ==(covariant CarProfile other) {
    if (identical(this, other)) return true;

    return other.mass == mass && other.fuel == fuel && other.maxSpeed == maxSpeed;
  }

  @override
  int get hashCode {
    return mass.hashCode ^ fuel.hashCode ^ maxSpeed.hashCode;
  }
}
