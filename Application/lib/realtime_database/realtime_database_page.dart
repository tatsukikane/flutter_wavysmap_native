import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//ユーザー位置情報
final latlonStateProvider = StateProvider<double>((ref) => 0.0);

class RealtimeDatabasePage extends ConsumerStatefulWidget {
  const RealtimeDatabasePage({Key? key}) : super(key: key);

  @override
  RealtimeDatabasePageState createState() => RealtimeDatabasePageState(); 
}

class RealtimeDatabasePageState extends ConsumerState<RealtimeDatabasePage>{
  @override
  void initState() {
    super.initState();

    RealtimeDatabaseService().read(ref);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RealtimeDatabase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '位置情報共有機能実装'
            ),
            Text(
              '${ref.watch(latlonStateProvider)}',
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          RealtimeDatabaseService().write(ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//Realtime Databaseのせってい
class RealtimeDatabaseService {
  //UserIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  //RealtimeDatabaseのデータベース定義(位置情報共有で使う)
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('users');

  //書き込み
  void write(WidgetRef ref) async {
    try{
      print("a");
      await dbRef.update({
        '$userID/latlon': ref.read(latlonStateProvider), 
      });
    } catch (e) {
      print('Error : $e');
    }
  }

  //読み込み
  void read(WidgetRef ref) async {
    try{
      dbRef.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        ref.watch(latlonStateProvider.state).state = data as double;
      });
    } catch (e) {
      print('Error : $e');
    }
  }

  //削除
  void remove() async {
    try {
      await dbRef.child(userID).remove();
    } catch(e){
      print('Error : $e');
    }
  }

}