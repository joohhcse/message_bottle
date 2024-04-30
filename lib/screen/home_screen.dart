import 'dart:math';

import 'package:flutter/material.dart';
import 'package:message_bottle/screen/msg_list_screen.dart';
import 'package:message_bottle/screen/setting_screen.dart';
import 'package:message_bottle/screen/send_msg_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isLoading = false; //not used

  late SharedPreferences _prefs;

  String generateRandomString(int length) {
    var random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  final List<Widget> _children = [
    SendMsgScreen(),
    MsgListScreen(),
    // SettingScreen(),
  ];

  Future<void> _loadThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedThemeMode = _prefs.getString('themeMode');

    if(savedThemeMode == null) {
      HomeScreen.themeNotifier.value = ThemeMode.light;
    } else if(savedThemeMode == "ThemeMode.light") {
      HomeScreen.themeNotifier.value = ThemeMode.light;
    } else if(savedThemeMode == "ThemeMode.dark") {
      HomeScreen.themeNotifier.value = ThemeMode.dark;
    }
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('themeMode', themeMode.toString());
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();  //userId Initialize
    _loadThemeMode(); //dark mode
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      // ValueListenableBuilder를 사용하여 themeNotifier의 변경을 감지하고 화면을 다시 그립니다.
      valueListenable: HomeScreen.themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          themeMode: themeMode, // MaterialApp의 테마 모드를 themeNotifier의 값으로 설정합니다.
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', ''),
            Locale('en', ''),
            Locale('ja', ''),
          ],
          home: Scaffold(
            body: _children[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.mark_chat_unread_outlined),
                  label: AppLocalizations.of(context)!.send_random_msg,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: AppLocalizations.of(context)!.msg_list, //'받은쪽지리스트',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.settings),
                //   label: '설정',
                // ),
              ],
            ),

          ),
        );
      },
    );
  }



  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 앱이 종료될 때 SharedPreferences에 테마 모드를 저장
  @override
  void dispose() {
    _saveThemeMode(HomeScreen.themeNotifier.value);
    super.dispose();
  }

  Future<void> _loadUserId() async {
    _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs.getString('userId');

    if(userId == null) {
      userId = generateRandomString(10);
      _prefs.setString('userId', userId);
      insertUser(userId);
    }
    else {
      print('_loadUserId : useId >>>' + userId);
    }
  }

  Future<String?> selectUser(String userId) async {
    try{
      var response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('username', userId);

      return response.toString();

    } on AuthException catch (error) {
      print(' selectUser1 => ' + error.message);
    } on Exception catch (error) {
      print(' selectUser2 => ' + error.toString());
    } finally {
      setState(() {

      });
    }
  }

  Future<void> insertUser(String userId) async {
    try{
      final response = await Supabase.instance.client
          .from('users')
          .insert({'username': userId});
    } on AuthException catch (error) {
      print(' insertUser1 => ' + error.message);
    } on Exception catch (error) {
      print(' insertUser2 => ' + error.toString());
    } finally {
      setState(() {

      });
    }
  }

  //not used
  Future<void> _signUp({
    required String email,
    required String userName,
    required String password,
  }) async {
    // Set loading state to true
    setState(() {
      isLoading = true;
      print('_signUp : isLoading is TRUE');
    });

    // Try to sign up with Supabase
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'username': userName},
      );
    } on AuthException catch (error) {
      // Catch any errors with signing up
      // showErrorSnackBar(context, message: error.message);
      print(error.message);
    } on Exception catch (error) {
      // Catch any other errors
      // showErrorSnackBar(context, message: error.toString());
      print(error.toString());
    } finally {
      // Set loading state to false
      setState(() {
        isLoading = false;
      });
    }
  }

}
