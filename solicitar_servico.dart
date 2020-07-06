import 'package:aton9/classes/local.dart';
import 'package:aton9/google_maps_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'classes/class_servicos.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// ignore: must_be_immutable
class SolicitarServico extends StatefulWidget {
  Servicos servers;
  String desc;
  Local localizacao;

  SolicitarServico(this.servers, this.desc, this.localizacao);

  @override
  _SolicitarServicoScreenState createState() =>
      _SolicitarServicoScreenState(this.servers, this.desc, this.localizacao);
}

class _SolicitarServicoScreenState extends State<SolicitarServico> {
  Servicos servers;
  String desc;
  Local localizacao;
  _SolicitarServicoScreenState(this.servers, this.desc, this.localizacao);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  var appBar = AppBar(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    title: Container(
      child: Column(
        children: <Widget>[
          Text('Solicitar Serviço',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );

  GoogleMapController mapController;
  Set<Marker> markes = new Set<Marker>();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  final TextEditingController _controllerLocal = TextEditingController();
  final Set<Polyline> _polyLines = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      localizacao.position = position.target;
      localizacao.latitude = position.target.latitude;
      localizacao.longitude = position.target.longitude;
    });
  }

  /*_centerView() async {
    await mapController.getVisibleRegion();
    var bounds = LatLngBounds(
        southwest: LatLng(localizacao.latitude, localizacao.longitude),
        northeast: LatLng(localizacao.latitude, localizacao.longitude));
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    mapController.animateCamera(cameraUpdate);
  }*/

  _moveCamera(double latitude, double longitude) {
    print('na camera');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 18)));
  }

  void _addMarker(LatLng location, String address) {
    String me = localizacao.position.toString();
    markes.add(
      Marker(
        markerId: MarkerId(me),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Realizar aqui"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  void createRoute(String encodedPoly) {
    setState(() {
      _polyLines.add(
        Polyline(
            polylineId: PolylineId(localizacao.localDeRealizacao),
            width: 10,
            points: convertToLatLng(_decodePoly(encodedPoly)),
            color: Colors.black),
      );
    });
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }

    return result;
  }

  void sendRequest(String intendedLocation) async {
    print('entrou');
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(destination);
    createRoute(route);

    _moveCamera(latitude, longitude);
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  @override
  Widget build(BuildContext context) {
    String preco = servers.getPreco().toStringAsFixed(2);

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  markers: markes,
                  polylines: _polyLines,
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(localizacao.latitude, localizacao.longitude),
                      zoom: 18),
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: MediaQuery.of(context).size.width * .9,
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'R\$ ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            preco,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                        color: Colors.black12,
                        width: 1,
                      ))),
                    ),
                    ButtonTheme(
                        minWidth: 300.0,
                        height: 35,
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.black,
                            child: Text('Confirmar Solicitação'),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)))),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: TextField(
                onTap: () async {
                  Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: "Key",
                      language: "pt",
                      components: [
                        Component(Component.country, "br"),
                      ]);

                  if (p != null) {
                    setState(() {
                      _controllerLocal.text = p.description;
                    });

                    sendRequest(_controllerLocal.text);
                  } else {
                    print('deu ruimn');
                  }
                },
                cursorColor: Colors.black,
                controller: _controllerLocal,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  print(_controllerLocal.text);
                },
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 0, bottom: 0),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Onde deseja realizar o serviço",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 5.0),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 40,
          //   right: 10,
          //   child: FloatingActionButton(
          //     onPressed: _onAddMarkerPressed,
          //     tooltip: 'Adicionar Local',
          //     backgroundColor: Colors.redAccent,
          //     child: Icon(
          //       Icons.add_location,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      localizacao.latitude = position.latitude;
      localizacao.longitude = position.longitude;
      localizacao.localDeRealizacao = placemark[0].name;
      _controllerLocal.text = placemark[0].name;
    });
  }
}
