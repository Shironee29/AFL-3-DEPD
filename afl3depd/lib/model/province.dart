part of 'model.dart';

class Province extends Equatable {
  final String? id;
  final String? name;

  const Province({this.id, this.name});

  // Mengubah JSON dari API menjadi object Province
  factory Province.fromJson(Map<String, dynamic> json) => Province(
    // Perhatikan: RajaOngkir biasanya pakai key 'province_id', bukan 'id' biasa
    id: json['province_id'] as String?, 
    name: json['province'] as String?,
  );

  // Mengubah object Province kembali menjadi JSON
  Map<String, dynamic> toJson() => {
    'province_id': id,
    'province': name,
  };

  @override
  List<Object?> get props => [id, name];
}