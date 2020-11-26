import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:permission_handler/permission_handler.dart';

class ShopMyNearView extends StatefulWidget {
  @override
  _ShopMyNearViewState createState() => _ShopMyNearViewState();
}

class _ShopMyNearViewState extends State<ShopMyNearView> {
  LatLng latlong=null;
  CameraPosition _cameraPosition;
  GoogleMapController _controller ;
  Set<Marker> _markers={};

  @override
  void initState() {
    super.initState();
    _cameraPosition=CameraPosition(target: LatLng(0, 0),zoom: 16.0);
    getCurrentLocation();

  }

  @override
  Widget build(BuildContext context) {
    getCurrentAddress();
    return SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppToobar(
              Title: "",
              icon: "",
              header_type: Header_Type.barHome,
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: (GoogleMapController controller){
                    _controller=(controller);
                    _controller.animateCamera(
                        CameraUpdate.newCameraPosition(_cameraPosition));
                  },
                  markers: _markers,
                  onCameraIdle: (){
                    setState(() {

                    });
                  },
                )
              ],
            )
        )
    );
  }
  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted)
        getLocation();
      return;
    }
    getLocation();
  }
  List<Address> results = [];
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    print(position.latitude);

    setState(() {
      latlong=new LatLng(position.latitude, position.longitude);
      _cameraPosition=CameraPosition(target:latlong,zoom: 16.0 );
      if(_controller!=null)
        _controller.animateCamera(

            CameraUpdate.newCameraPosition(_cameraPosition));
print("---------------- ${latlong.latitude}---------------${latlong.longitude}");
      _markers.add(Marker(
          markerId: MarkerId("1"),
          position: LatLng(latlong.latitude,latlong.longitude)
      ));
    });
  }

  getCurrentAddress() async
  {
    final coordinates = new Coordinates(latlong.latitude, latlong.longitude);
    results  = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = results.first;
    if(first!=null) {
      var address;
      address = first.featureName;
      address =   " $address, ${first.subLocality}" ;
      address =  " $address, ${first.subLocality}" ;
      address =  " $address, ${first.locality}" ;
      address =  " $address, ${first.countryName}" ;
      address = " $address, ${first.postalCode}" ;
      print("address ${first.toString()}");
      print(address);
    }
  }

}
