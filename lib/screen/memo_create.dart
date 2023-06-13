import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../riverpod/memo_provider.dart';
import 'defaul_layout.dart';

class MemoScreen extends StatefulWidget {
  final String? title;

  MemoScreen({Key? key, this.title}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  Category? _selectedCategory;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final memoProvider = Provider.of<MemoProvider>(context);
    final memolist = memoProvider.memoList;
    final categoryList_pr = memoProvider.categoryList;
    return DefaultLayout(
      title: "메모 작성",
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  onChanged: (value) {

                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  items: [
                    DropdownMenuItem<Category>(
                      value: Category(name: "카테고리 없음"),
                      child: Text("카테고리 없음"),
                    ),
                    ...categoryList_pr.map((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                  ],
                  // items: categoryList_pr.map((category) {
                  //   return DropdownMenuItem<Category>(
                  //     value: category,
                  //     child: Text(category.name),
                  //   );
                  // }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "카테고리",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "제목을 입력하세요.",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _contentController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "내용을 입력하세요.",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    memoProvider.addMemo(
                      Memo(
                        title: _titleController.text,
                        content: _contentController.text,
                        dateTime: DateTime.now(),
                        category_key: _selectedCategory!.name == "카테고리 없음" ? -1 : _selectedCategory!.key,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text("저장"),
                ),
              ],
            ),
          )
      ),
    );
  }
}
