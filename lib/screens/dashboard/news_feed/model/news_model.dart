import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  String? coinImage;
  String? coinDescription;
  String? coinHeading;
  String? newsId;
  String? category;
  String? assetName;
  List<dynamic>? totalLikes = [];
  List<dynamic>? totalDislikes = [];
  DateTime? createdAt;
  String? createdBy;
  String? topicTitle;
  bool? marketsCard;
  List<dynamic>? readBy = [];

  NewsModel(
      {this.coinImage,
      this.coinDescription,
      this.assetName,
      this.coinHeading,
      this.newsId,
      this.totalLikes,
      this.totalDislikes,
      this.createdAt,
      this.category,
      this.createdBy,
      this.topicTitle,
      this.marketsCard,
      this.readBy});

  NewsModel.fromJson(Map<String, dynamic> json) {
    coinImage = json['coinImage'];
    coinDescription = json['coinDescription'];
    coinHeading = json['coinHeading'];
    assetName = json['assetName'];
    newsId = json['newsId'];
    totalLikes = json['totalLikes'];
    totalDislikes = json['totalDislikes'];
    createdAt = json['createdAt'].toDate();
    category = json['category'];
    readBy = json['readBy'];
  }
  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      coinImage: map['coinImage'] ??
          'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
      coinDescription: map['coinDescription'] ?? '',
      coinHeading: map['coinHeading'] ?? '',
      assetName: map['assetName'] ?? '',
      newsId: map['newsId'] ?? '',
      totalLikes: map['totalLikes'] ?? 0,
      totalDislikes: map['totalDislikes'] ?? 0,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      category: map['category'] ?? '',
      createdBy: map['createdBy'] ?? '',
      topicTitle: map['topicTitle'] ?? '',
      marketsCard: map['marketCards'] ?? false,
      readBy: map['readBy'] ?? [],
    );
  }
}
