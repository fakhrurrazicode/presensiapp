import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AbsensiRequestTakePictureScreen extends StatefulWidget {
  static const routeName = '/absensi_request/take_picture';
  const AbsensiRequestTakePictureScreen({Key? key}) : super(key: key);

  @override
  State<AbsensiRequestTakePictureScreen> createState() =>
      _AbsensiRequestTakePictureScreenState();
}

class _AbsensiRequestTakePictureScreenState
    extends State<AbsensiRequestTakePictureScreen> {
  late List<CameraDescription> _availableCameras;
  late Future<void> _initializeControllerFuture;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    _availableCameras = await _getAvailableCamera();
    CameraDescription cameraDescription = _availableCameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();
    return _initializeControllerFuture;
  }

  @override
  Widget build(BuildContext context) {
    // init();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Ambil Photo Check in'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  CameraPreview(_cameraController),
                  const SizedBox(
                    height: 46,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Attempt to take a picture and get the file `image`
                        // where it was saved.
                        final image = await _cameraController.takePicture();

                        // Navigator.pop(context, image.path);

                        if (!mounted) return;

                        // If the picture was taken, display it on a new screen.
                        Navigator.pop(context, image.path);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => CheckInFinalScreen(
                        //       locationData: widget.locationData,
                        //       imagePath: image.path,
                        //     ),
                        //   ),
                        // );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        // print(e);
                      }
                    },
                    child: const Icon(Icons.camera),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<List<CameraDescription>> _getAvailableCamera() async {
    List<CameraDescription> aCamera = await availableCameras();

    return aCamera;
  }
}
