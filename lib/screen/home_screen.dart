import 'package:flutter/material.dart';
import 'package:message_bottle/screen/msg_list_screen.dart';
import 'package:message_bottle/screen/setting_screen.dart';
import 'package:message_bottle/screen/send_msg_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:message_bottle/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    SendMsgScreen(),
    MsgListScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // final user = supabase.auth.currentUser;
    // print("user > " + user.toString());

    var uuid = Uuid();
    var randomUUID = uuid.v4();

    // if (user == null) {
    //   final response = await supabase.auth.signUp(
    //     email: randomUUID + '@gmail.com',//'email@example.com', // 사용자 이메일
    //     password: 'q1w2e3r4', // 사용자 비밀번호
    //     data: {'user_name': 'temp_user_name'},
    //   );
    //
    //   // if (response.error == null) {
    //   //   // 사용자 정보 저장 성공
    //   //   print('User signed up successfully');
    //   // } else {
    //   //   // 사용자 정보 저장 실패
    //   //   print('Error signing up: ${response.error!.message}');
    //   // }
    //
    // } else {
    //   // 이미 로그인한 사용자
    //   print('User already signed up');
    // }

  }



  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     // home: SendScreen(),
  //     home: MsgListScreen(),
  //   );
  // }

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
          home: Scaffold(
            body: _children[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.mark_chat_unread_outlined),
                  label: '랜덤쪽지보내기',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: '쪽지리스트',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '설정',
                ),
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
    // _saveThemeMode(HomeScreen.themeNotifier.value);
    super.dispose();
  }


}
