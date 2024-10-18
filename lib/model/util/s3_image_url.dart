class S3ImageUrl {
  final String imageUrl;

  S3ImageUrl({required this.imageUrl});

  factory S3ImageUrl.fromJson(Map<String, dynamic> json) {
    return S3ImageUrl(
      imageUrl: json['imageUrl'] as String,
    );
  }
}
