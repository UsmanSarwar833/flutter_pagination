

import 'package:flutter/cupertino.dart';
import 'package:pagination/model/post_model.dart';
import 'package:pagination/repository/post_repository.dart';

class PostProvider with ChangeNotifier{
  final _postRepo = PostRepository();

   List<PostModel> _post = [];
  List<PostModel> get post => _post;

   bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _page = 1;
  final int _limit = 7;

  Future<void> fetchPost()async{
    if(_isLoading || !hasMore) return;
    _isLoading = true;
    notifyListeners();
    try{
      List<PostModel> newPost = await _postRepo.fetchPost(page: _page, limit: _limit);
      if(newPost.length<8){

      }
      if(newPost.isEmpty){
          _hasMore = false;
      }else{
        _post.addAll(newPost);
        _page++;
      }

    }catch(e){
       print("Error fetching post $e");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}