import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Dist.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Details();
  }
}


class Details extends StatefulWidget {
  const Details({Key key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  dynamic state;
  dynamic stateCon = TextEditingController();
  dynamic suggestionsList = [];
  List<StateAndId>stateList = [];
  Future<List<StateAndId>> _getState() async{
    var state = await http.get(Uri.parse('https://cdn-api.co-vin.in/api/v2/admin/location/states'));
    var jsonState = json.decode(state.body);
    stateList.clear();
    for(var i in jsonState['states']){
      StateAndId temp = StateAndId(i['state_id'], i['state_name']);
      stateList.add(temp);
    }
    for(var i in jsonState['states']){
      if(!suggestionsList.contains(i['state_name'])){
           suggestionsList.add(i['state_name']);
      }
    }
    return stateList;



  }
  @override
  Widget build(BuildContext context) {
    print(suggestionsList);
    _getState();
    return Scaffold(
      resizeToAvoidBottomInset: false,
     backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
              text: new TextSpan(text: 'Hi there,', style:TextStyle(fontFamily: 'Quicksand', fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
             Padding(
               padding: const EdgeInsets.fromLTRB(28.0,18.0,28.0,18.0),
               child: RichText(
                 text: new TextSpan(text: 'Enter the Correct State name in which you wish to find Vaccine Center.', style:TextStyle(fontFamily: 'Quicksand', fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold)),
               ),
             ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AutoCompleteTextField(
                clearOnSubmit: false,
                controller: stateCon,
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
                  hintText: 'Enter State...',
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
                    stateCon.text = item;
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
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            backgroundColor: Colors.cyan,
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
              onPressed: (){
                setState(() {
                  state = stateCon.text;
                  bool flag=false;
                  for(var i in stateList){
                    if(state.toLowerCase() == i.state_name.toLowerCase()){
                      stateCon.text = "";
                      flag=true;
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context)=>District(i.state_id))
                      );
                    }
                  }
                  if(flag == false){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Please enter correct state'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                 Text('Enter correct state with appropriate spelling.'),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


class StateAndId{
  dynamic state_id;
  dynamic state_name;

  // ignore: non_constant_identifier_names
  StateAndId(this.state_id, this.state_name);

}