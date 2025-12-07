part of 'model.dart';

class Country extends Equatable {
  final int? id;
  final String? name;

  const Country({this.id, this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    // API RajaOngkir mengembalikan "country_id" dan "country_name"
    // Kadang ID dikembalikan sebagai String, jadi kita handle konversinya
    return Country(
      id: json['country_id'] is String 
          ? int.tryParse(json['country_id']) 
          : json['country_id'] as int?,
      name: json['country_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  @override
  List<Object?> get props => [id, name];
}