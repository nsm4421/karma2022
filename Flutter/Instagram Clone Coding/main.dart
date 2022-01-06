import 'package:flutter/material.dart';
import './style.dart' as custom_style;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


void main() {
  runApp(MaterialApp(
    theme: custom_style.theme,
    initialRoute: '/',
    routes: {
      '/a' : (context)=>Text('HI')
    },
    home : MyApp()
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var tab = 0;
  var showNavbar = true;
  var data = [];
  var userImage;
  var userContent;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // get 요청 보내기
    var getData = await http.get(
        Uri.parse('https://codingapple1.github.io/app/data.json')
    );
    var bodyData = jsonDecode(getData.body);
    // state에 저장
    setState(() {
      data = bodyData;
    });
  }

  getMoreData() async {
    // get 요청 보내기
    var getData = await http.get(
        Uri.parse('https://codingapple1.github.io/app/more1.json')
    );
    var bodyData = jsonDecode(getData.body);
    // state에 저장
    setState(() {
      data.add(bodyData);
    });
  }

  changeShowNavbar(boolean){
    setState(() {
      showNavbar = boolean;
    });
  }

  setUserContent(userInput){
    setState(() {
      userContent = userInput;
    });
  }

  uploadUserData(){
    var dataToUpload = {
      'id' : data.length,
      'image' : userImage,
      'likes' : 0,
      'date' : DateTime.now().toString(),
      'content' : userContent,
      'liked' : false,
      'user' : 'Karma'
    };
    setState(() {
      data.insert(0, dataToUpload);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty){
      return Scaffold(
          appBar: AppBar(
            title: Text('Instagram Tutorial'),
            actions: [
              IconButton(
                onPressed: () async{
                  var picker = ImagePicker();
                  var image = await picker.pickImage(source: ImageSource.gallery);
                  if(image != null) {
                    setState((){
                      userImage = File(image.path);
                    });
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>UploadPosting(
                        userImage: userImage,
                        setUserContent : setUserContent,
                        uploadUserData : uploadUserData
                    ))
                  );
                },
                icon: Icon(Icons.add_box_rounded),
                iconSize: 30,
              )],
          ),
          body : [
            Home(data : data, getMoreData : getMoreData, changeShowNavbar : changeShowNavbar,
            userImage: userImage,),
            Text('Shop')
          ][tab],
          bottomNavigationBar:
          showNavbar ?
          BottomNavigationBar(
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            currentIndex: tab,
            onTap : (idx){
              setState(() {
                tab = idx;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Home"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: "Shop"
              ),
            ],
          )
              : null

      );
    } else {
      return Container(
        child: Text("NO DATA"),
      );
    }
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.getMoreData, this.changeShowNavbar, this.userImage}) : super(key: key);
  final data;
  final getMoreData;
  final changeShowNavbar;
  final userImage;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  @override
  void initState(){
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent){
        widget.getMoreData();
      }
      if (scroll.position.userScrollDirection.name == 'reverse'){
        widget.changeShowNavbar(false);
      } else {
        widget.changeShowNavbar(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (context, index){
            return ListTile(
                title : Builder(
                  builder: (context){
                    var data_ = widget.data[index];
                    return Posting(
                      imagePath: data_['image'],
                      numLike: data_['likes'],
                      author: data_['user'],
                      posting: data_['content'],
                      date : data_['date'],
                      userImage: widget.userImage,
                    );
                  },
                )
            );
          }
      ),
    );
  }
}

class Posting extends StatefulWidget {
  const Posting({Key? key, this.imagePath, this.numLike, this.author, this.posting, this.date, this.userImage}) : super(key: key);
  final imagePath;
  final numLike;
  final author;
  final posting;
  final date;
  final userImage;

  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child : Column(
        children: [
          widget.imagePath.runtimeType == String
              ?Image.network(widget.imagePath)
              :Image.file(widget.userImage),
          Container(
            constraints: BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up),
                    Text(widget.numLike.toString()),
                  ],
                ),
                Text('Author : ${widget.author}'),
                Text('Date : ${widget.date}'),
                Text(widget.posting)
              ],
            ),
          )
        ],
      )


    );
  }
}

class UploadPosting extends StatelessWidget {
  const UploadPosting({Key? key, this.userImage, this.setUserContent, this.uploadUserData}) : super(key: key);
  final userImage;
  final setUserContent;
  final uploadUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        actions: [
          IconButton(onPressed: (){
            uploadUserData();
            Navigator.pop(context);
          }, icon: Icon(Icons.upload))
        ],
      ),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 200, child: Image.file(userImage)),
          TextField(onChanged: (text){
            setUserContent(text);
          },)
        ],
      )
    );
  }
}

