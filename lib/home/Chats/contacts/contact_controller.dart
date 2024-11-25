
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_repo.dart';

final getContactProvider=FutureProvider((ref) {

  final contactController=ref.watch(contactControllerProvider);

  return contactController.getContacts();
});

final  contactControllerProvider=Provider((ref) {
final contactRepo=ref.watch(contactRepoProvider);
return ContactController(ref: ref, contactRepo: contactRepo);
});


class ContactController{
  final Ref ref;
  final ContactRepo contactRepo;

  ContactController({required this.ref, required this.contactRepo});
  Future<List<dynamic>> getContacts()async{
    return await contactRepo.getContacts();
  }
  Future<List<String>>allContacts(){
    return contactRepo.allContacts();
  }

}
