import 'package:flutter/material.dart';
import '../services/yazar_service.dart';
import '../models/yazar.dart';

class YazarPage extends StatefulWidget {

  @override
  State<YazarPage> createState() => _YazarPageState();

}

class _YazarPageState extends State<YazarPage> {

  late Future<List<Yazar>> yazarlar;

  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController biyografiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    yazarlar = YazarService().getYazarlar();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  void showAddDialog() {
    adController.clear();
    soyadController.clear();
    biyografiController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Yazar Ekle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Ad"),
                ),
                TextField(
                  controller: soyadController,
                  decoration: const InputDecoration(labelText: "Soyad"),
                ),
                TextField(
                  controller: biyografiController,
                  decoration: const InputDecoration(labelText: "Biyografi"),
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
                await YazarService().addYazar(
                  adController.text,
                  soyadController.text,
                  biyografiController.text,
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

  void showEditDialog(Yazar yazar) {
    adController.text = yazar.ad;
    soyadController.text = yazar.soyad;
    biyografiController.text = yazar.biyografi;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yazar Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Ad"),
                ),
                TextField(
                  controller: soyadController,
                  decoration: const InputDecoration(labelText: "Soyad"),
                ),
                TextField(
                  controller: biyografiController,
                  decoration: const InputDecoration(labelText: "Biyografi"),
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
                await YazarService().updateYazar(
                  yazar.id,
                  adController.text,
                  soyadController.text,
                  biyografiController.text,
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

  void deleteYazar(int id) async {
    await YazarService().deleteYazar(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Yazarlar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<Yazar>>(

        future: yazarlar,

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

              final yazar = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    "${yazar.ad} ${yazar.soyad}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(yazar.biyografi),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => showEditDialog(yazar),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteYazar(yazar.id),
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