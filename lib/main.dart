import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行動学習帳'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('行動忘れ'),
            onTap: () {
              //setState(() => {});
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WordList("keigo");
              }));
            },
          ),
          ListTile(
            title: Text('配慮不足'),
            onTap: () {
              //setState(() => {});
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WordList("taiwa");
              }));
            },
          ),
          ListTile(
            title: Text('コミュニケーション'),
            onTap: () {
              //setState(() => {});
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WordList("unique");
              }));
            },
          ),
        ],
      ),
    );
  }
}

class WordInfo {
  int id;
  String before_word;
  String after_word;
  String deteail;

  List<void Function(WordInfo)> _regist_event;

  WordInfo(this.id, this.before_word, this.after_word, this.deteail,
      this._regist_event);

  void addEvent(void Function(WordInfo) f) {
    this._regist_event.add(f);
  }

  void emit() {
    for (var f in this._regist_event) {
      f(this);
    }
  }
}

class WordList extends StatefulWidget {
  final String _wordListKey;
  WordList(this._wordListKey);

  @override
  State<StatefulWidget> createState() {
    return WordListState(this._wordListKey);
  }
}

class WordListState extends State<WordList> {
  final Map<String, List<WordInfo>> wordlist = {
    "keigo": [
      WordInfo(0, "〇〇とは何ですか？", "〇〇について具体的にお伺いしてもよろしいでしょうか。", "", []),
      WordInfo(1, "〇〇について教えてください", "〇〇についてご教授お願いしてもよろしいでしょうか。", "", [])
    ],
    "taiwa": [WordInfo(2, "〇〇やって。", "〇〇お願いしても良いでしょうか？/大丈夫でしょうか？", "", [])]
  };

  final String wordListKey;
  WordListState(this.wordListKey);

  @override
  Widget build(BuildContext context) {
    //todo: this is high cost ,it will be initialized every time. at build call
    var child = <Widget>[];
    var list = this.wordlist[this.wordListKey];
    if (list != null) {
      for (var i in list) {
        print(identityHashCode(i));
        child.add(Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black38),
              ),
            ),
            child: ListTile(
                title: Text(i.before_word + "\n→" + i.after_word),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return WordDetail(i);
                  })).then((_) => setState(() {}));
                })));
      }
    }
    child.add(ElevatedButton(
      child: const Text('+'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.lightBlue,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WordDetail(WordInfo(-1, "", "", "", []));
        })).then((value) => print(value));
      },
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('単語リスト'),
      ),
      body: ListView(padding: EdgeInsets.only(bottom: 10), children: child),
    );
  }
}

class WordDetail extends StatefulWidget {
  final WordInfo info;
  WordDetail(this.info);

  @override
  State<StatefulWidget> createState() {
    return WordDetailState(this.info);
  }
}

class WordDetailState extends State<WordDetail> {
  WordInfo state;
  final _beforeWordController = TextEditingController();
  final _afterWordController = TextEditingController();
  final _deteailWordController = TextEditingController();

  WordDetailState(this.state) {
    _beforeWordController.text = state.before_word;
    _afterWordController.text = state.after_word;

    _beforeWordController.addListener(() {
      this.state.before_word = this._beforeWordController.text;
    });

    _afterWordController.addListener(() {
      this.state.after_word = this._afterWordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textFieldDeco = InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
        ),
      ),
    );
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(title: Text("単語詳細")),
            body: ListView(children: [
              Text("before"),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                controller: this._beforeWordController,
                decoration: textFieldDeco,
              ),
              Text("after"),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                controller: this._afterWordController,
                decoration: textFieldDeco,
              ),
              Text("詳細"),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                obscureText: false,
                controller: this._deteailWordController,
                decoration: textFieldDeco,
              ),
              ElevatedButton(
                child: const Text('ADD'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(
                      color: Colors.lightBlue,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop("test");
                },
              )
            ])));
  }
}
