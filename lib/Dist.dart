import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Data.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class District extends StatefulWidget {
  final int id;
  District(this.id);

  @override
  _DistrictState createState() => _DistrictState();
}

class _DistrictState extends State<District> {
  dynamic disCon = TextEditingController();
  dynamic dist;
  dynamic suggestionsList = [];
  List<DistAndId>distList = [];

  Future<List<DistAndId>> _getDistrict(id) async{
    var dist = await http.get(Uri.parse('https://cdn-api.co-vin.in/api/v2/admin/location/districts/${id}'));
    var jsonDist = json.decode(dist.body);
    //print(jsonDist);
    distList.clear();
    for(var i in jsonDist['districts']){
      DistAndId temp = DistAndId(i['district_id'], i['district_name']);
      distList.add(temp);
    }
    for(var i in jsonDist['districts']){
      if(!suggestionsList.contains(i['district_name'])){
        suggestionsList.add(i['district_name']);
      }
    }
    return distList;
  }

  @override
  Widget build(BuildContext context) {
    _getDistrict(widget.id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
           children: <Widget>[
         Padding(
           padding: const EdgeInsets.fromLTRB(68.0,48.0,68.0,18.0),
           child: CircleAvatar(
            radius: 70.0,
            backgroundImage:
            AssetImage('assets/top.png'),
            backgroundColor: Colors.transparent,
        ),
         ),
      RichText(
        text: new TextSpan(text: 'Almost there,', style:TextStyle(fontFamily: 'Quicksand', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(28.0,18.0,28.0,18.0),
        child: RichText(
          text: new TextSpan(text: 'Enter the Correct District name in which you wish to find Vaccine Center.', style:TextStyle(fontFamily: 'Quicksand', fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold)),
        ),
      ),
            Padding(
                padding: const EdgeInsets.all(16.0),
              child: AutoCompleteTextField(
                clearOnSubmit: false,
                controller: disCon,
                suggestions: suggestionsList,
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    //borderSide: new BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.cyan[400],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.cyan, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter District...',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                itemFilter: (item, query){
                  return item.toLowerCase().startsWith(query.toLowerCase());
                },
                itemSorter: (a,b){
                  return a.compareTo(b);
                },
                itemSubmitted: (item){
                  setState(() {
                    disCon.text = item;
                  });
                },
                itemBuilder: (context,item){
                  return Container(
                    color: Colors.cyan,
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          item,
                          style: TextStyle(
                            backgroundColor: Colors.cyan,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  );
                }, key: null,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 500,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: FittedBox(
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  dist = disCon.text;
                  bool flag = false;
                  for (var i in distList) {
                    if (dist.toLowerCase() == i.district_name.toLowerCase()) {
                      disCon.text = "";
                      flag = true;
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context)=>Data(i.district_id))
                      );
                    }
                  }
                  if (flag == false) {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Please enter correct district'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'Enter correct District with appropriate spelling.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
              label: Text(
                '\b\b\b\b\b\b\bContinue\b\b\b\b\b\b\b',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                ),
              ),
              backgroundColor: Colors.cyan[200],
              foregroundColor: Colors.white70,
              elevation: 10,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}


class DistAndId{
  dynamic district_id;
  dynamic district_name;

  DistAndId(this.district_id,this.district_name);
}