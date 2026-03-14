import 'package:flutter/material.dart';

import 'kitap_page.dart';
import 'uye_page.dart';
import 'yazar_page.dart';
import 'yayin_evi_page.dart';
import 'kitap_tur_page.dart';
import 'odunc_page.dart';
import 'ceza_page.dart';

class HomePage extends StatelessWidget {

  Widget menuCard(
      BuildContext context,
      String text,
      IconData icon,
      Widget page
      ){

    return GestureDetector(

      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page)
        );
      },

      child: Card(

        elevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        child: Container(

          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                size: 45,
                color: Colors.blue,
              ),

              const SizedBox(height: 15),

              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Kütüphane Yönetimi"),
        centerTitle: true,
      ),

      body: Padding(

        padding: const EdgeInsets.all(10),

        child: GridView.count(

          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,

          children: [

            menuCard(context,"Kitaplar",Icons.menu_book, KitapPage()),
            menuCard(context,"Üyeler",Icons.people, UyePage()),
            menuCard(context,"Yazarlar",Icons.edit, YazarPage()),
            menuCard(context,"Yayın Evleri",Icons.business, YayinEviPage()),
            menuCard(context,"Kitap Türleri",Icons.category, KitapTurPage()),
            menuCard(context,"Ödünçler",Icons.swap_horiz, OduncPage()),
            menuCard(context,"Cezalar",Icons.warning, CezaPage()),

          ],

        ),

      ),

    );

  }

}