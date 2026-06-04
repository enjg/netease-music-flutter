/// Banner数据模型
class BannerModel {
  final int targetId;
  final int targetType;
  final String pic;
  final String typeTitle;
  final String url;
  final String titleColor;

  const BannerModel({
    required this.targetId,
    required this.targetType,
    required this.pic,
    this.typeTitle = '',
    this.url = '',
    this.titleColor = 'blue',
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      targetId: json['targetId'] ?? 0,
      targetType: json['targetType'] ?? 0,
      pic: json['imageUrl'] ?? json['pic'] ?? json['bigImageUrl'] ?? '',
      typeTitle: json['typeTitle'] ?? '',
      url: json['url'] ?? '',
      titleColor: json['titleColor'] ?? 'blue',
    );
  }
}
