import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_bottle/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => SettingState();
}

class SettingState extends State<SettingScreen> {
  bool isDarkMode = false;  // 여기에 다크모드 변수
  double _fontSize = 20.0;
  int selectedOption = 0; // 초기 선택된 옵션

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  late SharedPreferences _prefs;

  Future<void> _loadThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedThemeMode = _prefs.getString('themeMode');
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('themeMode', themeMode.toString());
  }

  _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 20.0;
    });
  }

  _saveFontSize(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }

  Future<bool> _getThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedThemeMode = _prefs.getString('themeMode');

    if(savedThemeMode == null) {
      // HomeScreen.themeNotifier.value = ThemeMode.light;
      return false;
    } else if(savedThemeMode == "ThemeMode.light") {
      // HomeScreen.themeNotifier.value = ThemeMode.light;
      return false;
    } else if(savedThemeMode == "ThemeMode.dark") {
      // HomeScreen.themeNotifier.value = ThemeMode.dark;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: FutureBuilder<bool> (
          future: _getThemeMode(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            // final bool isDarkMode = snapshot.data ?? false;  //final은 const같이 안변하는 상수인데 이래해놧엇네
            isDarkMode = snapshot.data ?? false;

            return Padding(
              padding: const EdgeInsets.all(20.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(fontSize: 20),
                      ),
                      CupertinoSwitch(
                        value: isDarkMode,
                        onChanged: (bool value) {
                          setState(() {
                            // isDarkMode = value ?? false; //null이면 false입력
                            isDarkMode = value;

                            if (isDarkMode == true) {
                              // HomeScreen.themeNotifier.value = ThemeMode.dark;
                              _saveThemeMode(ThemeMode.dark);
                            } else {
                              // HomeScreen.themeNotifier.value = ThemeMode.light;
                              _saveThemeMode(ThemeMode.light);
                            }

                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    ],
                  )
                ],
              ),
            );
          },
        )
    );
  }
}