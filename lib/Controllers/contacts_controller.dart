import 'dart:convert';
import 'dart:math';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/user.dart';

final contactsProvider =
StateNotifierProvider<Contacts>((ref) => Contacts());

class Contacts extends StateNotifier<List<User>> {
  Contacts([List<User> users]) : super(users ?? []);

  Future<void> initialSetup() async {
    state = await getSavedContacts();
  }

  Future<List<User>> getContactsOnFlipp() async {
    if (state.isNotEmpty) return Future.value(state);
    state = await processContactsOnDevice();
    saveContactsState();
    return state ?? [];
  }


  Future<List<User>> processContactsOnDevice() async {
    if (await askContactPermission() != PermissionStatus.granted) return [];
    Iterable<Contact> contacts = await ContactsService.getContacts(
        withThumbnails: false).catchError((e) => print(e.toString()));
    List<User> dummyUsers = [];
    List<String> numbers = [];

    contacts.forEach((element1) {
      element1.phones.forEach((element2) {

        String number = element2.value.replaceAll(' ', '');
        if(!numbers.contains(number)) numbers.add(number);

      });
    });

    List<User> result  = await UserController().getUsers();
    result.retainWhere((element) => numbers.contains(element.phone));


    return result ?? state ;

  }



  Future<void> saveContactsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('contacts', state.map((e) => jsonEncode(e)).toList());
  }

  Future<List<User>> getSavedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contacts = prefs.getStringList('contacts') ?? [];
    return contacts.map((e) => User.fromMap(jsonDecode(e))).toList();
  }


  Future<PermissionStatus> askContactPermission() async {
    if (!(await Permission.contacts.isGranted) &&
        !(await Permission.contacts.isRestricted)) {
      Map<Permission, PermissionStatus> status = await [
        Permission.contacts,
      ].request();
      return status[Permission.contacts];
    }
    return (await Permission.contacts.status);
  }

}
