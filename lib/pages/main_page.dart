import 'package:flutter/material.dart';
import '../models/kitap_tur_model.dart';
import '../services/kitap_tur_service.dart';
import 'kitap_tur_ekle_page.dart';
import 'kitap_tur_guncelle_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final service = KitapTurService();
  late Future<List<KitapTur>> turler;

  @override
  void initState() {
    super.initState();
    turler = service.getTurler();
  }

  void yenile(){
    setState(() {
      turler = service.getTurler();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitap Türleri"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KitapTurEklePage())
          );

          yenile();
        },
      ),

      body: FutureBuilder<List<KitapTur>>(
        future: turler,
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          final liste = snapshot.data!;

          return ListView.builder(
            itemCount: liste.length,
            itemBuilder: (context,index){

              final tur = liste[index];

              return ListTile(

                title: Text(tur.ad),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KitapTurGuncellePage(tur: tur),
                          )
                        );

                        yenile();
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {

                        await service.turSil(tur.id);

                        yenile();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}