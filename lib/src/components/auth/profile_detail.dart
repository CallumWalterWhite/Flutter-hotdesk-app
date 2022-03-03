import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

import '../../constants/department_codes.dart';
import '../../entities/profile.dart';
import '../../services/profile_service.dart';
import '../../util/colour_palette.dart';
import '../../widgets/widget.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);


  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  bool profileLoaded = false;
  final ProfileService _profileService = Ioc().use('profileService');
  late Profile profile;
  late String dropdownValue;
  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();

  _ProfileDetailState(){
    dropdownValue = DepartmentCodes.ALL;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future <void> init() async {
    await loadProfile();
  }

  Future<void> loadProfile() async {
    profile = await _profileService.get();
    setState(() {
      _firstNameController.text = profile.firstName;
      _surnameController.text = profile.surname;
      profileLoaded = true;
      dropdownValue = profile.department;
    });
  }

  Future<void> updateProfile() async {
    Profile uProfile = Profile(profile.userId, _firstNameController.text, _surnameController.text, dropdownValue);
    await _profileService.update(uProfile);
    setState(() {
      profileLoaded = true;
    });
    await ShowDialog(context, "Updated", "Your profile has been updated.", null);
  }

  Widget buildWidget(){
    if (profileLoaded){
      return Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Display name'),
            subtitle: Text(FirebaseAuth.instance.currentUser?.displayName as String),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(FirebaseAuth.instance.currentUser?.email as String),
          ),
          const Divider(
            height: 1.0,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("First name"),
            subtitle: TextFormField(
              controller: _firstNameController,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Surname"),
            subtitle: TextFormField(
              controller: _surnameController,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.house_sharp),
            title: DropdownButtonFormField<String>(
              value: dropdownValue,
              items: [DepartmentCodes.ALL, DepartmentCodes.SOFTWARE, DepartmentCodes.MARKETING]
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              )).toList(),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              validator: (value) {
                if (value == "Select Value") {
                  return 'Please select a value from the list';
                }
                return null;
              },
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),
          ),
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await updateProfile();
                  },
                  child: const Text('Update'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {Navigator.pop(context, null);
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          )
        ]
      );
    }
    else{
      return const Center(child: Text('loading...'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: mainColour),
        title: const Text("Profile", style: TextStyle(color: mainColour)),
        backgroundColor: Colors.white,
      ),
      body: buildWidget()
    );

  }
}