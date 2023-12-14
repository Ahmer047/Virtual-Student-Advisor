import 'package:bu_vsa/ui/student_screens/calculate_gpa/cgpa_screen.dart';
import 'package:bu_vsa/ui/student_screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Course {
  double creditHours = 0;
  String courseTitle = '';
  double marks = 0;

  TextEditingController creditHoursController = TextEditingController();
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController marksController = TextEditingController();

  double get gradePoint {
    if (marks >= 85) {
      return 4.0;
    } else if (marks >= 80) {
      return 3.67;
    } else if (marks >= 75) {
      return 3.33;
    } else if (marks >= 71) {
      return 3.0;
    } else if (marks >= 68) {
      return 2.67;
    } else if (marks >= 64) {
      return 2.33;
    } else if (marks >= 60) {
      return 2.0;
    } else if (marks >= 57) {
      return 1.87;
    } else if (marks >= 53) {
      return 1.33;
    } else if (marks >= 50) {
      return 1.0;
    } else {
      return 0;
    }
  }

  // Add initial hint text values to the class
  String initialCreditHoursHint = 'Cr. Hrs';
  String initialCourseTitleHint = 'Course Title';
  String initialMarksHint = 'Marks';
}

class GpaScreen extends StatefulWidget {
  const GpaScreen({Key? key}) : super(key: key);

  @override
  _GpaScreenState createState() => _GpaScreenState();
}

class _GpaScreenState extends State<GpaScreen> {
  List<Course> courses = List.generate(6, (index) => Course());

  // Function to calculate CGPA
  double calculateCGPA() {
    double totalCreditHours = courses.fold(0, (sum, course) => sum + course.creditHours);
    double totalGradePoints =
    courses.fold(0, (sum, course) => sum + course.creditHours * course.gradePoint);
    return totalCreditHours == 0 ? 0 : totalGradePoints / totalCreditHours;
  }

  // Function to reset all course fields to initial values
  void resetFields() {
    setState(() {
      for (var course in courses) {
        course.creditHours = 0;
        course.courseTitle = '';
        course.marks = 0;

        // After resetting, set the initial hint values in the text fields
        course.creditHoursController.clear();
        course.courseTitleController.clear();
        course.marksController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF00205C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        title: Text(
          "GPA Calculator",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false, // Text aligns to the left
        actions: <Widget>[
          Container(
            width: 140,  // Set the width
            height: 25,  // Set the new height
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.calculate, color: Color(0xFF00205C), size: 35.0),
                // "calculate" icon with color 0xFF00205C
                label: Text(
                  "CGPA",
                  style: TextStyle(
                    color: Color(0xFF00205C),  // Text color set to 0xFF00205C
                    fontWeight: FontWeight.bold,
                    fontSize: 22,  // Set the text size
                  ),
                ),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CgpaScreen(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,  // Button color set to white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              height: 96.0,
              decoration: BoxDecoration(
                color: Color(0xFF00205C),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Credit Hrs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Course Title",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,

                      alignment: Alignment.center,
                      child: Text(
                        "Marks",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseRow(
                    course: courses[index],
                    onCreditHoursChanged: (value) {
                      setState(() {
                        courses[index].creditHours = double.tryParse(value) ?? 0;
                      });
                    },
                    onCourseTitleChanged: (value) {
                      setState(() {
                        courses[index].courseTitle = value;
                      });
                    },
                    onMarksChanged: (value) {
                      setState(() {
                        courses[index].marks = double.tryParse(value) ?? 0;
                      });
                    },
                  );
                },
              ),
            ),
            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      resetFields();
                    },
                    icon: Icon(
                      Icons.restore,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Reset",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF00205C),
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add a new course
                      if (courses.length < 10) {
                        setState(() {
                          courses.add(Course());
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Maximum Courses Reached"),
                              content: Text("You can add up to 10 courses."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Add Course",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF00205C),
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(

              onPressed: () {
                double cgpa = calculateCGPA();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Result"),
                      content: Text("Your GPA is: ${cgpa.toStringAsFixed(2)}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.calculate,
                color: Colors.white,
              ),
              label: Text(
                "Calculate",
                style: TextStyle(

                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(

                primary: Color(0xFF00205C),
                minimumSize: Size(double.infinity, 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseRow extends StatelessWidget {
  final Course course;
  final ValueChanged<String> onCreditHoursChanged;
  final ValueChanged<String> onCourseTitleChanged;
  final ValueChanged<String> onMarksChanged;

  CourseRow({
    required this.course,
    required this.onCreditHoursChanged,
    required this.onCourseTitleChanged,
    required this.onMarksChanged,
  }) : super(key: ValueKey(course)); // Add a ValueKey to the widget.

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 56.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: course.creditHoursController,
                  onChanged: onCreditHoursChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: course.marks == 0 ? FontStyle.italic : FontStyle.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: course.initialCreditHoursHint,
                    hintStyle: TextStyle(
                      fontStyle: course.marks == 0 ? FontStyle.italic : FontStyle.normal,
                    ),
                    errorText:
                    (course.creditHours > 0 && course.creditHours < 1) ? "Invalid Credit Hours" : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 56.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: course.courseTitleController,
                  onChanged: onCourseTitleChanged,
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: course.marks == 0 ? FontStyle.italic : FontStyle.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: course.initialCourseTitleHint,
                    hintStyle: TextStyle(
                      fontStyle: course.marks == 0 ? FontStyle.italic : FontStyle.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 56.0,
              decoration: BoxDecoration(


                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: course.marksController,
                  onChanged: onMarksChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: course.marks == 0 ? FontStyle.italic : FontStyle.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: course.initialMarksHint,
                    hintStyle: TextStyle(
                      fontStyle: course.marks == 0 ? FontStyle.italic : FontStyle.normal,
                    ),
                    errorText: (course.marks > 100) ? "Marks cannot be more than 100" : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 5.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


