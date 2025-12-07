import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main(){
  runApp(const RajaOngkirApp());
}
class RajaOngkirApp extends StatelessWidget{
  const RajaOngkirApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
title: 'RajaOngkir',
theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(),primarySwatch: Colors.blue, scaffoldBackgroundColor: const Color(0xFFF6F8FB),
),
home: const MainApp(),
debugShowCheckedModeBanner: false,
    );
  }
}
class MainApp extends StatefulWidget{
  const MainApp({super.key});
  @override
  State<MainApp> createState()=> _MainAppState();
}
class _MainAppState extends State<MainApp> {
  int _seletedIndex = 0;
  final pages = const [
    Domestic(),
    International(),
    Extra(),
  ];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: pages[_seletedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _seletedIndex,
      elevation: 8,
      selectedItemColor: Colors.grey,
      onTap: (i) => setState(() => _seletedIndex = i),
      items: const [
        BottomNavigationBarItem(icon:Icon(Icons.home), label:'Domestic'),
        BottomNavigationBarItem(icon:Icon(Icons.public), label:'International'),
        BottomNavigationBarItem(icon:Icon(Icons.info_outline), label:'About'),
      ],
    ),
   );
  }
}
