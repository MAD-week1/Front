class HomeModel {
  final String name;
  final String phone;

  HomeModel({required this.name, required this.phone});

  // JSON 데이터를 HomeModel 객체로 변환
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      name: json['name'] ?? 'Unknown',
      phone: json['phone'] ?? 'N/A',
    );
  }

  // HomeModel 객체를 JSON 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}
