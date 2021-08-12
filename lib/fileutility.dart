library fileutility;

import 'dart:io';

class FileHandler {
  String _filepath;
  String? _content = null;

  String? get content {
    var ret = this._content;
    this._content = null;
    return ret;
  }

  FileHandler(this._filepath) {}

  void writeSync(String data) {
    this._openfile().writeAsStringSync(data);
  }

  Future<void> write(String data) async {
    await this._openfile().writeAsString(data);
  }

  String readSync() {
    return this._openfile().readAsStringSync();
  }

  Future<void> read() async {
    this._content = await this._openfile().readAsString();
  }

  File _openfile() {
    return File(this._filepath);
  }
}

FileHandler open(String filepath) {
  return FileHandler(filepath);
}
