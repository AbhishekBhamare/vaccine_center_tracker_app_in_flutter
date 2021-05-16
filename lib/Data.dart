import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Data extends StatelessWidget {
  List<Centers>centerList = [];

  Future<List<Centers>> _getCenters(id) async{
    var center = await http.get(Uri.parse('https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=${id}&date=31-03-2021'));
    var jsonCenter = json.decode(center.body);
    centerList.clear();
    for(var i in jsonCenter['sessions']){
      Centers temp = Centers(i['center_id'], i['block_name'], i['pincode'], i['vaccine'], i['min_age_limit'], i['fee_type'], i['fee'], i['available_capacity'], i['slots']);
      centerList.add(temp);
    }
    return centerList;
  }


  final int id;
  Data(this.id);
  @override
  Widget build(BuildContext context) {
    _getCenters(id);
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
           children: [
             Padding(
               padding: const EdgeInsets.fromLTRB(28.0,78.0,18.0,18.0),
               child: Text(
                 'Tap on your preferred center from the below list.',
                 style: TextStyle(
                   color: Colors.white70,
                   fontSize: 30,
                   fontFamily: 'Quicksand',
                 ),
               ),
             ),
            Divider(
              color: Colors.black87,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.cyan,
                width: 500,
                height: 500,
                child: FutureBuilder(
                    future:_getCenters(id),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Container(
                          child: SpinKitSquareCircle
                            (
                            color: Colors.white70,
                          ),
                        );
                      }else{
                        if(snapshot.data.length==0){
                          return Center(
                            child: Text(
                              'Sorry.... No Centers found',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 0),
                            alignment: Alignment.center,
                            width: 500,
                            height: 600,
                              child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder:(BuildContext context, int index){
                                  return Center(
                                    child: FlatButton(
                                      color: Colors.cyan,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child:  Text(
                                          '${snapshot.data[index].block_name.toString()}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                      onPressed: () {

                                        showModalBottomSheet<void>(

                                          context: context,
                                          builder: (BuildContext context) {
                                              return Container(
                                              color: Colors.black87,
                                              height: 600,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RichText(
                                                        text: new TextSpan(
                                                          style: new TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.white70,
                                                            fontFamily: 'Quicksand',
                                                          ),
                                                          children: <TextSpan>[
                                                            new TextSpan(text: '${snapshot.data[index].block_name.toString()}\n\n',style: new TextStyle(fontSize:26,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: 'CenterId: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].center_id.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Pincode: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].pincode.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Vaccine: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].vaccine.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Min Age Limit: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].min_age_limit.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Fee Type: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].fee_type.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Fee: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].fee.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Available Capacity: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].available_capacity.toString()}\n\n',style: new TextStyle(fontFamily: 'Quicksand')),
                                                            new TextSpan(text: 'Slot: ',style: new TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                                            new TextSpan(text: '${snapshot.data[index].slots.toString()}',style: new TextStyle(fontFamily: 'Quicksand')),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }
                              ),

                          ),
                        );
                      }
                    }
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Centers{
  dynamic center_id;
  dynamic block_name;
  dynamic pincode;
  dynamic vaccine;
  dynamic min_age_limit;
  dynamic fee_type;
  dynamic fee;
  dynamic available_capacity;
  dynamic slots;

  Centers(this.center_id, this.block_name, this.pincode, this.vaccine, this.min_age_limit, this.fee_type, this.fee, this.available_capacity, this.slots);

}