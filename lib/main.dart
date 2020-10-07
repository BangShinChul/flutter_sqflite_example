import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'model/dog.dart';
import 'dart:math';

List<Dog> dogs = [
  Dog(name: '푸들이'),
  Dog(name: '삽살이'),
  Dog(name: '말티말티'),
  Dog(name: '강돌이'),
  Dog(name: '진져'),
  Dog(name: '백구'),
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 이 위젯은 애플리케이션의 루트입니다.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // 이것이 애플리케이션의 테마입니다.
        //
        // "flutter run"으로 응용 프로그램을 실행 해보십시오. 응용 프로그램에 파란색 도구 모음이있는 것을 볼 수 있습니다.
        // 그런 다음 앱을 종료하지 않고 아래의 primarySwatch를 Colors.green으로 변경 한 다음 "hot reload"를 호출해보세요.
        // ("flutter run"을 실행 한 콘솔에서 "r"을 누르거나 Flutter IDE의 "hot reload"에 변경 사항을 저장하십시오.)
        // 카운터가 다시 0으로 재설정되지 않습니다. 또한 응용 프로그램이 다시 시작되지 않습니다.
        primarySwatch: Colors.blue,
        // 이렇게하면 시각적 밀도가 앱을 실행하는 플랫폼에 맞게 조정됩니다.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter SQLite Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // 이 위젯은 애플리케이션의 홈 페이지입니다. 이 위젯은 stateful 합니다. 즉, 모양에 영향을 주는 필드를 포함하는 State 개체(아래에 정의 됨)가 있습니다.

  // 이 클래스는 상태에 대한 구성입니다.
  // 부모(이 경우 앱 위젯)가 제공하고 State의 빌드 메서드에서 사용하는 값(이 경우 title)을 보유합니다. 위젯 하위 클래스의 필드는 항상 "final"으로 표시됩니다.
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _c;

  @override
  void initState() {
    // TODO: implement initState
    _c = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: DBHelper().getAllDogs(),
            builder: (BuildContext context, AsyncSnapshot<List<Dog>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Dog item = snapshot.data[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // 양 옆으로 슬라이드 동작이 감지되면 트리거되는 함수
                        DBHelper().deleteDog(item.id);
                        setState(() {});
                      },
                      child: Center(child: Text(item.name)),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                //모두 삭제 버튼
                DBHelper().deleteAllDogs();
                setState(() {});
              },
            ),
            SizedBox(height: 8.0),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                //추가 버튼
                Dog dog = dogs[Random().nextInt(dogs.length)];
                DBHelper().createData(dog);
                setState(() {});
              },
            ),
            SizedBox(height: 8.0),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                //추가 버튼(popup)

                showDialog(
                    context: context,
                    builder: (_) => Dialog(
                          child: new Column(
                            children: <Widget>[
                              new TextField(
                                decoration: new InputDecoration(
                                    hintText: "insert dog name"),
                                controller: _c,
                              ),
                              new FlatButton(
                                  onPressed: () {
                                    DBHelper().createDataByName(_c.text);
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: new Text("Save"))
                            ],
                          ),
                        ));
              },
            ),
          ],
        ));
  }
}
