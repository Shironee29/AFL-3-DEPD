part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  late InternationalViewModel internationalViewModel;
  
  final weightController = TextEditingController();
  final countrySearchController = TextEditingController(); // Input keyword pencarian

  final List<String> courierOptions = ["jne", "pos", "tiki"];
  String selectedCourier = "jne";

  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  int? selectedCountryDestinationId; // ID Negara yang dipilih dari Dropdown

  @override
  void initState() {
    super.initState();
    internationalViewModel = Provider.of<InternationalViewModel>(context, listen: false);
    
    if (internationalViewModel.provinceList.status == Status.notStarted) {
      internationalViewModel.getProvinceList();
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    countrySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // --- Section Kurir & Berat ---
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                items: courierOptions.map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.toUpperCase()),
                                )).toList(),
                                onChanged: (v) => setState(() => selectedCourier = v ?? "jne"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Berat (gr)'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- Section Origin (Indonesia) ---
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Origin (Indonesia)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<InternationalViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.provinceList.status == Status.loading) {
                                    return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
                                  }
                                  final provinces = vm.provinceList.data ?? [];
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Pilih Provinsi'),
                                    items: provinces.map((p) => DropdownMenuItem(
                                      value: p.id,
                                      child: Text(p.name ?? '', overflow: TextOverflow.ellipsis),
                                    )).toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null;
                                      });
                                      if (newId != null) vm.getCityOriginList(newId);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Consumer<InternationalViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.cityOriginList.status == Status.loading) {
                                    return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
                                  }
                                  final cities = vm.cityOriginList.data ?? [];
                                  final validIds = cities.map((c) => c.id).toSet();
                                  final validValue = validIds.contains(selectedCityOriginId) ? selectedCityOriginId : null;

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: validValue,
                                    hint: const Text('Pilih Kota'),
                                    items: cities.map((c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.name ?? '', overflow: TextOverflow.ellipsis),
                                    )).toList(),
                                    onChanged: (newId) => setState(() => selectedCityOriginId = newId),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- Section Destination (International) ---
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Destination (International)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        
                        // 1. Input Pencarian Negara
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: countrySearchController,
                                decoration: const InputDecoration(
                                  labelText: 'Cari Negara',
                                  hintText: 'Ketik nama negara (Inggris)',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    // Reset pilihan saat cari baru
                                    setState(() => selectedCountryDestinationId = null);
                                    internationalViewModel.getCountryList(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (countrySearchController.text.isNotEmpty) {
                                  FocusScope.of(context).unfocus();
                                  setState(() => selectedCountryDestinationId = null);
                                  internationalViewModel.getCountryList(countrySearchController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.orange[800],
                              ),
                              child: const Icon(Icons.search, color: Colors.white),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),

                        // 2. Dropdown Hasil Pencarian
                        Consumer<InternationalViewModel>(
                          builder: (context, vm, _) {
                            if (vm.countryList.status == Status.loading) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: LinearProgressIndicator(color: Colors.orange),
                              );
                            }
                            
                            if (vm.countryList.status == Status.error) {
                              return Text("Error: ${vm.countryList.message}", style: const TextStyle(color: Colors.red));
                            }

                            final countries = vm.countryList.data ?? [];
                            
                            // Jika user sudah mencari tapi hasil kosong
                            if (vm.countryList.status == Status.completed && countries.isEmpty) {
                              return const Text("Negara tidak ditemukan.", style: TextStyle(color: Colors.grey));
                            }

                            // Jika belum ada data (awal)
                            if (countries.isEmpty) return const SizedBox.shrink();

                            // Validasi ID
                            final validIds = countries.map((c) => c.id).toSet();
                            final validValue = validIds.contains(selectedCountryDestinationId) 
                                ? selectedCountryDestinationId 
                                : null;

                            return DropdownButton<int>(
                              isExpanded: true,
                              value: validValue,
                              hint: const Text('Pilih Negara dari hasil pencarian'),
                              items: countries.map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name ?? ''),
                              )).toList(),
                              onChanged: (newId) => setState(() => selectedCountryDestinationId = newId),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // --- Tombol Hitung ---
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedCityOriginId != null &&
                                  selectedCountryDestinationId != null &&
                                  weightController.text.isNotEmpty) {
                                
                                final weight = int.tryParse(weightController.text) ?? 0;
                                if (weight <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berat harus > 0')));
                                  return;
                                }
                                
                                // Panggil fungsi hitung dengan ID yang sudah dipilih
                                internationalViewModel.checkShippingCost(
                                  selectedCityOriginId.toString(),
                                  selectedCountryDestinationId.toString(),
                                  weight,
                                  selectedCourier,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua field!')));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[800],
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Text("Hitung Ongkir International", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Hasil Ongkir ---
                Card(
                  color: Colors.orange[50],
                  elevation: 2,
                  child: Consumer<InternationalViewModel>(
                    builder: (context, vm, _) {
                      switch (vm.costList.status) {
                        case Status.loading:
                          return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
                        case Status.error:
                          return Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(vm.costList.message ?? 'Error', style: const TextStyle(color: Colors.red))));
                        case Status.completed:
                          if (vm.costList.data == null || vm.costList.data!.isEmpty) {
                            return const Padding(padding: EdgeInsets.all(16), child: Center(child: Text("Tidak ada data ongkir.")));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.costList.data!.length,
                            itemBuilder: (context, index) => CardInternationalCost(vm.costList.data![index]),
                          );
                        default:
                          return const Padding(padding: EdgeInsets.all(16), child: Center(child: Text("Cari negara, pilih, lalu hitung.")));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Loading Overlay
          Consumer<InternationalViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator(color: Colors.white)));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}