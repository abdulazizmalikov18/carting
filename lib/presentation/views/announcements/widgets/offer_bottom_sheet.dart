import 'package:carting/assets/assets/icons.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class OfferBottomSheet extends StatefulWidget {
  const OfferBottomSheet({super.key});

  @override
  State<OfferBottomSheet> createState() => _OfferBottomSheetState();
}

class _OfferBottomSheetState extends State<OfferBottomSheet> {
  String selectedCar = "01 A 111 AA"; // Default car number
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC2C2C2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "ID 52229041",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "E'lon uchun taklif yuborish",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    AppIcons.car.svg(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCar,
                        items: ["01 A 111 AA", "02 B 222 BB", "03 C 333 CC"]
                            .map((car) => DropdownMenuItem(
                                  value: car,
                                  child: Text(car),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCar = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Narx taklif qiling!",
                    suffixText: "UZS",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                WButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "Taklif yuborish",
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
