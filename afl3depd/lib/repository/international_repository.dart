import 'package:afl3depd/data/network/network_api_service.dart';
import 'package:afl3depd/model/model.dart';

class InternationalRepository {
  final _apiServices = NetworkApiServices();

  // Fetch Province & City (Tetap sama, tidak saya tulis ulang agar hemat tempat)
  Future<List<Province>> fetchProvinceList() async {
    final response = await _apiServices.getApiResponse('destination/province');
    final data = response['data'];
    if (data is! List) return [];
    return data.map((e) => Province.fromJson(e)).toList();
  }

  Future<List<City>> fetchCityList(var provId) async {
    final response = await _apiServices.getApiResponse('destination/city/$provId');
    final data = response['data'];
    if (data is! List) return [];
    return data.map((e) => City.fromJson(e)).toList();
  }

  // 1. Cari Negara untuk mendapatkan ID
  Future<List<Country>> searchCountries(String keyword) async {
    // PERBAIKAN 1: Encode keyword user
    final encodedKeyword = Uri.encodeComponent(keyword);
    
    // PERBAIKAN 2: Masukkan encodedKeyword ke URL (JANGAN HARDCODE 'ind')
    final response = await _apiServices.getApiResponse(
      'destination/international-destination?search=$encodedKeyword&limit=20'
    );

    final meta = response['meta'];
    
    if (meta != null && (meta['code'] == 404 || meta['status'] != 'success')) {
      return [];
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Country.fromJson(e)).toList();
  }

  // 2. Hitung Ongkir menggunakan ID Negara
  Future<List<Costs>> checkInternationalShippingCost(
    String originCityId,
    String destinationCountryId, // INI HARUS ID (Angka)
    int weight,
    String courier,
  ) async {
    final response = await _apiServices.postApiResponse(
      'calculate/international-cost', 
      {
        "origin": originCityId,
        "destination": destinationCountryId,
        "weight": weight.toString(),
        "courier": courier,
      },
    );

    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Gagal menghitung ongkir'}");
    }

    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }
}