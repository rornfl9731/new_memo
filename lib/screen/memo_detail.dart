import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../riverpod/memo_provider.dart';
import 'defaul_layout.dart';

class MemoDetail extends StatefulWidget {
  final int idx;
  final String? title;

  MemoDetail({Key? key, this.title, required this.idx}) : super(key: key);

  @override
  State<MemoDetail> createState() => _MemoDetailState();
}

class _MemoDetailState extends State<MemoDetail> {
  List<Category> _categoryList = [];
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
    super.initState();}


  @override
  Widget build(BuildContext context) {

    final memoProvider = Provider.of<MemoProvider>(context);
    final memolist = memoProvider.memoList;
    final categoryList_pr = memoProvider.categoryList;
    final beforeCategoryKey = memolist[widget.idx].category_key;
    _titleController.text = memolist[widget.idx].title;
    _contentController.text = memolist[widget.idx].content;
    // if(beforeCategoryKey != -1){
    //   _selectedCategory = _categoryList.firstWhere((e) => e.key == beforeCategoryKey);
    // }else{
    //   _selectedCategory = null;
    // }
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
                  items: categoryList_pr.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
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
                    if(_selectedCategory != null){
                      if(_selectedCategory!.key != beforeCategoryKey){
                        if(beforeCategoryKey != -1){
                          memoProvider.updateMemo(widget.idx,beforeCategoryKey,Memo(
                            title: _titleController.text,
                            content: _contentController.text,
                            dateTime: DateTime.now(),
                            category_key: _selectedCategory!.key,));


                        }
                        memoProvider.updateMemo(widget.idx,_selectedCategory!.key,Memo(
                          title: _titleController.text,
                          content: _contentController.text,
                          dateTime: DateTime.now(),
                          category_key: _selectedCategory!.key,));
                      }else{
                        memoProvider.updateMemo(widget.idx,beforeCategoryKey,Memo(
                          title: _titleController.text,
                          content: _contentController.text,
                          dateTime: DateTime.now(),
                          category_key: _selectedCategory!.key,));
                      }

                    if(Navigator.canPop(context)){
                      Navigator.of(context).pop();
                    }else{
                      SystemNavigator.pop();
                    }
                    }
                    else{
                      memoProvider.updateMemo(widget.idx,beforeCategoryKey,Memo(
                        title: _titleController.text,
                        content: _contentController.text,
                        dateTime: DateTime.now(),
                        category_key: -1,));
                    }
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




