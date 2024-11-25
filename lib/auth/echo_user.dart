class EchoUser {
  final String name;
  final String uid;
  final String phone;
  final String bio;
  final String profilePic;
  final String email;
  final bool isOnline;


  EchoUser(
      {required this.name,
      required this.uid,
      required this.phone,
      required this.bio,
      required this.profilePic,
      required this.email,
      required this.isOnline,
      });

  Map<String, dynamic> toMap() => {
        'Username': name,
        'Bio': bio,
        'PhoneNumber': phone,
        'Email': email,
        'Uid': uid,
        'ProfilePic': profilePic,
        'isOnline': isOnline,

      };

  factory EchoUser.fromMap(Map<String, dynamic> map) {
    return EchoUser(
        name: map['Username'],
        uid: map['Uid'],
        phone: map['PhoneNumber'],
        bio: map['Bio'],
        profilePic: map['ProfilePic'],
        email: map['Email'],
        isOnline: map['isOnline'],

    );
  }
}
