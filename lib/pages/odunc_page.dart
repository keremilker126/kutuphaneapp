import 'package:flutter/material.dart';
import '../services/odunc_service.dart';
import '../models/odunc.dart';

class OduncPage extends StatefulWidget {

  @override
  State<OduncPage> createState() => _OduncPageState();

}

class _OduncPageState extends State<OduncPage> {

  late Future<List<Odunc>> oduncler;

  final TextEditingController uyeIdController = TextEditingController();
  final TextEditingController kitapIdController = TextEditingController();
  final TextEditingController getirmesiTarihiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    oduncler = OduncService().getOduncler();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  void showAddDialog() {
    uyeIdController.clear();
    kitapIdController.clear();
    getirmesiTarihiController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Ödünç Ekle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: uyeIdController,
                  decoration: const InputDecoration(labelText: "Üye ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kitapIdController,
                  decoration: const InputDecoration(labelText: "Kitap ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: getirmesiTarihiController,
                  decoration:
                      const InputDecoration(labelText: "Getirmesi Gereken Tarih"),
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
                await OduncService().kitapVer(
                  int.tryParse(uyeIdController.text) ?? 0,
                  int.tryParse(kitapIdController.text) ?? 0,
                  getirmesiTarihiController.text,
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

  void showEditDialog(Odunc odunc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Teslim Al"),
          content: const Text("Bu ödünç kaydını teslim almayı onaylıyor musunuz?"),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Teslim Al"),
              onPressed: () async {
                await OduncService().kitapTeslimAl(odunc.id);
                Navigator.pop(context);
                refresh();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteOdunc(int id) async {
    await OduncService().deleteOdunc(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Ödünçler"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<Odunc>>(

        future: oduncler,

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

              final odunc = snapshot.data![index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    "Üye: ${odunc.uyeId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kitap: ${odunc.kitapId}"),
                      Text("Veriliş: ${odunc.verilisTarihi}"),
                      Text("Getirmesi gereken: ${odunc.getirmesiIstenenTarih}"),
                      if (odunc.teslimTarihi != null)
                        Text("Teslim: ${odunc.teslimTarihi}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => showEditDialog(odunc),
                        tooltip: "Teslim Al",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteOdunc(odunc.id),
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