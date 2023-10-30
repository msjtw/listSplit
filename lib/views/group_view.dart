import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_split/providers/authprovider.dart';
import 'package:list_split/providers/firestore_provider.dart';
import 'package:list_split/services/models/firestore_models.dart';
import 'package:list_split/services/prompts/group_name_prompt.dart';
import 'package:list_split/services/prompts/you_sure_prompt.dart';

class GroupView extends ConsumerStatefulWidget {
  const GroupView(this.groupUid, {super.key});

  final String groupUid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupViewState();
}

class _GroupViewState extends ConsumerState<GroupView> {
  @override
  Widget build(BuildContext context) {
    final groupDoc = ref.watch(groupProvider(widget.groupUid));

    return groupDoc.when(
      error: (error, stackTrace) => const Center(
        child: Column(
          children: [
            Text('Error :('),
          ],
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (data) {
        Group? group = data.data();
        if (group != null) {
          return groupView(group);
        } else {
          return const Center(
            child: Text('Error :('),
          );
        }
      },
    );
  }

  Widget groupView(Group group) {
    User user = ref.watch(firebaseAuthProvider).getUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Group ${group.name}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    group.uid,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: group.uid))
                          .then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('uid copied'),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    iconSize: 18,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    groupNameChange(context, group).then(
                      (group) {
                        if (group != null) {
                          ref.read(firestoreProvider).addNewGroup(group);
                        }
                      },
                    );
                  },
                  child: Text(
                    (group.description.isNotEmpty
                        ? group.description
                        : "Add description"),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Users:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: group.usersUids.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(group.usersUids[index]),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await youSure(context).then((areTheySure) {
                      if (areTheySure == true) {
                        Navigator.pop(context);
                        ref.read(firestoreProvider).leaveGroup(user, group.uid);
                      }
                    });
                  },
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('leave group'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
