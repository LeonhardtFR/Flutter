import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Library'),
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: 'Songs'),
                          Tab(text: 'Albums'),
                          Tab(text: 'Artists'),
                          Tab(text: 'Genres'),
                        ],
                      ),
                    ),
                    body: const TabBarView(
                      children: [
                        Center(child: Text('Songs')),
                        Center(child: Text('Albums')),
                        Center(child: Text('Artists')),
                        Center(child: Text('Genres')),
                      ],
                    ),
                  ),
                )
            )
          ],
        )
    );
  }
}
