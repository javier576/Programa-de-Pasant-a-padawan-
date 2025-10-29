import 'package:flutter/material.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);
  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<Destination> destinations = <Destination>[
  Destination('Index', Icon(Icons.menu_outlined), Icon(Icons.menu)),
  Destination(
    'CustomPaint',
    Icon(Icons.format_paint_outlined),
    Icon(Icons.format_paint),
  ),
  Destination(
    'Notificacion Push',
    Icon(Icons.circle_notifications_outlined),
    Icon(Icons.circle_notifications),
  ),
  Destination(
    'Programar Agenda',
    Icon(Icons.assignment_outlined),
    Icon(Icons.assignment),
  ),
  Destination('Agenda', Icon(Icons.event_outlined), Icon(Icons.event)),
];

class Menunavegacion extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  const Menunavegacion({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Menu', style: Theme.of(context).textTheme.titleSmall),
        ),

        ...destinations.map((Destination destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.icon,
          );
        }),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
      ],
    );
  }
}
