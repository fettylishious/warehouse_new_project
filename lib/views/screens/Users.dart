// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({super.key});
//
//   @override
//   _UsersScreenState createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
//   List<Map<dynamic, dynamic>> _users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }
//
//   Future<void> _fetchUsers() async {
//     DataSnapshot snapshot = await _usersRef.get();
//     if (snapshot.exists) {
//       Map data = snapshot.value as Map;
//       setState(() {
//         _users = data.entries.map((e) => Map<dynamic, dynamic>.from(e.value)).toList();
//       });
//     }
//   }
//
//   Future<void> _verifyUser(String key) async {
//     await _usersRef.child(key).update({'verificationstatus': 'verified'});
//     _fetchUsers(); // Refresh the user list
//   }
//
//   Future<void> _deleteUser(String key) async {
//     await _usersRef.child(key).remove();
//     _fetchUsers(); // Refresh the user list
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Users'),
//       ),
//       body: _users.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _users.length,
//         itemBuilder: (context, index) {
//           Map<dynamic, dynamic> user = _users[index];
//           String userId = user['id']; // Assume each user has an 'id'
//           String name = user['name'] ?? 'No name';
//           String status = user['verificationstatus'] ?? 'unverified';
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(name),
//               subtitle: Text('Status: $status'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (status == 'unverified')
//                     IconButton(
//                       icon: const Icon(Icons.verified),
//                       color: Colors.green,
//                       onPressed: () => _verifyUser(userId),
//                     ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     color: Colors.red,
//                     onPressed: () => _deleteUser(userId),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({super.key});
//
//   @override
//   _UsersScreenState createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
//   List<Map<dynamic, dynamic>> _users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }
//
//   Future<void> _fetchUsers() async {
//     try {
//       DataSnapshot snapshot = await _usersRef.get();
//       if (snapshot.exists && snapshot.value != null) {
//         Map data = snapshot.value as Map;
//         setState(() {
//           _users = data.entries.map((e) => Map<dynamic, dynamic>.from(e.value)).toList();
//         });
//       } else {
//         // Handle the case where no data is found
//         setState(() {
//           _users = [];
//         });
//       }
//     } catch (e) {
//       // Handle any errors that might occur during the fetch
//       print('Error fetching users: $e');
//       setState(() {
//         _users = [];
//       });
//     }
//   }
//
//   Future<void> _verifyUser(String key) async {
//     try {
//       await _usersRef.child(key).update({'verificationstatus': 'verified'});
//       _fetchUsers(); // Refresh the user list
//     } catch (e) {
//       // Handle errors that might occur during the update
//       print('Error verifying user: $e');
//     }
//   }
//
//   Future<void> _deleteUser(String key) async {
//     try {
//       await _usersRef.child(key).remove();
//       _fetchUsers(); // Refresh the user list
//     } catch (e) {
//       // Handle errors that might occur during the delete
//       print('Error deleting user: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Users'),
//       ),
//       body: _users.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _users.length,
//         itemBuilder: (context, index) {
//           Map<dynamic, dynamic> user = _users[index];
//
//           // Safely access user data
//          // String? userId = user['id']?.toString();
//           //String? userId = userCredential.user?.uid.toString();
//           String? userId = userCredential.user?.uid;
//
//           String name = user['firstName']?.toString() ?? 'No name';
//           String status = user['verificationstatus']?.toString() ?? 'unverified';
//
//           // Ensure userId is not null before proceeding
//           if (userId == null) return SizedBox.shrink();
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(name),
//               subtitle: Text('Status: $status'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (status == 'unverified')
//                     IconButton(
//                       icon: const Icon(Icons.verified),
//                       color: Colors.green,
//                       onPressed: () => _verifyUser(userId),
//                     ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     color: Colors.red,
//                     onPressed: () => _deleteUser(userId),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({super.key});
//
//   @override
//   _UsersScreenState createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
//   List<Map<String, dynamic>> _users = []; // Updated type to Map<String, dynamic>
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }
//
//   Future<void> _fetchUsers() async {
//     try {
//       DataSnapshot snapshot = await _usersRef.get();
//       if (snapshot.exists && snapshot.value != null) {
//         Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map); // Ensure correct type conversion
//         setState(() {
//           _users = data.entries.map((e) => {'key': e.key, ...Map<String, dynamic>.from(e.value)}).toList();
//         });
//       } else {
//         // Handle the case where no data is found
//         setState(() {
//           _users = [];
//         });
//       }
//     } catch (e) {
//       // Handle any errors that might occur during the fetch
//       print('Error fetching users: $e');
//       setState(() {
//         _users = [];
//       });
//     }
//   }
//
//   Future<void> _verifyUser(String key) async {
//     try {
//       await _usersRef.child(key).update({'verificationstatus': 'verified'});
//       _fetchUsers(); // Refresh the user list
//     } catch (e) {
//       // Handle errors that might occur during the update
//       print('Error verifying user: $e');
//     }
//   }
//
//   Future<void> _deleteUser(String key) async {
//     try {
//       await _usersRef.child(key).remove();
//       _fetchUsers(); // Refresh the user list
//     } catch (e) {
//       // Handle errors that might occur during the delete
//       print('Error deleting user: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Users'),
//       ),
//       body: _users.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _users.length,
//         itemBuilder: (context, index) {
//           Map<String, dynamic> user = _users[index];
//
//           // Safely access user data
//           String userId = user['key']; // Use 'key' to identify the user in Firebase
//           String name = user['firstName']?.toString() ?? 'No name';
//           String status = user['verificationstatus']?.toString() ?? 'unverified';
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(name),
//               subtitle: Text('Status: $status'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (status == 'unverified')
//                     IconButton(
//                       icon: const Icon(Icons.verified),
//                       color: Colors.green,
//                       onPressed: () => _verifyUser(userId),
//                     ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     color: Colors.red,
//                     onPressed: () => _deleteUser(userId),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  List<Map<String, dynamic>> _users = []; // Updated type to Map<String, dynamic>

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      DataSnapshot snapshot = await _usersRef.get();
      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map); // Ensure correct type conversion
        setState(() {
          _users = data.entries.map((e) => {'key': e.key, ...Map<String, dynamic>.from(e.value)}).toList();
        });
      } else {
        // Handle the case where no data is found
        setState(() {
          _users = [];
        });
      }
    } catch (e) {
      // Handle any errors that might occur during the fetch
      print('Error fetching users: $e');
      setState(() {
        _users = [];
      });
    }
  }

  Future<void> _verifyUser(String key) async {
    try {
      await _usersRef.child(key).update({'verificationstatus': 'verified'});
      _fetchUsers(); // Refresh the user list
    } catch (e) {
      // Handle errors that might occur during the update
      print('Error verifying user: $e');
    }
  }

  Future<void> _deleteUser(String key) async {
    try {
      await _usersRef.child(key).remove();
      _fetchUsers(); // Refresh the user list
    } catch (e) {
      // Handle errors that might occur during the delete
      print('Error deleting user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: _users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> user = _users[index];

          // Safely access user data
          String userId = user['key']; // Use 'key' to identify the user in Firebase
          String name = user['firstName']?.toString() ?? 'No name';
          String lname = user['lastName']?.toString() ?? 'No name';
          String email = user['email']?.toString() ?? 'No name';
          String status = user['verificationstatus']?.toString() ?? 'unverified';
          String names = name +'   ' +lname + '  ';

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(names) ,

              //subtitle: Text('Status: $status'),
              //subtitle: Text('Status: $status'),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: $status'),
                  Text('Email: $email'), // Second subtitle line
                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (status == 'notverified')
                    IconButton(
                      icon: const Icon(Icons.verified),
                      color: Colors.green,
                      onPressed: () => _verifyUser(userId),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () => _deleteUser(userId),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
