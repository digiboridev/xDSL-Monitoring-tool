// import 'LineStatsCollection.dart';

// // This parser will receive parts of messages
// // finds needed data with regex
// // when all data parts is received it will pass answer throught callback function

// class TrendchipTelnetParser {
//   // Data parts
//   Map lineData = {
//     'connectionType': 'null',
//     'upMaxRate': null,
//     'downMaxRate': null,
//     'upRate': null,
//     'downRate': null,
//     'upMargin': null,
//     'downMargin': null,
//     'upAttenuation': null,
//     'downAttenuation': null,
//     'upCRC': null,
//     'downCRC': null,
//     'upFEC': null,
//     'downFEC': null
//   };
//   //callback
//   var cb;

//   // Constructor
//   TrendchipTelnetParser(this.cb);

//   // Receives messages find data parts with regex
//   void receiver(msg) {
//     msg = String.fromCharCodes(msg).trim();

//     if ('status: down'.allMatches(msg).isNotEmpty) {
//       cb(LineStatsCollection(
//         isErrored: false,
//         isConnectionUp: false,
//         status: 'no signal',
//         dateTime: DateTime.now(),
//       ));
//       return;
//     } else if ('status: initializing'.allMatches(msg).isNotEmpty) {
//       cb(LineStatsCollection(
//         isErrored: false,
//         isConnectionUp: false,
//         status: 'initializing',
//         dateTime: DateTime.now(),
//       ));
//       return;
//     } else {
//       lineData['connectionType'] =
//           RegExp(r'(?<=operational mode: ).+').firstMatch(msg)?.group(0) ??
//               lineData['connectionType'];
//       lineData['downMaxRate'] =
//           RegExp(r'(?<=ATTNDRds    = )\d+').firstMatch(msg)?.group(0) ??
//               lineData['downMaxRate'];
//       lineData['upMaxRate'] =
//           RegExp(r'(?<=ATTNDRus    = )\d+').firstMatch(msg)?.group(0) ??
//               lineData['upMaxRate'];
//       lineData['downRate'] =
//           RegExp(r'(?<=near-end interleaved channel bit rate: )(.*)(?= kbps)')
//                   .firstMatch(msg)
//                   ?.group(0) ??
//               lineData['downRate'];
//       lineData['upRate'] =
//           RegExp(r'(?<=far-end interleaved channel bit rate: )(.*)(?= kbps)')
//                   .firstMatch(msg)
//                   ?.group(0) ??
//               lineData['upRate'];
//       lineData['upMargin'] = RegExp(r'(?<=noise margin upstream: )(.*)(?= db)')
//               .firstMatch(msg)
//               ?.group(0) ??
//           lineData['upMargin'];
//       lineData['downMargin'] =
//           RegExp(r'(?<=noise margin downstream: )(.*)(?= db)')
//                   .firstMatch(msg)
//                   ?.group(0) ??
//               lineData['downMargin'];
//       lineData['upAttenuation'] =
//           RegExp(r'(?<=attenuation upstream: )(.*)(?= db)')
//                   .firstMatch(msg)
//                   ?.group(0) ??
//               lineData['upAttenuation'];
//       lineData['downAttenuation'] =
//           RegExp(r'(?<=attenuation downstream: )(.*)(?= db)')
//                   .firstMatch(msg)
//                   ?.group(0) ??
//               lineData['downAttenuation'];
//       lineData['upCRC'] = RegExp(r'(?<=far-end CRC error interleaved: )\d+')
//               .firstMatch(msg)
//               ?.group(0) ??
//           lineData['upCRC'];
//       lineData['downCRC'] = RegExp(r'(?<=near-end CRC error interleaved: )\d+')
//               .firstMatch(msg)
//               ?.group(0) ??
//           lineData['downCRC'];
//       lineData['upFEC'] = RegExp(r'(?<=far-end FEC error interleaved: )\d+')
//               .firstMatch(msg)
//               ?.group(0) ??
//           lineData['upFEC'];
//       lineData['downFEC'] = RegExp(r'(?<=near-end FEC error interleaved: )\d+')
//               .firstMatch(msg)
//               ?.group(0) ??
//           lineData['downFEC'];
//     }

//     checkFoAll();
//   }

//   // Check for all data parts
//   // When all parts received pass LineStatsCollection throught callback
//   void checkFoAll() {
//     if (!lineData.values.contains(null)) {
//       cb(LineStatsCollection(
//         isErrored: false,
//         isConnectionUp: true,
//         status: 'Up',
//         connectionType: lineData['connectionType'],
//         upMaxRate: int.parse(lineData['upMaxRate']),
//         downMaxRate: int.parse(lineData['downMaxRate']),
//         upRate: int.parse(lineData['upRate']),
//         downRate: int.parse(lineData['downRate']),
//         upMargin: double.parse(lineData['upMargin']),
//         downMargin: double.parse(lineData['downMargin']),
//         upAttenuation: double.parse(lineData['upAttenuation']),
//         downAttenuation: double.parse(lineData['downAttenuation']),
//         upCRC: int.parse(lineData['upCRC']),
//         downCRC: int.parse(lineData['downCRC']),
//         upFEC: int.parse(lineData['upFEC']),
//         downFEC: int.parse(lineData['downFEC']),
//         dateTime: DateTime.now(),
//       ));
//     }
//   }
// }
