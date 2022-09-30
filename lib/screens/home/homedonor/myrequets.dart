import 'package:app/screens/home/homedonor/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Myrequets extends StatefulWidget {
  final String title;
  final String uid; //include this
  Myrequets({Key key, this.title, this.uid}) : super(key: key);
  @override
  _MyrequetsState createState() => _MyrequetsState();
}

class _MyrequetsState extends State<Myrequets> {
  var abc;
  var allRequestData;
  var requestdata;
  var len;

  Future<void> getData() async {
    requestdata = await Firestore.instance
        .collection('request')
        .where('email', isEqualTo: widget.uid)
        .getDocuments();

    allRequestData =
    await requestdata.documents.map((doc) => doc.data).toList();

    print(allRequestData);
    print(1);
    setState(() {
      abc = allRequestData;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My active requests"),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                    //title: variable.data['name'],
                    uid: this.widget.uid,
                  ))).then((result) {
            Navigator.of(context).pop();
          });
        },
        child: Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: allRequestData.length,
          itemBuilder: (context, index) {
            return Container(
              height: 230,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),

                // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      //onTap: () => showAlertDialog(context),

                      title: Text(
                        '\nBlood group required - ${allRequestData[index]['blood group']}\n',
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),

                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            'Patient Name - ${allRequestData[index]['name']}\nPatient Age - ${allRequestData[index]['age']}\nMaximum requested distance - ${allRequestData[index]['maxdistance']} \nMinimum Age for donating - ${allRequestData[index]['min age']} \n Reason for seeking blood - ${allRequestData[index]['reason']}\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}