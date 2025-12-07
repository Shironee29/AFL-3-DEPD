import 'package:flutter/material.dart';
import 'package:afl3depd/model/model.dart';
import 'package:afl3depd/data/response/api_response.dart';
import 'package:afl3depd/data/response/status.dart';
import 'package:afl3depd/repository/home_repository.dart';

// ViewModel untuk mengelola data dan state Home (provinsi, kota, ongkir)
class HomeViewModel with ChangeNotifier {
  // Repository untuk akses API
  final _homeRepo = HomeRepository();

  // State daftar provinsi
  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();
  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  // Ambil daftar provinsi
  Future getProvinceList() async {
    if (provinceList.status == Status.completed) return;
    setProvinceList(ApiResponse.loading());
    _homeRepo
        .fetchProvinceList()
        .then((value) {
          setProvinceList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setProvinceList(ApiResponse.error(error.toString()));
        });
  }

  // === PERBAIKAN DI SINI (Ubah Key Cache jadi String) ===
  // Cache kota per id provinsi agar tidak panggil API berulang
  final Map<String, List<City>> _cityCache = {};

  // State daftar kota asal
  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

  // === PERBAIKAN DI SINI (Parameter ubah jadi String) ===
  // Ambil kota asal
  Future getCityOriginList(String provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityOriginList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }
    setCityOriginList(ApiResponse.loading());
    _homeRepo
        .fetchCityList(provId)
        .then((value) {
          _cityCache[provId] = value;
          setCityOriginList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setCityOriginList(ApiResponse.error(error.toString()));
        });
  }

  // State daftar kota tujuan
  ApiResponse<List<City>> cityDestinationList = ApiResponse.notStarted();
  setCityDestinationList(ApiResponse<List<City>> response) {
    cityDestinationList = response;
    notifyListeners();
  }

  // === PERBAIKAN DI SINI (Parameter ubah jadi String) ===
  // Ambil kota tujuan
  Future getCityDestinationList(String provId) async {
    if (_cityCache.containsKey(provId)) {
      setCityDestinationList(ApiResponse.completed(_cityCache[provId]!));
      return;
    }
    setCityDestinationList(ApiResponse.loading());
    _homeRepo
        .fetchCityList(provId)
        .then((value) {
          _cityCache[provId] = value;
          setCityDestinationList(ApiResponse.completed(value));
        })
        .onError((error, _) {
          setCityDestinationList(ApiResponse.error(error.toString()));
        });
  }

  // State daftar biaya ongkir
  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();
  setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  // Flag loading untuk proses cek ongkir
  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Hitung biaya pengiriman
  Future checkShipmentCost(
    String origin,
    String originType,
    String destination,
    String destinationType,
    int weight,
    String courier,
  ) async {
    setLoading(true);
    setCostList(ApiResponse.loading());
    _homeRepo
        .checkShipmentCost(
          origin,
          originType,
          destination,
          destinationType,
          weight,
          courier,
        )
        .then((value) {
          setCostList(ApiResponse.completed(value));
          setLoading(false);
        })
        .onError((error, _) {
          setCostList(ApiResponse.error(error.toString()));
          setLoading(false);
        });
  }
}