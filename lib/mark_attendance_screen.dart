// import 'package:firebase/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// // Mock definitions for Course, Session, and User classes
// class Course {
//   final String id;
//   final String courseName;
//   final String courseCode;
//   final String department;
//   final int yearOfStudy;
//   final int semester;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Course({
//     required this.id,
//     required this.courseName,
//     required this.courseCode,
//     required this.department,
//     required this.yearOfStudy,
//     required this.semester,
//     required this.createdAt,
//     required this.updatedAt,
//   });
// }

// class Session {
//   final String id;
//   final String courseId;
//   final DateTime startTime;
//   final DateTime endTime;
//   final bool isActive;
//   final bool isCompleted;
//   final double? locationLatitude;
//   final double? locationLongitude;
//   final String? wifiSSID;
//   final String? wifiBSSID;
//   final double? locationRadius;

//   Session({
//     required this.id,
//     required this.courseId,
//     required this.startTime,
//     required this.endTime,
//     required this.isActive,
//     required this.isCompleted,
//     this.locationLatitude,
//     this.locationLongitude,
//     this.wifiSSID,
//     this.wifiBSSID,
//     this.locationRadius,
//   });
// }

// class User {
//   final String id;
//   final String fullName;

//   User({required this.id, required this.fullName});
// }

// // Mock SessionBloc and SessionState classes
// class SessionBloc extends Bloc<SessionEvent, SessionState> {
//   SessionBloc() : super(SessionInitial());

//   @override
//   Stream<SessionState> mapEventToState(SessionEvent event) async* {
//     // Implement your event handling logic here
//   }
// }

// abstract class SessionEvent {}

// abstract class SessionState {}

// class SessionInitial extends SessionState {}

// class AttendanceMarked extends SessionState {}

// class SessionFailure extends SessionState {
//   final String message;

//   SessionFailure(this.message);
// }

// class MarkAttendanceScreen extends StatefulWidget {
//   final Session session;
//   final Course course;
//   final User currentUser;

//   const MarkAttendanceScreen({
//     super.key,
//     required this.session,
//     required this.course,
//     required this.currentUser,
//   });

//   @override
//   State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
// }

// class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
//   bool _isLoading = false;
//   bool _isLocationVerified = false;
//   bool _isWifiVerified = false;
//   String? _locationError;
//   String? _wifiError;
//   Position? _currentPosition;
//   String? _currentWifiSSID;
//   String? _currentWifiBSSID;
//   String? _deviceId;

//   @override
//   void initState() {
//     super.initState();
//     _initDeviceInfo();
//     _verifyRequirements();
//   }

//   Future<void> _initDeviceInfo() async {
//     try {
//       final deviceInfo = DeviceInfoPlugin();
//       if (Theme.of(context).platform == TargetPlatform.android) {
//         final androidInfo = await deviceInfo.androidInfo;
//         _deviceId = androidInfo.id;
//       } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         _deviceId = iosInfo.identifierForVendor;
//       }
//     } catch (e) {
//       debugPrint('Failed to get device ID: ${e.toString()}');
//     }
//   }

//   Future<void> _verifyRequirements() async {
//     setState(() {
//       _isLoading = true;
//       _locationError = null;
//       _wifiError = null;
//     });

//     try {
//       if (widget.session.locationLatitude != null) {
//         await _verifyLocation();
//       } else {
//         _isLocationVerified = true;
//       }

//       if (widget.session.wifiSSID != null) {
//         await _verifyWifi();
//       } else {
//         _isWifiVerified = true;
//       }
//     } catch (e) {
//       setState(() {
//         _locationError = 'Failed to verify requirements: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _verifyLocation() async {
//     try {
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           _isLocationVerified = false;
//           _locationError = 'Location services are disabled';
//         });
//         return;
//       }

//       // Check location permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _isLocationVerified = false;
//             _locationError = 'Location permission denied';
//           });
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _isLocationVerified = false;
//           _locationError = 'Location permissions are permanently denied';
//         });
//         return;
//       }

//       // Get current position
//       _currentPosition = await Geolocator.getCurrentPosition();

//       // Calculate distance between current position and session location
//       double distance = Geolocator.distanceBetween(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//         widget.session.locationLatitude!,
//         widget.session.locationLongitude!,
//       );

