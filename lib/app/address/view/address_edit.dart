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
import 'package:whiteproject/app/home/view/home_page.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/red_button.dart';
import 'package:whiteproject/network_kit/models/address_list_model.dart';
import 'package:whiteproject/network_kit/repository/address/address_client.dart';

class AddressEdit extends StatefulWidget {
  final Position position;
  final AddressList address;

  AddressEdit({required this.position, required this.address, Key? key})
      : super(key: key);

  static Route route(Position position, AddressList address) {
    return routeWith(position, address);
  }

  static Route routeWith(Position position, AddressList address) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            AddressEdit(
              position: position,
              address: address,
            ));
  }

  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  AddressClient service = AddressClient();
  late MyProgress pr;
  TextEditingController addressField = TextEditingController();
  TextEditingController info = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController apartment = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController cui = TextEditingController();
  TextEditingController phone = TextEditingController();
  double actualLat = 0.0;
  double actualLng = 0.0;
  Completer<GoogleMapController> _controller = Completer();
  final String kGoogleApiKey = 'AIzaSyAWdYQVLCFadEohDOVSScw7BXRf-omoG6E';
  bool defaultBilling = false;
  bool defaultShipping = false;

  Map<MarkerId, Marker> markers =
  <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _add({required double lat, required double lng}) async {
    print('lat $lat');
    final MarkerId markerId = MarkerId('my_location');
    final Marker marker = Marker(
      markerId: markerId,
      position: lat != 0.0
          ? LatLng(lat, lng)
          : LatLng(widget.position.latitude, widget.position.longitude),
    );
    markers[markerId] = marker;
    if(lat != 0.0) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      addressField.text =
          placemarks.first.street! + ', ' + placemarks.first.locality!;
      markers[markerId] = marker;
    } else {
      setState(() {
        addressField.text =
            widget.address.street.first + ', ' + widget.address.city;
        markers[markerId] = marker;
      });
    }
  }

  @override
  void initState() {
    if (actualLng == 0.0) {
      actualLng = widget.position.longitude;
      actualLat = widget.position.latitude;
      _add(lat: actualLat, lng: actualLng);
    }
    defaultShipping = widget.address.defaultShipping;
    defaultBilling = widget.address.defaultBilling;
    company.text = widget.address.company;
    cui.text = widget.address.vatId;
    phone.text = widget.address.phone;
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
            'EDIT ADDRESS',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          elevation: 10,
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  markers.clear();
                  pr.show(context, context);
                  Position currentLocation = await Geolocator
                      .getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.medium);
                  _add(lat: currentLocation.latitude,
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
        body: SingleChildScrollView(
          child: Column(
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
                        controller: addressField,
                        enabled: false,
                        onChanged: (value) async {},
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.place, color: whiteproject_dark_grey,),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          border: const OutlineInputBorder(),
                          hintText: 'Address',
                        )
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child:TextFormField(
                    controller: company,
                    enabled: true,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      hintText: 'Company name',
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                    controller: cui,
                    enabled: true,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      hintText: 'CUI',
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextFormField(
                    controller: phone,
                    enabled: true,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(),
                      hintText: 'Phone',
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: floor,
                          enabled: true,
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            border: const OutlineInputBorder(),
                            hintText: 'Floor*',
                          )
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                          controller: apartment,
                          enabled: true,
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            border: const OutlineInputBorder(),
                            hintText: 'Apartment*',
                          )
                      ),
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
                          maxLines: null,
                          controller: info,
                          enabled: true,
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            border: const OutlineInputBorder(),
                            hintText: 'Delivery instructions',
                          )
                      ),
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
                  text: 'Edit address',
                  onPress: () {
                    updateAddressOnClick(context);
                  },
                )
              ),
              SizedBox(height: 7,),
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
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  updateAddressOnClick(BuildContext context) async {
    pr.show(context, context);
    List<Placemark> placemarks =
    await placemarkFromCoordinates(actualLat, actualLng);
    var geoDecode = placemarks.first;
    var updateResult = await service.updateAddress(id: widget.address.id,
        streetName: geoDecode.street!,
        postCode: geoDecode.postalCode!,
        city: geoDecode.locality!,
        defaultShipping: defaultShipping,
        defaultBilling: defaultBilling);
    if(updateResult == "1") {
      Navigator.of(context).pop(true);
      pr.hide(context);
    } else {
      pr.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(updateResult)));
    }
  }
}
