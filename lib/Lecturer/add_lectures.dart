import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login_flutter/Lecturer/lecturer_main.dart';

class AddLectures extends StatefulWidget {
  const AddLectures({Key? key}) : super(key: key);

  @override
  State<AddLectures> createState() => _AddLecturesState();
}

class _AddLecturesState extends State<AddLectures> {

  final user = FirebaseAuth.instance.currentUser!;

  int _currentPageIndex = 0; // track the current page index

  final _subjectCodeController = TextEditingController();
  final _lectureTopicController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _venueController = TextEditingController();

  // define a list of pages to navigate to
  final List<Widget> _pages = [    LecturerMain(),  ];

  // update the current page index
  // void _updatePageIndex(int index) {
  //   setState(() {
  //     _currentPageIndex = index;
  //     if (_currentPageIndex == 0) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => LecturerMain()),
  //       );
  //     }
  //     else if (_currentPageIndex == 1) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => Profile()),
  //       );
  //     }
  //   });
  // }

  final _formKey = GlobalKey<FormState>();
  String _subjectCode = '';
  String _lectureTopic = '';
  DateTime? _date;
  TimeOfDay? _time;
  String _venue = '';



  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform form submission logic here, e.g. send data to server
      print('Submitting form:');
      print('Subject Code: $_subjectCode');
      print('Lecture Topic: $_lectureTopic');
      print('Date: $_date');
      print('Time: $_time');
      print('Venue: $_venue');

    }
  }

  Future addLectures ({required String subCode, required String lecTopic, required DateTime? date, required String time, required String venue}) async {
    final docUser = FirebaseFirestore.instance.collection('lecture').doc();

    final json = {
      'subject code': subCode,
      'lecture topic': lecTopic,
      'date': date,
      'time': time,
      'venue': venue,
      'lecturerEmail': user.email!,
    };

    await docUser.set(json);

  }

  Future<void> _selectImage() async {
    // TODO: Implement image selection logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Lectures"),
      ),

      //body
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top:100, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _subjectCodeController,
                  decoration: InputDecoration(
                    labelText: 'Subject Code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Subject Code';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _subjectCode = value!;
                  },
                ),

                SizedBox(height: 16.0),
                TextFormField(
                  controller: _lectureTopicController,
                  decoration: InputDecoration(
                    labelText: 'Lecture Topic',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the lecture topic';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lectureTopic = value!;
                  },
                ),

                SizedBox(height: 16.0),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _date = pickedDate;
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),

                      validator: (value) {
                        if (_date == null) {
                          return 'Please select the lecture date';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // Do nothing
                      },
                      controller: TextEditingController(
                        text: _date == null
                            ? ''
                            : '${_date!.day}/${_date!.month}/${_date!.year}',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _time = pickedTime;
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        ),

                      validator: (value) {
                        if (_time == null) {
                          return 'Please select the lecture time';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // Do nothing
                      },
                      controller: TextEditingController(

                        text: _time == null ? '' : _time!.format(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _venueController,
                  decoration: InputDecoration(
                    labelText: 'Venue',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the lecture venue';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _venue = value!;
                  },
                ),


                SizedBox(height: 16.0),
                ElevatedButton(
                  // onPressed: _submitForm,
                  onPressed: () {
                    final subCode = _subjectCodeController.text.trim();
                    final lecTopic = _lectureTopicController.text.trim();
                    final date = _date;
                    final time = _time.toString();
                    final venue = _venueController.text.trim();

                    addLectures(subCode: subCode, lecTopic: lecTopic, date: date, time: time, venue: venue);

                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),

      //bottom navbar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentPageIndex, // highlight the current icon
      //   // onTap: (){
      //   // },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}