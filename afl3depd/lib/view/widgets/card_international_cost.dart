part of 'widgets.dart';

class CardInternationalCost extends StatelessWidget {
  final Costs cost;
  const CardInternationalCost(this.cost, {super.key});

  String rupiahMoneyFormatter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  String formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return '-';
    return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.orange), // Warna beda dikit biar unik
      ),
      margin: const EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: ListTile(
        onTap: () {
          // Menggunakan fungsi popup yang sama dari bottom_sheets_cost.dart
          showBottomSheetCost(context, cost);
        },
        title: Text(
          "${cost.name}: ${cost.service}",
          style: const TextStyle(
            color: Colors.orange, // Warna teks oranye untuk internasional
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biaya: ${rupiahMoneyFormatter(cost.cost)}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Estimasi: ${formatEtd(cost.etd)}",
              style: TextStyle(color: Colors.green[800]),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.orange[50],
          child: const Icon(Icons.public, color: Colors.orange), // Icon Globe
        ),
      ),
    );
  }
}