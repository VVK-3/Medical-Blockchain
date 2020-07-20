import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatelessWidget {
  static final String route = '/map';
  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<PermissionGroup, PermissionStatus>>(
      future:
          PermissionHandler().requestPermissions([PermissionGroup.location]),
      builder: (context, res) {
        if (res.hasData) {
          switch (res.data[PermissionGroup.location]) {
            case PermissionStatus.granted:
              return Scaffold(
                appBar: AppBar(
                  title: Text('Closest Hospital'),
                ),
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(31.045001, 31.364226),
                    //tilt: 59.440717697143555,
                    zoom: 19.151926040649414,
                    bearing: 192.8334901395799,
                  ),
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                ),
              );
            default:
              return Container(
                color: Colors.red,
              );
          }
        } else {
          return Container(
            color: Colors.orange,
          );
        }
      },
    );
  }
}
