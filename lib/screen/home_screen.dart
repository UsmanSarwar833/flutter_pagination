import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pagination/controller/pagination_controller.dart';
import 'package:pagination/model/post_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostProvider postProvider = PostProvider();

  @override
  void initState() {
    super.initState();
    postProvider.fetchPost();
  }
  @override
  void dispose() {
    postProvider.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagination"),centerTitle: true,),
      body: ChangeNotifierProvider(
          create: (context) => postProvider..fetchPost(),
          child: Consumer<PostProvider>(builder: (context,provider,child){

            return NotificationListener(
              onNotification: (ScrollNotification scrollInfo){
                final nextPageTrigger = 0.8 * scrollInfo.metrics.maxScrollExtent;
                if(scrollInfo.metrics.pixels > nextPageTrigger && !postProvider.isLoading ){
                  postProvider.fetchPost();
                }
                return false;
              },
                child: ListView.builder(
                    itemCount: postProvider.post.length + (postProvider.hasMore ? 1: 0 ),
                    itemBuilder: (context,index){

                      if(index == postProvider.post.length){
                        return const Center(child: CircularProgressIndicator());
                      }
                      final post = postProvider.post[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.body),
                        ),
                      );

                    })
            );
          }),


      ) ,
    );
  }
}
