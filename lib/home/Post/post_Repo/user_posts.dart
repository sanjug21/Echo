


// ignore_for_file: prefer_typing_uninitialized_variables

class Post{
  final String description;
  final String phone;
  final String uid;
  final String username;
  final String postId;
  final  datePublished;
  final String profImage;
  final String postUrl;
  final List likes;
  final bool isImage;
  const Post({
    required this.description,
    required this.phone,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.postId,
    required this.profImage,
    required this.likes,
    required this.isImage
  });
  Map<String,dynamic> toPost()=>{
    'phone':phone,
    "uid":uid,
    "username":username,
    "postId":postId,
    "datePublished":datePublished,
    "description":description,
    "profImage":profImage,
    "postUrl":postUrl,
    "likes":likes,
    "isImage":isImage
  };

  static Post fromPost(Map<String, dynamic> snapshot){

    return Post(
        phone: snapshot['phone'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        description: snapshot['description'],
        datePublished:snapshot['datePublished'] ,
        profImage: snapshot['profImage'],
        postUrl: snapshot['postUrl'],
        likes: snapshot['likes'],
      isImage: snapshot['isImage']
    );
  }

}