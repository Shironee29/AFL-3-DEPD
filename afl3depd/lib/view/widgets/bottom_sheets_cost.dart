part of 'widgets.dart';

// Fungsi publik yang akan dipanggil dari CardCost
void showBottomSheetCost(BuildContext context, Costs cost) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Agar tinggi fleksibel dan tidak overflow
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          // Menambahkan padding bawah agar tidak tertutup keyboard/navigasi HP
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Garis Kecil
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Detail Pengiriman",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),

              // Detail Data
              _buildDetailRow("Kurir", cost.name ?? "-"),
              _buildDetailRow("Layanan", cost.service ?? "-"),
              _buildDetailRow("Deskripsi", cost.description ?? "-"),
              _buildDetailRow("Biaya", _rupiahMoneyFormatter(cost.cost)),
              _buildDetailRow("Estimasi Sampai", _formatEtd(cost.etd)),

              const SizedBox(height: 8),

              // Tombol Tutup
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Tutup", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// --- Helper Functions (Private untuk file ini) ---

Widget _buildDetailRow(String key, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            key,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

String _rupiahMoneyFormatter(int? value) {
  if (value == null) return "Rp0,00";
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 2,
  );
  return formatter.format(value);
}

String _formatEtd(String? etd) {
  if (etd == null || etd.isEmpty) return '-';
  return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
}