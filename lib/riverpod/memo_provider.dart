import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:memo/model/model.dart';
import 'package:memo/screen/defaul_layout.dart';

class MemoProvider extends ChangeNotifier{
  Box<Memo> _memoBox = Hive.box('memo');
  Box<Category> _categoryBox = Hive.box('category');
  List<Memo> get memoList => _memoBox.values.toList();
  List<Category> get categoryList => _categoryBox.values.toList();



  Future<void> initialize() async{
    _memoBox = await Hive.openBox<Memo>('memo');
    _categoryBox = await Hive.openBox<Category>('category');
    notifyListeners();
  }

  String getMemoCategoryName(int idx){
    if(idx == -1){
      return '미분류';
    }
    return _categoryBox.get(_memoBox.getAt(idx)!.category_key!)!.name;
  }

  List<Memo> searchMemo(String keyword){
    return _memoBox.values.where((element) => element.title.contains(keyword) || element.content.contains(keyword)).toList();
  }

  List<Memo> filterMemo(int category_key){
    return _memoBox.values.where((element) => element.category_key == category_key).toList();
  }

  void addMemo(Memo memo){
    _memoBox.add(memo);
    if(memo.category_key != null){
      _categoryBox.put(
        memo.category_key!,
        Category(
          name: _categoryBox.get(memo.category_key!)!.name,
          memo_count: _categoryBox.get(memo.category_key!)!.memo_count + 1,
        ),
      );
    }
    notifyListeners();
  }

  void updateMemo(int idx,int before, Memo memo){
    _memoBox.putAt(idx, memo);
    if(memo.category_key != null){
      _categoryBox.put(
        memo.category_key!,
        Category(
          name: _categoryBox.get(memo.category_key!)!.name,
          memo_count: _categoryBox.get(memo.category_key!)!.memo_count + 1,
        ),
      );
      _categoryBox.put(before,
        Category(
          name: _categoryBox.get(before)!.name,
          memo_count: _categoryBox.get(before)!.memo_count - 1,
        ),
      );

    }
    notifyListeners();
  }

  void reorderMemo(int oldIndex, int newIndex){
    if(oldIndex < newIndex){
      newIndex -= 1;
    }
    final memo = _memoBox.getAt(oldIndex);
    var memolist = _memoBox.values.toList();
    memolist.removeAt(oldIndex);
    memolist.insert(newIndex, memo!);
    _memoBox.deleteAll(_memoBox.keys);
    print(_memoBox.values.toList().length.toString() + '개');
    for (final memo in memolist) {
      _memoBox.add(memo);
    }


    notifyListeners();
  }

  void deleteMemo(int idx){
    _memoBox.deleteAt(idx);
    notifyListeners();
  }

  void addCategory(Category category){
    _categoryBox.add(category);
    notifyListeners();
  }

  void updateCategory(int idx, Category category){
    _categoryBox.putAt(idx, category);
    notifyListeners();
  }

  void deleteCategory(int idx){
    _categoryBox.deleteAt(idx);
    notifyListeners();
  }

}