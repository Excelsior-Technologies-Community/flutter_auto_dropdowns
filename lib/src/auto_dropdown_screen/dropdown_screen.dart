import 'package:flutter/material.dart';
import 'package:flutter_auto_dropdowns/src/data/get_default_data.dart';
import 'package:flutter_auto_dropdowns/src/widgets/app_dropdown.dart';

class DropdownScreen extends StatefulWidget {
  const DropdownScreen({super.key});

  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  final TextEditingController gstCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController paymentCtrl = TextEditingController();
  final TextEditingController currenciesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dropdown Demo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppDropdown<String>(
              label: "GST",
              controller: gstCtrl,
              // manual typing allowed
              mode: Mode.gst,

              display: (e) => e,
              onChanged: (val) {
                gstCtrl.text = val ?? "";
                print("GST Selected: $val");
              },
              prefixIcon: Icons.receipt_long,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 12),

            ),
            const SizedBox(height: 15),

            AppDropdown<String>(
              label: "Country",
              controller: countryCtrl,
              mode: Mode.country,
              display: (e) => e,
              onChanged: (val) {
                countryCtrl.text = val ?? "";
                print("Country Selected: $val");
              },
              prefixIcon: Icons.public,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            const SizedBox(height: 15),
            AppDropdown<String>(
              label: "Payment Mode",
              controller: paymentCtrl,
              mode: Mode.paymentMode,
              isMultiSelect: true,
              display: (e) => e,
              onMultiChanged: (val) {
                paymentCtrl.text = val.join(", ");
                print("Payment Selected: $val");
              },
              prefixIcon: Icons.payment,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              chipsClosable: true,
            ),
            SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Currencies',
              mode: Mode.currency,
              controller: currenciesCtrl,
              isMultiSelect: true,
              display: (e) => e,
              onMultiChanged: (val) {
                currenciesCtrl.text = val.join(",");
                print('Currencies Selected: $val');
              },
              prefixIcon: Icons.attach_money,
              borderRadius: 12,
              padding: EdgeInsets.symmetric(horizontal: 12),
              chipsClosable: true,

            ),

          ],
        ),
      ),
    );
  }
}
