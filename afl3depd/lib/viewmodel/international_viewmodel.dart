import 'package:flutter/material.dart';
import 'package:afl3depd/model/model.dart';
import 'package:afl3depd/data/response/api_response.dart';
import 'package:afl3depd/data/response/status.dart';
import 'package:afl3depd/repository/international_repository.dart';

class InternationalViewModel with ChangeNotifier {
  final _repo = InternationalRepository();

  // --- Origin Section (Tetap Sama) ---
  ApiResponse<List<Province>> provinceList = ApiResponse.notStarted();
  void setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }
  Future getProvinceList() async {
    if (provinceList.status == Status.completed) return;
    setProvinceList(ApiResponse.loading());
    _repo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, _) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  void setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }
  Future getCityOriginList(int provId) async {
    setCityOriginList(ApiResponse.loading());
    _repo.fetchCityList(provId).then((value) {
      setCityOriginList(ApiResponse.completed(value));
    }).onError((error, _) {
      setCityOriginList(ApiResponse.error(error.toString()));
    });
  }

  // --- Destination Section (Dropdown Negara) ---
  
  // State untuk menampung hasil pencarian negara
  ApiResponse<List<Country>> countryList = ApiResponse.notStarted();

  void setCountryList(ApiResponse<List<Country>> response) {
    countryList = response;
    notifyListeners();
  }

  // Fungsi untuk mencari negara dan mengisi Dropdown
  Future getCountryList(String keyword) async {
    setCountryList(ApiResponse.loading());
    _repo.searchCountries(keyword).then((value) {
      setCountryList(ApiResponse.completed(value));
    }).onError((error, _) {
      setCountryList(ApiResponse.error(error.toString()));
    });
  }

  // --- Calculation Section ---
  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();
  bool isLoading = false;

  void setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Fungsi Hitung Ongkir (Pakai ID dari Dropdown)
  Future checkShippingCost(
    String originCityId,
    String destinationCountryId, 
    int weight,
    String courier,
  ) async {
    setLoading(true);
    setCostList(ApiResponse.loading());

    _repo.checkInternationalShippingCost(
      originCityId, 
      destinationCountryId, 
      weight, 
      courier
    ).then((value) {
      setCostList(ApiResponse.completed(value));
      setLoading(false);
    }).onError((error, _) {
      setCostList(ApiResponse.error(error.toString()));
      setLoading(false);
    });
  }
}