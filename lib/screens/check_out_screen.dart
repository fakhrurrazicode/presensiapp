import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_v2/screens/check_out_take_picture_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class CheckOutScreen extends StatefulWidget {
  static const routeName = '/check_out';
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool isLoading = true;
  bool canCheckOut = false;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 18,
  );
  late GoogleMapController _mapController;

  Location location = Location();
  LocationData locationData = LocationData.fromMap({});

  late StreamSubscription<LocationData> locationSubscription;
  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  PolygonId polygonId = const PolygonId('polygon_id_123');
  LatLng centerOfPolygon = const LatLng(0, 0);
  List<LatLng> polygonLatLng = [];
  List<mp.LatLng> mpPolygonLatLng = [];

  Future<void> _getPolygon() async {
    setState(() {
      isLoading = true;
    });
    try {
      http.Response response = await ApiServices().polygonPoints(context);
      log('polygonPoints() => response.body : ${response.body}');

      if (response.statusCode == 200) {
        var decodedResponseBody = json.decode(response.body);

        List<LatLng> newPolygonLatLng = [];
        for (var polygon in decodedResponseBody) {
          newPolygonLatLng.add(LatLng(polygon['lat'], polygon['lng']));
        }

        double totalLat = 0;
        double totalLng = 0;
        for (var latLng in newPolygonLatLng) {
          totalLat += latLng.latitude;
          totalLng += latLng.longitude;
        }

        double avgLat = totalLat / newPolygonLatLng.length;
        double avgLng = totalLng / newPolygonLatLng.length;

        setState(() {
          polygonLatLng = newPolygonLatLng;
          centerOfPolygon = LatLng(avgLat, avgLng);
        });

        polygons[polygonId] = Polygon(
          polygonId: polygonId,
          consumeTapEvents: true,
          strokeColor: Colors.orange,
          strokeWidth: 5,
          fillColor: Colors.green,
          points: polygonLatLng,
        );

        mpPolygonLatLng = polygonLatLng
            .map(
                (LatLng latLng) => mp.LatLng(latLng.latitude, latLng.longitude))
            .toList();
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Response ${response.statusCode}'),
              content: Text(response.body),
            );
          },
        );
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          );
        },
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getPolygon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check out'),
      ),
      floatingActionButton: Container(
        // color: Colors.pink,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: (canCheckOut)
                  ? () async {
                      locationSubscription.pause();
                      // Navigator.pushNamed(
                      //     context, CheckOutTakePictureScreen.routeName);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckOutTakePictureScreen(
                              locationData: locationData,
                            ),
                          ));

                      // print('imagePath: $imagePath');
                      locationSubscription.resume();
                    }
                  : null,
              icon: const Icon(Icons.location_pin),
              label: const Text('Set Lokasi Check out'),
            )
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              polygons: Set<Polygon>.of(polygons.values),
              onMapCreated: (GoogleMapController controller) async {
                _mapController = controller;

                LatLng latLng = polygonLatLng[0];

                _mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: centerOfPolygon,
                      zoom: 18,
                    ),
                  ),
                );

                locationSubscription = location.onLocationChanged
                    .listen((LocationData newLocationData) {
                  mp.LatLng mpLatLng = mp.LatLng(newLocationData.latitude ?? 0,
                      newLocationData.longitude ?? 0);
                  bool isContainsLocation = mp.PolygonUtil.containsLocation(
                      mpLatLng, mpPolygonLatLng, false);

                  setState(() {
                    canCheckOut = isContainsLocation;
                    locationData = newLocationData;
                  });
                });
              },
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              // cameraTargetBounds: CameraTargetBounds.unbounded,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
            ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    locationSubscription.cancel();
    super.dispose();
  }
}
