import 'package:flutter/material.dart';
import '../models/kitap_tur_model.dart';
import '../services/kitap_tur_service.dart';

class KitapTurGuncellePage extends StatefulWidget {

  final KitapTur tur;

  const KitapTurGuncellePage({super.key, required this.tur});

  @override
  State<KitapTurGuncellePage> createState() => _KitapTurGuncellePageState();
}

class _KitapTurGuncellePageState extends State<KitapTurGuncellePage> {

  late TextEditingController controller;
  final service = KitapTurService();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.tur.ad);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tür Güncelle"),
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
              child: const Text("Güncelle"),
              onPressed: () async {

                await service.turGuncelle(widget.tur.id, controller.text);

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}