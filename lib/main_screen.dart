import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/WebView.dart';
import 'package:newsapp/categories.dart';
import 'package:newsapp/country.dart';
import 'components.dart';
import 'package:http/http.dart';

const apiKey = "244a6bfed66f42c5b33d5fa6e5835414";

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  TextEditingController searchcontroller = new TextEditingController();
  List<News> newslider = <News>[];
  List<News> newslist = <News>[];
  List<String> navigationbar = [
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
    "General"
  ];
  List<String> language = [
    "India",
    "United States",
    "France",
    "Germany",
    "Canada",
    "Australia"
  ];

  bool Loading = true;
  GetNews(String country) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apiKey";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          News newsquery = new News();
          newsquery = News.fromMap(element);
          newslist.add(newsquery);
          print(newslist);
          setState(() {
            Loading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
  }

  bool sliderLoading = true;

  GetNewsLangauge(String Language) async {
    String url =
        "https://newsapi.org/v2/top-headlines?language=$Language&apiKey=$apiKey";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          News newsquery = new News();
          newsquery = News.fromMap(element);
          if (newsquery.Image != null) newslider.add(newsquery);
          setState(() {
            sliderLoading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    GetNews("in");
    GetNewsLangauge("en");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCF0),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFA69E),
        title: Text(
          "Daily News",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: navigationbar.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  categories(Category: navigationbar[index])));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Color(0xFFA2D6F9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          navigationbar[index],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFA69E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchcontroller.text).replaceAll(" ", "") == "") {
                        print("Blank Search");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => categories(
                                    Category: searchcontroller.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFF3FCF0),
                      ),
                      margin: EdgeInsets.fromLTRB(4, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      if (value == "") {
                        print("BLANK");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    categories(Category: value)));
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Color(0xFFF3FCF0),
                      )
                    ),
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: sliderLoading
                  ? Center(child: CircularProgressIndicator())
                  : CarouselSlider(
                      items: newslider.map((instance) {
                        return Builder(builder: (BuildContext context) {
                          try {
                            return Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsWeb(instance.url)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(instance.Image,
                                            fit: BoxFit.fill,
                                            height:220,
                                            width: double.infinity),
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Text(
                                              instance.Headline,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        });
                      }).toList(),
                      options: CarouselOptions(
                          height: 235,
                          autoPlay: true,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: true),
                    ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "FRESH NEWS",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewsWeb(newslist[index].url)));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 1.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                        BorderRadius.circular(
                                                            15),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black12
                                                              .withOpacity(0),
                                                          Colors.black
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter)),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Load More',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child:Container(
            height: 45,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: language.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                               country(index: index)));
                  },
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Color(0xFFA2D6F9),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        language[index],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
    );
  }
}
