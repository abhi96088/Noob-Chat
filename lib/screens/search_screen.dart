import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noob_chat/widget/custom_texts.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';

  ///______________________ Function to handle logout ____________________________///
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
         appBar: AppBar(
        backgroundColor: const Color(0xFF2E8BFF),
        title: Text(
          'Noob Chat',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by name...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (val){
              setState((){
                searchQuery = val.toLowerCase();
              });
            },
          ),),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs
                    .where((doc) => doc['uid'] != currentUser!.uid)
                    .toList();

                final filteredUsers = users.where((doc){
                  final name = doc['name'].toString().toLowerCase();
                  return searchQuery.isEmpty || name.contains(searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return Center(
                      child: CustomText.labelText(text: "No users found!")
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    final userData = user.data() as Map<String, dynamic>;

                    final photoUrl = userData.containsKey('photoUrl')
                        ? userData['photoUrl'] as String
                        : '';

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                          photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                          child: photoUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          userData['name'] ?? userData['email'],
                          style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                        ),
                        subtitle:
                        Text(userData['email'], style: GoogleFonts.nunito()),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: {
                              'uid': userData['uid'],
                              'name': userData['name'],
                              'email': userData['email'],
                              'photoUrl': photoUrl,
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