//       // Verify if within radius
//       if (distance <= widget.session.locationRadius!) {
//         setState(() {
//           _isLocationVerified = true;
//           _locationError = null;
//         });
//       } else {
//         setState(() {
//           _isLocationVerified = false;
//           _locationError =
//               'You are not within the attendance area (${distance.toStringAsFixed(0)}m away)';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLocationVerified = false;
//         _locationError = 'Failed to verify location: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _verifyWifi() async {
//     try {
//       // Get WiFi info
//       final networkInfo = NetworkInfo();
//       _currentWifiSSID = await networkInfo.getWifiName();
//       _currentWifiBSSID = await networkInfo.getWifiBSSID();

//       if (_currentWifiSSID == null || _currentWifiBSSID == null) {
//         setState(() {
//           _isWifiVerified = false;
//           _wifiError = 'Failed to get WiFi information';
//         });
//         return;
//       }

//       // Remove quotes from SSID if present
//       _currentWifiSSID = _currentWifiSSID!.replaceAll('"', '');

//       // Verify SSID and BSSID match
//       if (_currentWifiSSID == widget.session.wifiSSID &&
//           _currentWifiBSSID == widget.session.wifiBSSID) {
//         setState(() {
//           _isWifiVerified = true;
//           _wifiError = null;
//         });
//       } else {
//         setState(() {
//           _isWifiVerified = false;
//           _wifiError = 'Not connected to the required WiFi network';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isWifiVerified = false;
//         _wifiError = 'Failed to verify WiFi: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _markAttendance() async {
//     if (!_isLocationVerified || !_isWifiVerified) {
//       return;
//     }

//     if (_deviceId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to get device ID'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
      
//       if (mounted) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder:
//               (context) => AlertDialog(
//                 title: const Text('Success'),
//                 content: const Text(
//                   'Your attendance has been marked successfully.',
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close dialog
//                       Navigator.pop(context); // Go back to dashboard
//                     },
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to mark attendance: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SessionBloc, SessionState>(
//       listener: (context, state) {
//         if (state is AttendanceMarked) {
//           Navigator.pop(context); // Go back to dashboard
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Attendance marked successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else if (state is SessionFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Mark Attendance')),
//         body:
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSessionInfo(),
//                       const SizedBox(height: 24),
//                       _buildVerificationStatus(),
//                       const SizedBox(height: 24),
//                       _buildMarkAttendanceButton(),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }

//   Widget _buildSessionInfo() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.course.courseName, style: AppTheme.headlineMedium),
//             const SizedBox(height: 8),
//             Text(widget.course.courseCode, style: AppTheme.bodyLarge),
//             const SizedBox(height: 16),
//             _buildInfoRow(
//               Icons.calendar_today,
//               'Date',
//               '${widget.session.startTime.day}/${widget.session.startTime.month}/${widget.session.startTime.year}',
//             ),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               Icons.access_time,
//               'Time',
//               '${widget.session.startTime.hour}:${widget.session.startTime.minute} - ${widget.session.endTime.hour}:${widget.session.endTime.minute}',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20),
//         const SizedBox(width: 8),
//         Text('$label: ', style: AppTheme.bodyLarge),
//         Text(
//           value,
//           style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerificationStatus() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Verification Status', style: AppTheme.headlineLarge),
//             const SizedBox(height: 16),
//             if (widget.session.locationLatitude != null) ...[
//               _buildVerificationItem(
//                 'Location Verification',
//                 _isLocationVerified,
//                 _locationError,
//                 Icons.location_on,
//                 onRetry: _verifyLocation,
//               ),
//               const SizedBox(height: 16),
//             ],
//             if (widget.session.wifiSSID != null) ...[
//               _buildVerificationItem(
//                 'WiFi Verification',
//                 _isWifiVerified,
//                 _wifiError,
//                 Icons.wifi,
//                 onRetry: _verifyWifi,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVerificationItem(
//     String label,
//     bool isVerified,
//     String? error,
//     IconData icon, {
//     VoidCallback? onRetry,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, size: 24, color: isVerified ? Colors.green : Colors.red),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: AppTheme.bodyLarge),
//               if (error != null)
//                 Text(
//                   error,
//                   style: AppTheme.bodyLarge.copyWith(color: Colors.red),
//                 ),
//             ],
//           ),
//         ),
//         if (!isVerified && onRetry != null)
//           TextButton(onPressed: onRetry, child: const Text('Retry')),
//       ],
//     );
//   }

//   Widget _buildMarkAttendanceButton() {
//     final bool canMarkAttendance = _isLocationVerified && _isWifiVerified;

//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: canMarkAttendance ? _markAttendance : null,
//         child: const Text('Mark Attendance'),
//       ),
//     );
//   }
// }
