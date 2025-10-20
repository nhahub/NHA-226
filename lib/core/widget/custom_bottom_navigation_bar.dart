

// class CoustomBottomNavigationBar extends StatelessWidget {
//   const CoustomBottomNavigationBar({super.key, this.index = -1});

//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: index == -1 ? 0 : index,
//       onTap: (index) {
//         switch (index) {
//           case 0:
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               roadmapScreen,
//               (Route route) => false,
//             );
//             break;
//           case 1:
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               progressScreen,
//               (Route route) => false,
//             );
//             break;
//           case 2:
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               settingScreen,
//               (Route route) => false,
//             );
//             break;
//           default:
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               roadmapScreen,
//               (Route route) => false,
//             );
//         }
//       },
//       unselectedItemColor: Theme.of(context).colorScheme.secondary,
//       selectedItemColor: index == -1
//           ? Theme.of(context).colorScheme.secondary
//           : Theme.of(context).colorScheme.primary,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       iconSize: 24,
//       selectedFontSize: 12,
//       unselectedFontSize: 12,
//       items: [
//         BottomNavigationBarItem(
//           icon: index == 0
//               ? Padding(
//                   padding: const EdgeInsets.all(4),
//                   child: Icon(
//                     Icons.map,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(4),
//                   child: Icon(
//                     Icons.map_outlined,
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                 ),
//           label: 'Roadmap',
//         ),
//         BottomNavigationBarItem(
//           icon: index == 1
//               ? SvgPicture.asset(
//                   'assets/images/svg/selected_progress.svg',
//                   color: Theme.of(context).colorScheme.primary,
//                 )
//               : SvgPicture.asset(
//                   'assets/images/svg/unselected_progress.svg',
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//           label: 'Progress',
//         ),
//         BottomNavigationBarItem(
//           icon: index == 2
//               ? SvgPicture.asset(
//                   'assets/images/svg/selected_settings.svg',
//                   color: Theme.of(context).colorScheme.primary,
//                 )
//               : SvgPicture.asset(
//                   'assets/images/svg/unselected_settings.svg',
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//           label: 'Settings',
//         ),
//       ],
//     );
//   }
// }
