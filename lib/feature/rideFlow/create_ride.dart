import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sabay_ka/app/app_drawer.dart';
import 'package:sabay_ka/common/constant/assets.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/common/widget/common_gridview_container.dart';
import 'package:sabay_ka/common/widget/custom_button.dart';
import 'package:sabay_ka/feature/rideFlow/watch_requests.dart';
import 'package:sabay_ka/main.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';
import 'package:sabay_ka/app/text_style.dart';
import 'package:sabay_ka/feature/notification/notification_widget.dart';

class CreateRideWidget extends StatefulWidget {
  const CreateRideWidget({super.key});

  @override
  State<CreateRideWidget> createState() => _CreateRideWidgetState();
}

class _CreateRideWidgetState extends State<CreateRideWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool? isFromTomasClaudio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      drawer: CustomDrawer(),
      key: _scaffoldKey,
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomePageTopBar(
                onTap: () {
                  if (_scaffoldKey.currentState!.isDrawerOpen == false) {
                    _scaffoldKey.currentState!.openDrawer();
                  } else {
                    _scaffoldKey.currentState!.openEndDrawer();
                  }
                },
              ),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                          value: true,
                          groupValue: isFromTomasClaudio,
                          onChanged: (value) {
                            setState(() {
                              isFromTomasClaudio = value as bool;
                            });
                          }),
                      Column(
                        children: [
                          Image(image: AssetImage(Assets.carImage)),
                          Text('From Tomas Claudio',),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                          value: false,
                          groupValue: isFromTomasClaudio,
                          onChanged: (value) {
                            setState(() {
                              isFromTomasClaudio = value as bool;
                            });
                          }),
                      Column(
                        children: [
                          Image(image: AssetImage(Assets.taxiImage)),
                          Text('To Tomas Claudio',),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              CustomRoundedButtom(
                  color: Colors.transparent,
                  borderColor: CustomTheme.appColor,
                  title: "Start looking for passengers",
                  textColor: CustomTheme.appColor,
                  isDisabled: isFromTomasClaudio == null,
                  onPressed: () async {
                    if (isFromTomasClaudio == null) {
                      return;
                    }

                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                    }
                    final location = await Geolocator.getCurrentPosition();
                    final ride = await locator<PocketbaseService>().createRide(
                        location.latitude,
                        location.longitude,
                        isFromTomasClaudio!);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WatchRequests(
                            rideId: ride.id,
                            isFromTomasClaudio: isFromTomasClaudio!),
                      ),
                    );
                  }),
            ],
          )),
    );
  }
}

class HomePageTopBar extends StatelessWidget {
  final Function() onTap;
  const HomePageTopBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: CustomTheme.appColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4)),
                child: const Icon(
                  Icons.menu,
                  color: CustomTheme.darkColor,
                )),
          ),
          Text('Start a Ride?', style: PoppinsTextStyles.headlineMediumRegular),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationWidget(),
                  ));
            },
            child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: CustomTheme.lightColor,
                    borderRadius: BorderRadius.circular(4)),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: CustomTheme.darkColor,
                )),
          ),
        ],
      ),
    );
  }
}
