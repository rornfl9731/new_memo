import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memo/screen/defaul_layout.dart';
import 'package:memo/screen/memo_detail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../model/model.dart';
import '../riverpod/memo_provider.dart';
import 'memo_create.dart';

class MemoList extends StatefulWidget {
  const MemoList({Key? key}) : super(key: key);

  @override
  State<MemoList> createState() => _MemoListState();


}

class _MemoListState extends State<MemoList> {
  List<Memo> _filteredMemoList = [];
  Category? _selectedCategory;
  bool _isSearching = false;
  var _c;
  TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    print('build');
    final memoProvider = Provider.of<MemoProvider>(context);
    final memolist = memoProvider.memoList;
    final categoryList_pr = memoProvider.categoryList;

    // for(int i = 0; i < memolist.length; i++) {
    //   print(memolist[i].title);
    // }
    // print('------------------');
    // for(int i = 0; i < categoryList_pr.length; i++) {
    //   print(categoryList_pr[i].name);
    // }

    return Consumer<MemoProvider>(
      builder: (context,memoProvider,_)
    {
      return DefaultLayout(
          icons: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          child: Container(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "검색어를 입력하세요",
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  _filteredMemoList =
                                      memoProvider.searchMemo(value);
                                });
                              },
                            ),
                          )
                      );
                    }
                );

                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Box<Memo> memo = Hive.box('memo');
                Box<Category> category = Hive.box('category');
                category.deleteAt(3);
              },
              icon: Icon(Icons.search),
            ),
          ],
          title: "메모 리스트",
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoScreen(),
                  )).then((res) => refreshPage());
            },
            child: Icon(Icons.add),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () {
                      Box<Category> category = Hive.box('category');
                      // category.clear();
                      // _categoryList.clear();
                      Box<Memo> memo = Hive.box('memo');
                    }, child: Text("m")),
                    ElevatedButton(onPressed: () {
                      Box<Category> category = Hive.box('category');
                      // category.clear();
                      // _categoryList.clear();
                      Box<Memo> memo = Hive.box('memo');
                      memo.clear();
                    }, child: Text("n")),
                    GestureDetector(
                      onTap: () {
                        // print(_categoryList[0].name);
                        // print(_categoryList[0].key);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("카테고리 관리"),
                              content: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.8,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.5,
                                child: ListView.builder(
                                    itemCount: Provider.of<MemoProvider>(context).categoryList.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Consumer<MemoProvider>(
                                        builder: (context,memoProvider,_){
                                          return ListTile(
                                              title: Row(
                                                children: [
                                                  Text(Provider.of<MemoProvider>(context).categoryList[index].name),
                                                  Text("(${Provider.of<MemoProvider>(context).categoryList[index]
                                                      .memo_count})"),

                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  showDialog(context: context,
                                                      builder: (
                                                          BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("카테고리 삭제"),
                                                          content: Text(
                                                              "정말로 삭제하시겠습니까?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("취소"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                memoProvider
                                                                    .deleteCategory(
                                                                    index);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("삭제"),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                              onTap: () {
                                                showDialog(context: context,
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("카테고리 수정"),
                                                        content: TextField(
                                                          controller: TextEditingController(
                                                              text: categoryList_pr[index]
                                                                  .name),
                                                          decoration: InputDecoration(
                                                            hintText: "카테고리 이름을 입력하세요",
                                                          ),
                                                          onChanged: (value) {
                                                            _c = value;
                                                          },
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("취소"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Category updatedCategory = Category(
                                                                  name: _c,
                                                                  memo_count: Provider.of<MemoProvider>(context).categoryList[index]
                                                                      .memo_count);
                                                              //print(_categoryList[index].key);
                                                              //var key = _categoryList[index].key;
                                                              memoProvider
                                                                  .updateCategory(
                                                                  index,
                                                                  updatedCategory);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("수정"),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
                                          );
                                        }
                                      );
                                    }
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("닫기"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("카테고리 추가"),
                                            content: TextField(
                                              decoration: InputDecoration(
                                                hintText: "카테고리 이름을 입력하세요",
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _c = value;
                                                });
                                              },

                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("취소"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Category category = Category(
                                                      name: _c, memo_count: 0);
                                                  memoProvider.addCategory(
                                                      category);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("추가"),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text("추가"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text("카테고리 관리"),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    DropdownButton<Category>(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 0,
                      hint: Text("카테고리 선택"),
                      value: _selectedCategory,
                      onChanged: (Category? _category) {
                        if (_category == null) {
                          setState(() {
                            Box<Memo> memo = Hive.box('memo');
                            _selectedCategory = null;
                          });
                        } else {
                          _filteredMemoList =
                              memoProvider.filterMemo(_category!.key);
                          setState(() {
                            _selectedCategory = _category;
                          });
                        }
                      },

                      items: [
                        DropdownMenuItem<Category>(
                          value: null,
                          child: Text("전체"),
                        ),
                        ...categoryList_pr.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ],

                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Expanded(
                    child: ReorderableListView(
                      children: [
                        for(final memo in _selectedCategory == null
                            ? Provider.of<MemoProvider>(context).memoList
                            : _filteredMemoList)
                          GestureDetector(
                            key: ValueKey(memo.key),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MemoDetail(
                                          idx: memo.key,
                                        ),
                                  )).then((res) => refreshPage());
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    memo.title,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                    memo.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      // Text(
                                      //   memo.category,
                                      //   style: TextStyle(
                                      //     color: Colors.grey,
                                      //   ),
                                      // ),
                                      Text(
                                        memo.dateTime.toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                      onReorder: (oldIndex, newIndex) {
                        memoProvider.reorderMemo(oldIndex, newIndex);
                      },
                    )
                ),


              ],
            ),
          )
      );
    }
    );
  }

  refreshPage() {
    // setState(() {
    //   Box<Memo> memo = Hive.box('memo');
    //   _filteredMemoList = memo.values.toList();
    //   _memoList = memo.values.toList();
    // });
  }

}

