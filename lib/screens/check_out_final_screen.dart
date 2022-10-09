import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_v2/app_state_provider.dart';
import 'package:app_v2/models/presensi.dart';
import 'package:app_v2/models/user.dart';

import 'package:app_v2/screens/splash_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class CheckOutFinalScreen extends StatefulWidget {
  static const routeName = '/check_out_final';
  final LocationData locationData;
  final String imagePath;

  const CheckOutFinalScreen({
    Key? key,
    required this.locationData,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<CheckOutFinalScreen> createState() => _CheckOutFinalScreenState();
}

class _CheckOutFinalScreenState extends State<CheckOutFinalScreen> {
  bool isLoading = true;
  late GoogleMapController _mapController;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 18,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId markerId = const MarkerId('marker_id_123');

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

  void _setMarker() {
    markers[markerId] = Marker(
      markerId: markerId,
      position: LatLng(
        widget.locationData.latitude!,
        widget.locationData.longitude!,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _getPolygon();
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Final Check out'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AppStateProvider>(
                builder: (context, authProvider, child) => ListView(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    // Card(child: Image.file(File(widget.imagePath))),

                    SizedBox(
                      height: 250,
                      child: GoogleMap(
                        polygons: Set<Polygon>.of(polygons.values),
                        markers: Set<Marker>.of(markers.values),
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
                        },
                        initialCameraPosition: initialCameraPosition,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        // cameraTargetBounds: CameraTargetBounds.unbounded,
                        mapType: MapType.normal,
                        zoomControlsEnabled: true,
                      ),
                    ),

                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Photo',
                              style: TextStyle(fontSize: 16),
                            ),
                            Image.file(
                              File(widget.imagePath),
                              width: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const ListTile(
                      tileColor: Colors.white,
                      title: Text('NIP'),
                      subtitle: Text('199101230123012312'),
                    ),

                    ListTile(
                      tileColor: Colors.white,
                      title: const Text('Nama'),
                      subtitle: Text(authProvider.user!.pegawai.nama ?? '-'),
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title:
                          const Text('Lokasi Check out (Latitude, Longitude)'),
                      subtitle: Text(
                          '${widget.locationData.latitude}, ${widget.locationData.longitude}'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          User? u = Provider.of<AppStateProvider>(context,
                                  listen: false)
                              .user;

                          if (u != null) {
                            User user = u;
                            Presensi? todayPresensi =
                                user.pegawai.todayPresensi;

                            if (todayPresensi != null) {
                              DateTime currentDateTime = DateTime.now();

                              http.StreamedResponse response =
                                  await ApiServices().checkOut(
                                context: context,
                                presensiId: todayPresensi.id,
                                checkedOutAt: currentDateTime.toString(),
                                checkedOutLatitude:
                                    widget.locationData.latitude ?? 0,
                                checkedOutLongitude:
                                    widget.locationData.longitude ?? 0,
                                imagePath: widget.imagePath,
                              );

                              Uint8List bytes = await response.stream.toBytes();
                              String responseBody = String.fromCharCodes(bytes);

                              if (response.statusCode == 200) {
                                var decodedResponseBody =
                                    json.decode(responseBody);

                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Success'),
                                      content:
                                          Text(decodedResponseBody['message']),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok'),
                                        )
                                      ],
                                    );
                                  },
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamedAndRemoveUntil(context,
                                    SplashScreen.routeName, (route) => false);
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          Text('Error ${response.statusCode}'),
                                      content: Text(responseBody),
                                    );
                                  },
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.location_pin),
                        label: Consumer<AppStateProvider>(
                          builder: (context, AppStateProvider appStateProvider,
                                  child) =>
                              Text(
                                  ' Check out (${DateFormat('dd/MM/yyyy kk:mm:ss').format(appStateProvider.currentDateTime).toString()})'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
