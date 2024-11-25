import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../post_Repo/post_repo.dart';

// final getPostProviderController=FutureProvider((ref) {
//   final postRepo=ref.watch(postRepoProvider);
//   return postRepo.getPosts();
// });

// final userPostProviderController=FutureProvider((ref) {
//   final postRepo=ref.watch(postRepoProvider);
//   return postRepo.userPosts();
// });
final postControllerProvider=Provider((ref){
  final postRepo=ref.watch(postRepoProvider);
  return PostController(ref: ref, postRepo: postRepo);
});

class PostController{
  final Ref ref;
  final PostRepo postRepo;

  PostController({required this.ref, required this.postRepo});
Future<String>uploadPost(File file,String thought){
return postRepo.uploadPost(file: file,thought: thought, ref: ref);
}

  Future<String>uploadThought(String thought){
    return postRepo.uploadThought(thought: thought, ref: ref);
}

Stream<QuerySnapshot<Map<String, dynamic>>> getPosts(){
  return postRepo.getPosts();
}
Stream<QuerySnapshot<Map<String, dynamic>>> userPosts(String id,bool img){
  return postRepo.userPosts(id,img);
}
  Future<String> deletePost(String id,bool img)async{
    return postRepo.deletePost(id,img);
  }
  Future<String>updatePost(String des,String id){
  return postRepo.updatePost(des, id);
  }
  Future<void>likePost(String id,String postId,List likes,bool isImage)async{
    return await postRepo.likePost(id,postId, likes, isImage);
  }

}
