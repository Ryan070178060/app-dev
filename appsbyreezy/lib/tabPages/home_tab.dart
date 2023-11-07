import 'package:appsbyreezy/Assistants/assistant_method.dart';
import 'package:appsbyreezy/customer_tab_pages/search_destination_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
 

  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  LatLng? currentLocation;
  final places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyAzxZJsg5CtuxiPCL8fMymgmUP8fNeR_DQ'); // Replace with your Google Maps API key


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    
  }

  _getCurrentLocation() async {
    try {
      var status = await Permission.location.request();

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });

        if (mapController != null && currentLocation != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              currentLocation!,
              14.0,
            ),
          );
        }
      } else if (status.isDenied) {
        print('Location permission is denied.');
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Reezy Taxi'),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // HEADER
            Container(
              color: Colors.black,
              height: 160,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 60,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "USERNAME",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "profile",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const Divider(
              height: 1,
              color: Colors.blue,
              thickness: 1,
            ),

            const SizedBox(
              height: 10,
            ),

            ListTile(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
              ),
              title: const Text(
                "About",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Colors.blue,
                ),
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: currentLocation != null
                  ? CameraPosition(
                      target: currentLocation!,
                      zoom: 14.0,
                    )
                  : CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 14.0,
                    ),
            ),
          ),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
        ],
      ),
    );
  }

  Widget buildCurrentLocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green,
          child: Icon(
            Icons.my_location,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.notifications,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

 

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  bool showSourceField = false;

 

 

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      if (currentLocation != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            currentLocation!,
            14.0,
          ),
        );
      }
    });
  }
}
