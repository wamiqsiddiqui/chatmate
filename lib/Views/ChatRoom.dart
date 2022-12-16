import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:flutter/material.dart';
import 'package:chatmate/Views/Search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // late Future myFuture;
  bool searchPressed=false,searching=false;
  TextEditingController searchTextEditingController = new TextEditingController();
  searchOnPressed(){
    setState(() {
      searchPressed=!searchPressed;
      searching=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChatRoom'),),
      body: Center(child: ElevatedButton(onPressed: () { FirebaseServices.signOut(); },
      child: Text('Sign out'),),),
    );
    // return Scaffold(
    //   appBar: !searchPressed?AppBar(
    //     title: Text(
    //         "Chat Room"
    //     ),
    //     actions: [
    //       IconButton(icon: Icon(Icons.search), onPressed: (){searchOnPressed();})
    //     ],
    //   ):AppBar(
    //     leading: IconButton( icon: new Icon(Icons.arrow_back), onPressed: (){
    //       searchOnPressed();
    //     }, ),
    //     title: TextField(
    //       controller: searchTextEditingController,
    //       decoration: InputDecoration(
    //           hintText: "Search"
    //       ),
    //       onSubmitted: (input){
    //          myFuture = FirebaseServices.getUsersBySearch(input).then((value){
    //            print("Value= "+value.toString());
    //            setState(() {
    //              searching=true;
    //            });
    //          });
    //       },
    //     ),
    //     actions: <Widget>[
    //       new IconButton( icon: new Icon(Icons.close), onPressed: (){
    //         searchOnPressed();
    //         //widget.onChanged();
    //       }, ),],
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.search),
    //     onPressed: (){
    //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Search()));
    //     },
    //   ),
    //   body: SafeArea(
    //     child: Visibility(
    //       visible: searching,
    //       child: FutureBuilder(
    //         future: myFuture,
    //         builder: (context,snapshot){
    //           switch(snapshot.connectionState){
    //             case ConnectionState.waiting:
    //               return Center(child: CircularProgressIndicator());
    //             default:
    //               if(snapshot.hasError){
    //                 return Center(
    //                     child: SizedBox(
    //                       height: MediaQuery.of(context).size.height/50,
    //                       child: FittedBox(
    //                         child: Text(
    //                           snapshot.error.toString(),
    //                           style: TextStyle(
    //                               fontSize: 24,
    //                               color: Colors.black
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                 );
    //               }else{
    //                 return ListView.builder(
    //                   itemCount: 1,
    //                   itemBuilder: (context,int index){
    //                     return ListTile(
    //                       title: Text("snapshot.data![index].name"),
    //                       subtitle: Text("snapshot.data![index].email"),
    //                     );
    //                   },
    //                 );
    //               }
    //           }
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
