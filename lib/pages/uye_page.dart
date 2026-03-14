import 'package:flutter/material.dart';
import '../services/uye_service.dart';
import '../models/uye.dart';

class UyePage extends StatefulWidget {

  @override
  State<UyePage> createState() => _UyePageState();

}

class _UyePageState extends State<UyePage> {

  late Future<List<Uye>> uyeler;

  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController epostaController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    uyeler = UyeService().getUyeler();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  void showAddDialog() {
    adController.clear();
    soyadController.clear();
    epostaController.clear();
    telefonController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Üye Ekle"),
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
                  controller: epostaController,
                  decoration: const InputDecoration(labelText: "E-posta"),
                ),
                TextField(
                  controller: telefonController,
                  decoration: const InputDecoration(labelText: "Telefon"),
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
                await UyeService().addUye(
                  adController.text,
                  soyadController.text,
                  epostaController.text,
                  telefonController.text,
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

  void showEditDialog(Uye uye) {
    adController.text = uye.ad;
    soyadController.text = uye.soyad;
    epostaController.text = uye.eposta;
    telefonController.text = uye.telefon;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Üye Düzenle"),
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
                  controller: epostaController,
                  decoration: const InputDecoration(labelText: "E-posta"),
                ),
                TextField(
                  controller: telefonController,
                  decoration: const InputDecoration(labelText: "Telefon"),
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
                await UyeService().updateUye(
                  uye.id,
                  adController.text,
                  soyadController.text,
                  epostaController.text,
                  telefonController.text,
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

  void deleteUye(int id) async {
    await UyeService().deleteUye(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Üyeler"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<Uye>>(

        future: uyeler,

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

              final uye = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    "${uye.ad} ${uye.soyad}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(uye.eposta),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => showEditDialog(uye),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteUye(uye.id),
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