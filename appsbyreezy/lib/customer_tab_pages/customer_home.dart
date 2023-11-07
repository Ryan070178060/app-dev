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

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  LatLng? currentLocation;
  final places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyAzxZJsg5CtuxiPCL8fMymgmUP8fNeR_DQ'); // Replace with your Google Maps API key

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "";
  String userEmail = "";

  bool OpenNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyicon;

  // String humanReadableAddress=await AssistantMethods.searchAddressForGeographicCoordinates(currentLocation!, context);
  // print("This is our ad")

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
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
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
          buildTextField(),
          showSourceField ? buildTextFieldForSource() : Container(),
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

  Future<String> showGoogleAutoComplete() async {
    const kGoogleApiKey = "AIzaSyAzxZJsg5CtuxiPCL8fMymgmUP8fNeR_DQ";

    Prediction? prediction = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "ken",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: kGoogleApiKey, // Mode.fullscreen
      components: [new Component(Component.country, "ken")],
      types: ["(cities)"],
      hint: "Search City",
    );

    return prediction!.description!;
  }

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  bool showSourceField = false;

  Widget buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 5,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: destinationController,
              readOnly: true,
              onTap: () async {
                String selectedPlace = await showGoogleAutoComplete();
                destinationController.text = selectedPlace;
                setState(() {
                  showSourceField = true;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green,
                hintText: 'Where to?',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //  Navigator.push(
              //    context,
              //   MaterialPageRoute(
              //      builder: (c) => SearchDestinationPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: 5,
        right: 20,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: destinationController,
              readOnly: true,
              onTap: () async {
                String selectedPlace = await showGoogleAutoComplete();
                destinationController.text = selectedPlace;
                setState(() {
                  showSourceField = true;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 199, 218, 36),
                hintText: 'From?',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //  Navigator.push(
              //    context,
              //   MaterialPageRoute(
              //      builder: (c) => SearchDestinationPage()));
            },
          ),
        ],
      ),
    );
  }

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
