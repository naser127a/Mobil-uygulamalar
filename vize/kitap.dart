import 'package:flutter/material.dart';
import 'package:vize/fireStore.dart';

class KitapEkle extends StatefulWidget {
  final String? docID;
  const KitapEkle({super.key, this.docID});
  @override
  State<KitapEkle> createState() => _KitapEkleState();
}

class _KitapEkleState extends State<KitapEkle> {
  late String? docID;
  @override
  void initState() {
    super.initState();
    docID = widget.docID;
  }

  final FireStoreServices firestoreService = FireStoreServices();
  TextEditingController kitapcontroller = TextEditingController();
  TextEditingController yayinevicontroller = TextEditingController();
  TextEditingController yazarlarcontroller = TextEditingController();
  TextEditingController sayfasayisicontroller = TextEditingController();
  TextEditingController basimyilicontroller = TextEditingController();
  bool checkbox = true;

  List<String> kategoriler = <String>[
    'Roman',
    'Tarih',
    'Edebiyat',
    'Şiir',
    'Ansiklopedi',
  ];
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          "Kitap Ekle",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              kayit(hinttext: "Kitap adi", controller: kitapcontroller),
              kayit(hinttext: "Yayın Evi", controller: yayinevicontroller),
              kayit(hinttext: "Yazarlar", controller: yazarlarcontroller),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DropdownMenu<String>(
                  label: const Text("kategori",
                      style:
                          TextStyle(color: Color.fromARGB(255, 217, 139, 230))),
                  initialSelection: kategoriler.first,
                  width: 400,
                  inputDecorationTheme: const InputDecorationTheme(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries: kategoriler
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              kayit(
                  hinttext: "Sayfa Sayısı", controller: sayfasayisicontroller),
              kayit(hinttext: "Basım Yılı", controller: basimyilicontroller),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Listede yayınlanacak mı?             ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Checkbox(
                      value: checkbox,
                      onChanged: (val) {
                        setState(() {
                          checkbox = !checkbox;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF7F2F9),
                    borderRadius: BorderRadius.circular(30)),
                child: MaterialButton(
                  onPressed: () {
                    // add a new book
                    if (docID == null) {
                      firestoreService.addBook(
                          kitapcontroller.text,
                          yayinevicontroller.text,
                          yazarlarcontroller.text,
                          sayfasayisicontroller.text,
                          basimyilicontroller.text,
                          dropdownValue,
                          checkbox);
                    }
                    // update the book
                    else {
                      firestoreService.updateBook(
                          docID,
                          kitapcontroller.text,
                          yayinevicontroller.text,
                          yazarlarcontroller.text,
                          sayfasayisicontroller.text,
                          basimyilicontroller.text,
                          dropdownValue,
                          checkbox);
                    }
                    //clear the text controller
                    kitapcontroller.clear();
                    yayinevicontroller.clear();
                    yazarlarcontroller.clear();
                    sayfasayisicontroller.clear();
                    basimyilicontroller.clear();
                    dropdownValue = "Roman";
                    checkbox = true;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Kaydet",
                    style: TextStyle(fontSize: 20, color: Color(0xFF715BAA)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget kayit(
      {required String hinttext, required TextEditingController controller}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(),
              focusColor: Colors.purple,
              hintText: hinttext,
              hintStyle: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
