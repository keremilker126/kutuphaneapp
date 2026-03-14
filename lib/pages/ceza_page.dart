import 'package:flutter/material.dart';
import '../services/ceza_service.dart';
import '../models/ceza.dart';

class CezaPage extends StatefulWidget {
  @override
  State<CezaPage> createState() => _CezaPageState();
}

class _CezaPageState extends State<CezaPage> {

  late Future<List<Ceza>> cezalar;

  final TextEditingController oduncIdController = TextEditingController();
  final TextEditingController tutarController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    cezalar = CezaService().getCezalar();
  }

  void refresh() {
    setState(() {
      loadData();
    });
  }

  void showAddDialog() {
    oduncIdController.clear();
    tutarController.clear();
    aciklamaController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Ceza Ekle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oduncIdController,
                  decoration: const InputDecoration(labelText: "Ödünç ID"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: tutarController,
                  decoration: const InputDecoration(labelText: "Tutar"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: aciklamaController,
                  decoration: const InputDecoration(labelText: "Açıklama"),
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
                await CezaService().createCeza(
                  int.tryParse(oduncIdController.text) ?? 0,
                  double.tryParse(tutarController.text) ?? 0,
                  aciklamaController.text,
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

  void showEditDialog(Ceza ceza) {
    tutarController.text = ceza.tutar.toString();
    aciklamaController.text = ceza.aciklama;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ceza Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tutarController,
                  decoration: const InputDecoration(labelText: "Tutar"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: aciklamaController,
                  decoration: const InputDecoration(labelText: "Açıklama"),
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
                await CezaService().updateCeza(
                  ceza.id,
                  double.tryParse(tutarController.text) ?? 0,
                  aciklamaController.text,
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

  void deleteCeza(int id) async {
    await CezaService().deleteCeza(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Cezalar"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<Ceza>>(

        future: cezalar,

        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text("Ceza bulunamadı"));
          }

          return ListView.builder(

            padding: const EdgeInsets.all(10),

            itemCount: snapshot.data!.length,

            itemBuilder: (context,index){

              final ceza = snapshot.data![index];

              return Card(

                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(

                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Ceza ID: ${ceza.id}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4
                            ),
                            decoration: BoxDecoration(
                              color: ceza.odendiMi
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ceza.odendiMi ? "Ödendi" : "Ödenmedi",
                              style: const TextStyle(color: Colors.white),
                            ),
                          )

                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Tutar: ${ceza.tutar} ₺",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Açıklama: ${ceza.aciklama}",
                        style: const TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 10),

                      const Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.orange,
                              size: 28,
                            ),
                            tooltip: "Düzenle",
                            onPressed: (){
                              showEditDialog(ceza);
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 28,
                            ),
                            tooltip: "Sil",
                            onPressed: (){
                              deleteCeza(ceza.id);
                            },
                          ),

                          if(!ceza.odendiMi)
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                              tooltip: "Cezayı Bitir",
                              onPressed: (){
                                CezaService().cezaOde(ceza.id).then((_) {
                                  refresh();
                                });
                              },
                            )
                          else
                            const Text(
                              "Tamamlandı",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold
                              ),
                            )
                        ],
                      )

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