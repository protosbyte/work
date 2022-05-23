import 'dart:async';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:whiteproject/app/address/bloc/address_bloc.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/red_button.dart';
import 'package:whiteproject/network_kit/repository/address/address_client.dart';

class AddAddressScreen extends StatefulWidget {
  final Position position;

  AddAddressScreen({required this.position, Key? key}) : super(key: key);

  static Route route(Position position) {
    return routeWith(position);
  }

  static Route routeWith(Position position) {
    return MaterialPageRoute<void>(
        builder: (_) => AddAddressScreen(
              position: position,
            ));
  }

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  AddressClient service = AddressClient();
  late MyProgress pr;
  TextEditingController address = TextEditingController();
  TextEditingController info = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController apartment = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController cui = TextEditingController();
  TextEditingController phone = TextEditingController();
  double actualLat = 0.0;
  double actualLng = 0.0;
  Completer<GoogleMapController> _controller = Completer();
  final String kGoogleApiKey = 'AIzaSyAWdYQVLCFadEohDOVSScw7BXRf-xxxx';
  bool defaultBilling = false;
  bool defaultShipping = false;

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _add({required double lat, required double lng}) async {
    final MarkerId markerId = MarkerId('my_location');
    final Marker marker = Marker(
      markerId: markerId,
      position: lat != 0.0
          ? LatLng(lat, lng)
          : LatLng(widget.position.latitude, widget.position.longitude),
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    setState(() {
      address.text =
          placemarks.first.locality! + ', ' + placemarks.first.street!;
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    if (actualLng == 0.0) {
      actualLng = widget.position.longitude;
      actualLat = widget.position.latitude;
      _add(lat: actualLat, lng: actualLng);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressBloc(service),
      child: addressContent(context),
    );
  }

  Widget addressContent(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: whiteproject_red,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          title: Text(
            'ADD ADDRESS',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          elevation: 10,
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  markers.clear();
                  pr.show(context, context);
                  Position currentLocation =
                      await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.medium);
                  _add(
                      lat: currentLocation.latitude,
                      lng: currentLocation.longitude);
                  pr.hide(context);
                },
                icon: Icon(
                  Icons.gps_fixed,
                  color: whiteproject_red,
                ))
          ],
          titleSpacing: 0,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                  width: double.infinity,
                  height: 250,
                  child: mapWidget(context)),
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                          'Move the map and place the pin at your location or enter the address below.',
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Container(
                  child: GestureDetector(
                    onTap: () async {
                      Prediction? p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.overlay,
                          // Mode.fullscreen
                          language: "ro",
                          types: [],
                          components: [new Component(Component.country, "ro")],
                          strictbounds: true);
                    },
                    child: TextFormField(
                        cursorColor: whiteproject_red,
                        controller: address,
                        enabled: false,
                        onChanged: (value) async {},
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.place,
                            color: whiteproject_dark_grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: whiteproject_red, width: 0.5),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          border: const OutlineInputBorder(),
                          hintText: 'Address',
                        )),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                    cursorColor: whiteproject_red,
                    controller: company,
                    enabled: true,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: whiteproject_red, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      hintText: 'Company name',
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                    cursorColor: whiteproject_red,
                    controller: cui,
                    enabled: true,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: whiteproject_red, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      hintText: 'CUI',
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                    cursorColor: whiteproject_red,
                    controller: phone,
                    enabled: true,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: whiteproject_red, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      hintText: 'Phone*',
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          cursorColor: whiteproject_red,
                          controller: floor,
                          enabled: true,
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: whiteproject_red, width: 0.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            border: const OutlineInputBorder(),
                            hintText: 'Floor*',
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                          cursorColor: whiteproject_red,
                          controller: apartment,
                          enabled: true,
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: whiteproject_red, width: 0.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            border: const OutlineInputBorder(),
                            hintText: 'Apartment*',
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          cursorColor: whiteproject_red,
                          maxLines: null,
                          controller: info,
                          enabled: true,
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: whiteproject_red, width: 0.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            border: const OutlineInputBorder(),
                            hintText: 'Delivery instructions',
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Checkbox(
                        activeColor: whiteproject_red,
                        checkColor: Colors.white,
                        value: defaultBilling,
                        onChanged: (v) {
                          print(v);
                          setState(() {
                            defaultBilling = v!;
                          });
                        }),
                    Text('Default Billing Address')
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Checkbox(
                        activeColor: whiteproject_red,
                        checkColor: Colors.white,
                        value: defaultShipping,
                        onChanged: (v) {
                          print(v);
                          setState(() {
                            defaultShipping = v!;
                          });
                        }),
                    Text('Default Shipping Address')
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  child: RedButton(
                    text: 'ADD ADDRESS',
                    onPress: () {
                      createAddressOnClick(context);
                    },
                  )),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget mapWidget(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return new GoogleMap(
      onTap: (value) {
        setState(() {
          actualLat = value.latitude;
          actualLng = value.longitude;
        });
        _add(lat: value.latitude, lng: value.longitude);
      },
      markers: Set<Marker>.of(markers.values),
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  createAddressOnClick(BuildContext context) async {
    if (apartment.text.isEmpty || floor.text.isEmpty) {
    } else {
      pr.show(context, context);
      var res = await service.getRegionInfo();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(actualLat, actualLng);
      String administrativeArea =
          placemarks.first.administrativeArea!.split(' ')[1];
      print(administrativeArea.length);
      for (var x in res.availableCountrys) {
        if (removeDiacritics(x.name) == removeDiacritics(administrativeArea)) {
          var res = await service.createAddress(
              id: x.id,
              region: placemarks.first.country!,
              regionCode: x.code,
              countryCode: placemarks.first.isoCountryCode!,
              streetName: placemarks.first.street! +
                  ", " +
                  apartment.text +
                  ", " +
                  floor.text +
                  ", " +
                  info.text,
              postCode: placemarks.first.postalCode!,
              city: placemarks.first.locality!,
              defaultShipping: defaultShipping,
              defaultBilling: defaultBilling,
              company: company.text,
              vatID: cui.text,
              phone: phone.text);
          if (res == "1") {
            Navigator.of(context).pop(true);
            pr.hide(context);
          } else {
            pr.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res),
            ));
          }
        } else if (administrativeArea.isEmpty) {
          pr.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error occurred. Try again later.'),
          ));
        }
      }
    }
  }
}
