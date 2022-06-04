class News
{
  String Headline;
  String Description;
  String url;
  String Image;
  News({this.Headline="NEWS",this.Description="NEWS INFORMATION",this.url=" ",this.Image=" "});

  factory News.fromMap(Map news){
    return News(
      Headline: news["title"],
      Description: news["description"],
      url: news["url"],
      Image: news["urlToImage"]
    );
  }
}