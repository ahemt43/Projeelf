import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(AhmetRezistivite3D());

class AhmetRezistivite3D extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0A0E21)),
      home: UcBoyutluPanel(),
    );
  }
}

class UcBoyutluPanel extends StatefulWidget {
  @override
  _UcBoyutluPanelState createState() => _UcBoyutluPanelState();
}

class _UcBoyutluPanelState extends State<UcBoyutluPanel> {
  // 3 Katmanlı Matris: [Derinlik][Satır][Sütun]
  List<List<List<double>>> veriKupu = List.generate(3, (k) => List.generate(6, (s) => List.generate(6, (st) => 0.0)));
  int aktifKatman = 0; // 0:Yüzey, 1:3 Metre, 2:6 Metre
  bool taramaVar = false;

  void derinlikTaramasi() {
    setState(() => taramaVar = true);
    int k = 0;
    Timer.periodic(Duration(milliseconds: 700), (t) {
      if (k < 3) {
        setState(() {
          veriKupu[k] = List.generate(6, (s) => List.generate(6, (st) => Random().nextDouble() * 255));
          k++;
        });
      } else {
        t.cancel();
        setState(() => taramaVar = false);
      }
    });
  }

  Color renkHesapla(double d) {
    if (d == 0) return Colors.blueGrey[900]!;
    if (d < 60) return Colors.blue[800]!; // Islak/Su
    if (d < 120) return Colors.green[800]!; // Toprak
    if (d < 180) return Colors.orange[900]!; // Kaya
    return Colors.red[900]!; // Metal/Boşluk
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AHMET 3D SCANNER PRO"), centerTitle: true),
      body: Column(
        children: [
          // Katman Seçici (3D Geçişleri)
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _katmanButon(0, "YÜZEY"),
                _katmanButon(1, "3 METRE"),
                _katmanButon(2, "6 METRE"),
              ],
            ),
          ),
          // 3D Grid Görünümü
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemCount: 36,
              itemBuilder: (c, i) {
                double val = veriKupu[aktifKatman][i ~/ 6][i % 6];
                return Container(
                  decoration: BoxDecoration(color: renkHesapla(val), borderRadius: BorderRadius.circular(4)),
                  child: Center(child: Text(val > 0 ? val.toInt().toString() : "", style: TextStyle(fontSize: 8))),
                );
              },
            ),
          ),
          // Alt Kontrol Paneli
          _altPanel(),
        ],
      ),
    );
  }

  Widget _katmanButon(int i, String t) => ElevatedButton(
    onPressed: () => setState(() => aktifKatman = i),
    style: ElevatedButton.styleFrom(backgroundColor: aktifKatman == i ? Colors.blue : Colors.grey[800]),
    child: Text(t, style: TextStyle(fontSize: 10)),
  );

  Widget _altPanel() => Container(
    padding: EdgeInsets.all(25),
    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    child: ElevatedButton(
      onPressed: taramaVar ? null : derinlikTaramasi,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(double.infinity, 55)),
      child: Text(taramaVar ? "3D VERİLER İŞLENİYOR..." : "3D TAM TARAMAYI BAŞLAT"),
    ),
  );
}

