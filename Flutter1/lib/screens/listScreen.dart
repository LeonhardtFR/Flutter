import 'package:flutter/material.dart';

class listScreen extends StatefulWidget {
  const listScreen({Key? key}) : super(key: key);

  @override
  State<listScreen> createState() => _listScreenState();
}

class _listScreenState extends State<listScreen> {

  final List<String> items = List<String>.generate(100, (i) => "Titre $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.abc, size: 56),
                  title: Text('$item'),
                  subtitle: const Text('Informations de la liste.'),
                  trailing: const Icon(Icons.more_vert),
                ),
              );
            },
          )

            // child: ListView(
            //   children: const [
            //     Card(
            //       child: ListTile(
            //         leading: Icon(Icons.abc, size: 56),
            //         title: Text('Titre de la liste1'),
            //         subtitle: Text('Informations de la liste.'),
            //         trailing: Icon(Icons.more_vert),
            //       ),
            //     ),
            //   ],
            // )
        )
    );
  }
}
