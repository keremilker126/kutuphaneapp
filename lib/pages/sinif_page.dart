import 'package:flutter/material.dart';
import 'package:kutuphaneapp/models/sinif.dart';
import '../services/sinif_service.dart';
import '../models/sinif.dart';

class SinifPage extends StatefulWidget {
  @override
  State<SinifPage> createState() => _SinifPageState();
}

class _SinifPageState extends State<SinifPage> {
  late Future<List<Sinif>> siniflar;

  final TextEditingController adController = TextEditingController();
  final TextEditingController seviyeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    siniflar = SinifService().getSiniflar();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  // ------------------ EKLE ------------------
  void showAddDialog() {
    adController.clear();
    seviyeController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Sınıf Ekle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Sınıf Adı"),
                ),
                TextField(
                  controller: seviyeController,
                  decoration: const InputDecoration(labelText: "Seviye"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Kaydet"),
              onPressed: () async {
                await SinifService().addSinif(
                  adController.text,
                  int.parse(seviyeController.text),
                );
                Navigator.pop(context);
                refresh();
              },
            ),
          ],
        );
      },
    );
  }

  // ------------------ DÜZENLE ------------------
  void showEditDialog(Sinif sinif) {
    adController.text = sinif.ad;
    seviyeController.text = sinif.seviye.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sınıf Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Sınıf Adı"),
                ),
                TextField(
                  controller: seviyeController,
                  decoration: const InputDecoration(labelText: "Seviye"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Güncelle"),
              onPressed: () async {
                await SinifService().updateSinif(
                  sinif.id,
                  adController.text,
                  int.parse(seviyeController.text),
                );
                Navigator.pop(context);
                refresh();
              },
            ),
          ],
        );
      },
    );
  }

  // ------------------ SİL ------------------
  void deleteSinif(int id) async {
    await SinifService().deleteSinif(id);
    refresh();
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sınıflar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Sinif>>(
        future: siniflar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Veri bulunamadı"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final sinif = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    sinif.ad,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Seviye: ${sinif.seviye}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => showEditDialog(sinif),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteSinif(sinif.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}