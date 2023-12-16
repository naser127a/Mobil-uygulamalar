// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vize/kitap.dart';
import 'package:vize/fireStore.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  FireStoreServices firestoreService = FireStoreServices();
  int numberOfBooks = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "kitaplar"),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: "Satın al"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 138, 195, 241),
        foregroundColor: const Color.fromARGB(255, 9, 1, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const KitapEkle()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: const Text("NASIR AKRAA"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.menu),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getBooksStream(),
        builder: (context, snapshot) {
          //if we have data get all the docs
          if (snapshot.hasData) {
            numberOfBooks = -1;
            List booksList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: booksList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = booksList[index];
                String docId = document.id;
                // her eklediğimiz kitabın tüm bilgileri listele
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String kitabAdi = data["Kitab adi"];
                String yayinEvi = data["Yayin Evi"];
                String yazar = data["Yazarlar"];
                String sayfaSayisi = data["Sayfa sayisi"];
                if (data["Kategori"] is String) {
                  String kategori = data["Kategori"];
                } else {}
                String basimYili = data["Basim yili"];
                numberOfBooks += 1;
                bool checkbox = data["checkbox"];
                // verileri liste olarak göster
                return checkbox
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: const Color(0xFFF7F2F9),
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: ListTile(
                          title: Text(
                            "Kitap Adı $numberOfBooks",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Yazar: $yazar,Sayfa Sayısı:$sayfaSayisi",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // this icon for update
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: ((context) => KitapEkle(
                                                  docID: docId,
                                                ))));
                                  },
                                  icon: const Icon(Icons.edit)),

                              // this icon for delete
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            title: const Text("Dikkat !"),
                                            content: const Text(
                                                "Bu kitap silmek istiyor musunuz?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    firestoreService
                                                        .deleteBook(docId);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Evet")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Hayır"))
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      );
              },
            );
          } else {
            return const Text("there is nothing in the collection");
          }
        },
      ),
    );
  }
}
