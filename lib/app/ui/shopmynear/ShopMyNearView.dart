import 'package:flutter/material.dart';

class ShopMyNearView extends StatefulWidget {
  @override
  _ShopMyNearViewState createState() => _ShopMyNearViewState();
}

class _ShopMyNearViewState extends State<ShopMyNearView> {
  // LatLng latlong;
  // CameraPosition _cameraPosition;
  // GoogleMapController _controller;
  // Set<Marker> _markers = {};
  // var address;
  // Set<Circle> circles = {};

  @override
  void initState() {
    super.initState();
    //_cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 16.0);
    //getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // getCurrentAddress();
    return SizedBox();
    // return SafeArea(
    //     top: false,
    //     child: Scaffold(
    //         appBar: AppToobar(
    //           title: "",
    //           icon: "",
    //           locationTxt: address,
    //           headerType: Header_Type.barMap,
    //         ),
    //         body: Stack(
    //           children: [
    //             GoogleMap(
    //               myLocationEnabled: true,
    //               myLocationButtonEnabled: false,
    //
    //               //  circles: circles,
    //               initialCameraPosition: _cameraPosition,
    //               onMapCreated: (GoogleMapController controller) {
    //                 _controller = (controller);
    //                 _controller.animateCamera(
    //                     CameraUpdate.newCameraPosition(_cameraPosition));
    //               },
    //               markers: _markers,
    //               onCameraIdle: () {
    //                 setState(() {});
    //               },
    //             )
    //           ],
    //         )));
  }
  // Future getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission != PermissionStatus.granted) {
  //     LocationPermission permission = await Geolocator.requestPermission();
  //     if (permission != PermissionStatus.granted)
  //       getLocation();
  //     return;
  //   }
  //   getLocation();
  // }
  // List<Address> results = [];
  // getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition();
  //   print(position.latitude);
  //
  //   setState(() {
  //     latlong=new LatLng(position.latitude, position.longitude);
  //     _cameraPosition=CameraPosition(target:latlong,zoom: 16.0 );
  //     if(_controller!=null)
  //       _controller.animateCamera(
  //           CameraUpdate.newCameraPosition(_cameraPosition));
  //       print("---------------- ${latlong.latitude}---------------${latlong.longitude}");
  //     _markers.add(Marker(
  //       draggable: true,
  //         markerId: MarkerId("1"),
  //         icon:BitmapDescriptor.fromAsset('assets/images/png/icon_location.png'),
  //         position: LatLng(latlong.latitude,latlong.longitude)
  //     ));
  //
  //
  //
  //     circles.add(
  //         Circle(
  //           circleId: CircleId("1"),
  //           center: LatLng(latlong.latitude,latlong.longitude),
  //           radius: 10,
  //           fillColor: Colors.blue,
  //           strokeColor: Colors.white,
  //           strokeWidth: 5
  //         )
  //     );
  //   });
  // }
  //
  // getCurrentAddress() async {
  //   final coordinates = new Coordinates(latlong.latitude, latlong.longitude);
  //   results  = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = results.first;
  //   if(first!=null) {
  //     address = first.featureName;
  //     address =   " $address, ${first.subLocality}" ;
  //     address =  " $address, ${first.subLocality}" ;
  //     address =  " $address, ${first.locality}" ;
  //     address =  " $address, ${first.countryName}" ;
  //     address = " $address, ${first.postalCode}" ;
  //     print("address ${first.toString()}");
  //     print(address);
  //   }
  // }
  //
  //

}
