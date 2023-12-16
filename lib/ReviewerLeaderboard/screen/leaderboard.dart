// import 'package:flutter/material.dart';

// class LeaderboardPage extends StatelessWidget {
//   const LeaderboardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.pink,
//       ),
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Leaderboard')),
//         body: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Leaderboard()
//           ]
//         ),
//       ),
//     );
//   }
// }

// class Leaderboard extends StatelessWidget {
//   const Leaderboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       columnSpacing: 100.0,
//       columns: const <DataColumn>[
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Name',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Teacher Status',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Total Review',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Total Stars',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//       ],
//       rows: const <DataRow>[
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('a')),
//             DataCell(Text('a')),
//             DataCell(Text('a')),
//             DataCell(Text('a')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('b')),
//             DataCell(Text('b')),
//             DataCell(Text('b')),
//             DataCell(Text('a')),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('c')),
//             DataCell(Text('c')),
//             DataCell(Text('c')),
//             DataCell(Text('a')),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Leaderboard')),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Leaderboard(),
            ),
          ),
        ),
      ),
    );
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 0.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Add border to the table
      ),
      columns: const <DataColumn>[
        DataColumn(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        DataColumn(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Teacher Status',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        DataColumn(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Total Review',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        DataColumn(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Total Stars',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Center(child: Text('a'))),
            DataCell(Center(child: Text('a'))),
            DataCell(Center(child: Text('a'))),
            DataCell(Center(child: Text('a'))),
          ],
        ),
      ],
    );
  }
}
