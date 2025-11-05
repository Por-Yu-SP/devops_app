// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:devops_app/homepage.dart';
import 'package:devops_app/reserve.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'service.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}



class _mapState extends State<map> {
  LatLng? userPosition;
  /*
  final List<LatLng> fixedLocations = [
  LatLng(1.4351301240729977, 103.78039359947167), // Marsiling 
  LatLng(1.4473204547442071, 103.8235857128454), // Bukit Canberra
  ];
  */
  Map<String,LatLng> locationmap = 
  {
    "Woodlands Regional":LatLng(1.4349029822289412, 103.78678249404125),
    "Sembawang Library":LatLng(1.448284681163857, 103.81955785189928),
  };
  // ignore: annotate_overrides
  void initState() {
    super.initState();
    _determinePosition().then((pos) {
      setState(() {
        userPosition = LatLng(pos.latitude, pos.longitude);
      });
    }).catchError((e) {
    });
    }
  @override
  Widget build(BuildContext context) {
    //if cannot load gps
    if (userPosition == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Tap on a Library", style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: IconButton(onPressed: (){

            Navigator.push(context,MaterialPageRoute(builder: (context)=>homepage()));
          }, 
          color: Colors.white,
          icon: Icon(Icons.home)),
        ),

        
        //https://pub.dev/packages/geolocator
        //https://docs.fleaflet.dev/
        

        body: FlutterMap(
        options: MapOptions(
          initialCenter: userPosition!, // Center the map 
          initialZoom: 9.2,
        ),
        children: [
          TileLayer( // Bring your own tiles
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
            userAgentPackageName: 'com.example.mad_project_v1', // must not be empty
            tileProvider: NetworkTileProvider(), // recommended for Android
            // And many more recommended properties!
          ),
        
        
          //https://docs.fleaflet.dev/layers/marker-layer
          MarkerLayer(
            markers: [
              Marker(
                point: userPosition!,
                width: 50,
                height: 50,
                child: const Icon(Icons.my_location, size: 40, color: Colors.blue),
              ),
              ...locationmap.entries.map((entry) => Marker(
                point: entry.value,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: ()async{
                    services.tappedLocation=entry.key;
                    await services.selectlocation();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>reserve()));
                  },
                  child: Icon(Icons.location_on, color: Colors.red, size: 30)),
              )),
            ],
          ),
          RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
              ),
              // Also add images...
            ],
          ),
        ],
          ),
      );
  }
}



/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}