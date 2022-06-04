import 'dart:convert';
import 'WebView.dart';
import 'components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

const apiKey = "244a6bfed66f42c5b33d5fa6e5835414";

class country extends StatefulWidget {
  int index;
  country({required this.index});
  @override
  State<country> createState() => _countryState();
}

class _countryState extends State<country> {
  List<News> newslist = <News>[];
  List<String> Language = [
    "India",
    "United States",
    "France",
    "Germany",
    "Canada",
    "Australia"
  ];
  List<String> language = [
    "in",
    "us",
    "fr",
    "de",
    "ca",
    "au"
  ];

  bool Loading = true;
  GetNewsCategory(String language) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=$language&apiKey=$apiKey";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          News newsquery = new News();
          newsquery = News.fromMap(element);
          newslist.add(newsquery);
          setState(() {
            Loading = false;
          });
        }
        catch(e){
          print(e);
        }

      });
    });
  }

  @override
  void initState() {
    super.initState();
    String Language=language[widget.index];
    GetNewsCategory(Language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCF0),
      appBar: AppBar(
        title: Text("DAILY NEWS"),
        backgroundColor:Color(0xFFFFA69E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Language[widget.index].toUpperCase(),
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Loading
                  ? Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: Center(child: CircularProgressIndicator()))
                  : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newslist.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsWeb(newslist[index].url)));
                      },
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      newslist[index].Image,
                                      fit: BoxFit.fitHeight,
                                      height: 230,
                                      width: double.infinity,
                                    )),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12
                                                      .withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        padding: EdgeInsets.fromLTRB(
                                            15, 15, 10, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newslist[index].Headline,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              newslist[index]
                                                  .Description
                                                  .length >
                                                  50
                                                  ? "${newslist[index].Description.substring(0, 50)}...."
                                                  : newslist[index]
                                                  .Description,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          ],
                                        )))
                              ],
                            )),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
