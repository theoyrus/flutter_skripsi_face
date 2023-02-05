import 'package:flutter/material.dart';

class DrawerScaffoldWidget extends StatelessWidget {
  final Widget? child;
  const DrawerScaffoldWidget({
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: AppBar(),
      drawer: const Drawer(child: DrawerWidget()),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          child: Icon(
            Icons.face,
          ),
        ),
        Flexible(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
