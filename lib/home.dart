import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/multiplayer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Tic-Tac-Toe",
                      style: GoogleFonts.pressStart2p(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 28))),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text("FII 2022 edition",
                        style: GoogleFonts.pressStart2p(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 16))),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: AvatarGlow(
                  endRadius: 140,
                  duration: const Duration(seconds: 2),
                  glowColor: Colors.green[300] ?? Colors.black,
                  repeat: true,
                  repeatPauseDuration: const Duration(seconds: 1),
                  startDelay: const Duration(seconds: 1),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.none),
                          shape: BoxShape.circle),
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple[300],
                        radius: 62.5,
                        child: Image.asset(
                          'lib/images/logo.png',
                          color: Colors.black,
                          fit: BoxFit.scaleDown,
                        ),
                      )),
                )),
            Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MultiplayerPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0.0, 48.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                  color: Colors.green[400] ?? Colors.black)),
                          primary: Colors.black,
                          textStyle: GoogleFonts.novaSlim(
                              textStyle: const TextStyle(
                                  color: Colors.black, fontSize: 30))),
                      child: const Text('Multiplayer Mode'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0.0, 48.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                  color: Colors.green[400] ?? Colors.black)),
                          primary: Colors.black,
                          textStyle: GoogleFonts.novaSlim(
                              textStyle: const TextStyle(
                                  color: Colors.black, fontSize: 30))),
                      child: const Text('AI difficulty mode'),
                    )
                  ],
                )),
            Expanded(
              flex: 1,
              child: Center(
                child: Text("made by Smau Adrian-Constantin, group 3B5",
                    style: GoogleFonts.pressStart2p(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 8))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
