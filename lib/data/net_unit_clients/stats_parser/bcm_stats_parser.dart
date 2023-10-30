// import 'package:xdslmt/data/models/line_stats.dart';

// // This parser will receive parts of messages
// // finds needed data with regex
// // when all data parts is received it will pass answer throught callback function

// class BCMTelnetParser {
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
//     'downFEC': null,
//   };
//   //callback
//   var cb;

//   // Constructor
//   BCMTelnetParser(this.cb);

//   // Receives messages find data parts with regex
//   void receiver(msg) {
//     msg = String.fromCharCodes(msg).trim();

//     if ('Status: Showtime'.allMatches(msg).isNotEmpty) {
//       try {
//         lineData['connectionType'] = RegExp(r'(?<=Mode:                   ).+').firstMatch(msg).group(0);
//         var spd = RegExp(r'(?<=Bearer: 0,).+').firstMatch(msg).group(0);

//         lineData['upMaxRate'] = RegExp(r'(?<=Upstream rate = )\d+').firstMatch(spd).group(0);
//         lineData['downMaxRate'] = RegExp(r'(?<=Downstream rate = )\d+').firstMatch(spd).group(0);

//         var maxSpd = RegExp(r'(?<=Max:    ).+').firstMatch(msg).group(0);

//         lineData['upRate'] = RegExp(r'(?<=Upstream rate = )\d+').firstMatch(maxSpd).group(0);
//         lineData['downRate'] = RegExp(r'(?<=Downstream rate = )\d+').firstMatch(maxSpd).group(0);

//         var snr = RegExp(r'(?<=SNR \(dB\):).+').firstMatch(msg)?.group(0);
//         var snrArr = snr.split(RegExp(r'\s+'));

//         lineData['upMargin'] = snrArr[2];
//         lineData['downMargin'] = snrArr[1];

//         var att = RegExp(r'(?<=Attn\(dB\):).+').firstMatch(msg)?.group(0);
//         var attArr = att.split(RegExp(r'\s+'));
//         lineData['upAttenuation'] = attArr[2];
//         lineData['downAttenuation'] = attArr[1];

//         var fex = RegExp(r'(?<=RSCorr:).+').firstMatch(msg)?.group(0);
//         var fecArr = fex.split(RegExp(r'\s+'));
//         lineData['upFEC'] = fecArr[2];
//         lineData['downFEC'] = fecArr[1];

//         var crc = RegExp(r'(?<=RSUnCorr:).+').firstMatch(msg)?.group(0);
//         var crcArr = crc.split(RegExp(r'\s+'));
//         lineData['upCRC'] = crcArr[2];
//         lineData['downCRC'] = crcArr[1];
//       } catch (e) {
//         cb(LineStatsCollection(
//           isErrored: true,
//           isConnectionUp: false,
//           status: 'data error',
//           dateTime: DateTime.now(),
//         ));
//       }

//       checkFoAll();
//       return;
//     } else if ('Status: '.allMatches(msg).isNotEmpty) {
//       cb(LineStatsCollection(
//         isErrored: false,
//         isConnectionUp: false,
//         status: RegExp(r'(?<=Status: ).+').firstMatch(msg)?.group(0),
//         dateTime: DateTime.now(),
//       ));
//     }
//   }

//   // Check for all data parts
//   // When all parts received pass LineStatsCollection throught callback
//   void checkFoAll() {
//     if (!lineData.values.contains(null)) {
//       cb(
//         LineStats.connectionUp(
//           snapshotId: '',
//           statusText: 'Up',
//           connectionType: lineData['connectionType'],
//           upAttainableRate: int.parse(lineData['upMaxRate']),
//           downAttainableRate: int.parse(lineData['downMaxRate']),
//           upRate: int.parse(lineData['upRate']),
//           downRate: int.parse(lineData['downRate']),
//           upMargin: double.parse(lineData['upMargin']),
//           downMargin: double.parse(lineData['downMargin']),
//           upAttenuation: double.parse(lineData['upAttenuation']),
//           downAttenuation: double.parse(lineData['downAttenuation']),
//           upCRC: int.parse(lineData['upCRC']),
//           downCRC: int.parse(lineData['downCRC']),
//           upFEC: int.parse(lineData['upFEC']),
//           downFEC: int.parse(lineData['downFEC']),
//           upCRCIncr: int.parse(lineData['upCRC']),
//           downCRCIncr: int.parse(lineData['downCRC']),
//           upFECIncr: int.parse(lineData['upFEC']),
//           downFECIncr: int.parse(lineData['downFEC']),
//           // dateTime: DateTime.now(),
//         ),
//       );
//     }
//   }
// }


// // TODO common BCM63xx and trendchip parser
