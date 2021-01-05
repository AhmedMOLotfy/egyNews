class News {
  Map<String, dynamic> source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;
  News(
      {this.url,
      this.title,
      this.author,
      this.description,
      this.publishedAt,
      this.source,
      this.content,
      this.urlToImage});
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      source: json['source'],
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      publishedAt: json['publishedAt'] as String,
      content: json['content'] as String,
    );
  }
}
