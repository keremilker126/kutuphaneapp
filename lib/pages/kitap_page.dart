import 'package:flutter/material.dart';
import '../models/kitap.dart';
import '../services/kitap_service.dart';

class KitapPage extends StatefulWidget {

  @override
  State<KitapPage> createState() => _KitapPageState();

}

class _KitapPageState extends State<KitapPage> {

  late Future<List<Kitap>> kitaplar;

  final TextEditingController adController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController sayfaSayisiController = TextEditingController();
  final TextEditingController yazarIdController = TextEditingController();
  final TextEditingController yayinEviIdController = TextEditingController();
  final TextEditingController turIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    kitaplar = KitapService().getKitaplar();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  void showAddDialog() {
    adController.clear();
    isbnController.clear();
    sayfaSayisiController.clear();
    yazarIdController.clear();
    yayinEviIdController.clear();
    turIdController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Kitap Ekle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Kitap Adı"),
                ),
                TextField(
                  controller: isbnController,
                  decoration: const InputDecoration(labelText: "ISBN"),
                ),
                TextField(
                  controller: sayfaSayisiController,
                  decoration: const InputDecoration(labelText: "Sayfa Sayısı"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: yazarIdController,
                  decoration: const InputDecoration(labelText: "Yazar ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: yayinEviIdController,
                  decoration: const InputDecoration(labelText: "Yayın Evi ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: turIdController,
                  decoration: const InputDecoration(labelText: "Tür ID"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Kaydet"),
              onPressed: () async {
                await KitapService().addKitap(
                  adController.text,
                  isbnController.text,
                  int.tryParse(sayfaSayisiController.text) ?? 0,
                  int.tryParse(yazarIdController.text) ?? 0,
                  int.tryParse(yayinEviIdController.text) ?? 0,
                  int.tryParse(turIdController.text) ?? 0,
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

  void showEditDialog(Kitap kitap) {
    adController.text = kitap.ad;
    isbnController.text = kitap.isbn;
    sayfaSayisiController.text = kitap.sayfaSayisi.toString();
    yazarIdController.text = kitap.yazarId.toString();
    yayinEviIdController.text = kitap.yayinEviId.toString();
    turIdController.text = kitap.turId.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Kitap Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Kitap Adı"),
                ),
                TextField(
                  controller: isbnController,
                  decoration: const InputDecoration(labelText: "ISBN"),
                ),
                TextField(
                  controller: sayfaSayisiController,
                  decoration: const InputDecoration(labelText: "Sayfa Sayısı"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: yazarIdController,
                  decoration: const InputDecoration(labelText: "Yazar ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: yayinEviIdController,
                  decoration: const InputDecoration(labelText: "Yayın Evi ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: turIdController,
                  decoration: const InputDecoration(labelText: "Tür ID"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Güncelle"),
              onPressed: () async {
                await KitapService().updateKitap(
                  kitap.id,
                  adController.text,
                  isbnController.text,
                  int.tryParse(sayfaSayisiController.text) ?? 0,
                  int.tryParse(yazarIdController.text) ?? 0,
                  int.tryParse(yayinEviIdController.text) ?? 0,
                  int.tryParse(turIdController.text) ?? 0,
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

  void deleteKitap(int id) async {
    await KitapService().deleteKitap(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Kitaplar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<Kitap>>(

        future: kitaplar,

        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text("Veri bulunamadı"));
          }

          return ListView.builder(

            itemCount: snapshot.data!.length,

            itemBuilder: (context,index){

              final kitap = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    kitap.ad,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("ISBN: ${kitap.isbn}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => showEditDialog(kitap),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteKitap(kitap.id),
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