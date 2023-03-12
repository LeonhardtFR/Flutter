import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with TickerProviderStateMixin {

  // Appbar controller
  TabController? _tabController;

  // De base, il ne détecte pas de musique dans la librairie
  bool musicExist = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  // WIDGET BUILD METHOD \\
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: const Text('Library'),
                      backgroundColor: Colors.black,
                      bottom: TabBar(
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.white,
                        indicatorColor: Colors.blueAccent,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _tabController,
                        onTap: (int index) {
                          setState(() {
                            _tabController!.index = index;
                          });
                        },
                        tabs: const [
                          Tab(text: 'Songs'),
                          Tab(text: 'Albums'),
                          Tab(text: 'Artists'),
                          Tab(text: 'Genres'),
                        ],
                      ),

                      // Icone de recherche dans l'AppBar
                      actions: [
                        IconButton(
                          onPressed: () {
                            // showSearch(context: context, delegate: delegate)
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),

                    body: !musicExist
                        ? const Center(
                      child: Text('No music found in the storage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                    )
                        : TabBarView(
                      controller: _tabController,
                      children: const [
                        Center(child: Text('Songs', style: TextStyle(color: Colors.white)))
                      ],
                    ),


                    // body: const TabBarView(
                    //   children: [
                    //     Center(child: Text('Songs')),
                    //     Center(child: Text('Albums')),
                    //     Center(child: Text('Artists')),
                    //     Center(child: Text('Genres')),
                    //   ],
                    // ),
                  ),
                )
            )
          ],
        )
    );
  }
}
