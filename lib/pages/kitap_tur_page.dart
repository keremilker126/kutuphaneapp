import 'package:flutter/material.dart';
import '../models/kitap_tur.dart';
import '../services/kitap_tur_service.dart';

class KitapTurPage extends StatefulWidget {
  @override
  State<KitapTurPage> createState() => _KitapTurPageState();
}

class _KitapTurPageState extends State<KitapTurPage> {

  late Future<List<KitapTur>> turler;

  final TextEditingController adController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData(){
    turler = KitapTurService().getTurler();
  }

  void refresh(){
    setState(() {
      loadData();
    });
  }

  /// EKLEME DIALOG
  void showAddDialog(){

    adController.clear();

    showDialog(
      context: context,
      builder: (context){

        return AlertDialog(

          title: const Text("Yeni Tür Ekle"),

          content: TextField(
            controller: adController,
            decoration: const InputDecoration(
              labelText: "Tür Adı"
            ),
          ),

          actions: [

            TextButton(
              child: const Text("İptal"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),

            ElevatedButton(

              child: const Text("Kaydet"),

              onPressed: () async {

                await KitapTurService().turEkle(adController.text);

                Navigator.pop(context);

                refresh();

              },

            )

          ],

        );

      }
    );

  }

  /// GÜNCELLEME DIALOG
  void showEditDialog(KitapTur tur){

    adController.text = tur.ad;

    showDialog(

      context: context,

      builder: (context){

        return AlertDialog(

          title: const Text("Tür Güncelle"),

          content: TextField(
            controller: adController,
            decoration: const InputDecoration(
              labelText: "Tür Adı"
            ),
          ),

          actions: [

            TextButton(
              child: const Text("İptal"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),

            ElevatedButton(

              child: const Text("Güncelle"),

              onPressed: () async {

                tur.ad = adController.text;

                await KitapTurService().turGuncelle(tur.id, adController.text);

                Navigator.pop(context);

                refresh();

              },

            )

          ],

        );

      }

    );

  }

  /// SİLME
  void deleteTur(int id) async {

    await KitapTurService().turSil(id);

    refresh();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Kitap Türleri"),

        actions: [

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          )

        ],

      ),

      body: FutureBuilder<List<KitapTur>>(

        future: turler,

        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          if(!snapshot.hasData){
            return const Center(child: Text("Veri bulunamadı"));
          }

          if(snapshot.data!.isEmpty){
            return const Center(child: Text("Tür bulunamadı"));
          }

          return ListView.builder(

            padding: const EdgeInsets.all(10),

            itemCount: snapshot.data!.length,

            itemBuilder: (context,index){

              final tur = snapshot.data![index];

              return Card(

                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: ListTile(

                  leading: const Icon(
                    Icons.category,
                    size: 35,
                    color: Colors.blue,
                  ),

                  title: Text(
                    tur.ad,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  trailing: Row(

                    mainAxisSize: MainAxisSize.min,

                    children: [

                      IconButton(

                        icon: const Icon(
                          Icons.edit,
                          color: Colors.orange
                        ),

                        onPressed: (){
                          showEditDialog(tur);
                        },

                      ),

                      IconButton(

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red
                        ),

                        onPressed: (){
                          deleteTur(tur.id);
                        },

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