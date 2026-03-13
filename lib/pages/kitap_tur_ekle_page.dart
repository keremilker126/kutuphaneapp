import 'package:flutter/material.dart';
import '../services/kitap_tur_service.dart';

class KitapTurEklePage extends StatefulWidget {
  const KitapTurEklePage({super.key});

  @override
  State<KitapTurEklePage> createState() => _KitapTurEklePageState();
}

class _KitapTurEklePageState extends State<KitapTurEklePage> {

  final TextEditingController controller = TextEditingController();
  final service = KitapTurService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tür Ekle"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Tür Adı",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Ekle"),
              onPressed: () async {

                await service.turEkle(controller.text);

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}