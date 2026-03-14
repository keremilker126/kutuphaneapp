import 'package:flutter/material.dart';
import '../services/yayin_evi_service.dart';
import '../models/yayin_evi.dart';

class YayinEviPage extends StatefulWidget {

  @override
  State<YayinEviPage> createState() => _YayinEviPageState();

}

class _YayinEviPageState extends State<YayinEviPage> {

  late Future<List<YayinEvi>> yayinEvleri;

  final TextEditingController adController = TextEditingController();
  final TextEditingController adresController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    yayinEvleri = YayinEviService().getYayinEvleri();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  void showAddDialog() {
    adController.clear();
    adresController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Yayın Evi Ekle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Ad"),
                ),
                TextField(
                  controller: adresController,
                  decoration: const InputDecoration(labelText: "Adres"),
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
                await YayinEviService().addYayinEvi(
                  adController.text,
                  adresController.text,
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

  void showEditDialog(YayinEvi yayin) {
    adController.text = yayin.ad;
    adresController.text = yayin.adres;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yayın Evi Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Ad"),
                ),
                TextField(
                  controller: adresController,
                  decoration: const InputDecoration(labelText: "Adres"),
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
                await YayinEviService().updateYayinEvi(
                  yayin.id,
                  adController.text,
                  adresController.text,
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

  void deleteYayinEvi(int id) async {
    await YayinEviService().deleteYayinEvi(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Yayın Evleri"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<YayinEvi>>(

        future: yayinEvleri,

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

              final yayin = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    yayin.ad,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(yayin.adres),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => showEditDialog(yayin),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteYayinEvi(yayin.id),
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