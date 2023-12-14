import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Imported for using Colors

class CgpaScreen extends StatefulWidget {
  @override
  _CgpaScreenState createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  TextEditingController currentGpaController = TextEditingController();
  TextEditingController currentCreditHoursController = TextEditingController();
  TextEditingController previousGpaController = TextEditingController();
  TextEditingController totalPreviousCreditHoursController = TextEditingController();

  double? calculatedCgpa;
  void calculateCgpa() {
    double currentGpa = double.tryParse(currentGpaController.text) ?? -1;
    double currentCreditHours = double.tryParse(currentCreditHoursController.text) ?? -1;
    double previousGpa = double.tryParse(previousGpaController.text) ?? -1;
    double totalPreviousCreditHours = double.tryParse(totalPreviousCreditHoursController.text) ?? -1;

    List<String> errors = [];

    if (currentGpa == -1 || currentCreditHours == -1 || previousGpa == -1 || totalPreviousCreditHours == -1) {
      errors.add("All fields must be filled.");
    }
    else {
      if (currentGpa < 1 || currentGpa > 4) {
        errors.add("Current GPA should be between 1 and 4.");
      }

      if (currentCreditHours < 1 || currentCreditHours > 22) {
        errors.add("Credit Hours should be less than or equal to 22.");
      }

      if (previousGpa < 1 || previousGpa > 4) {
        errors.add("Previous CGPA should be between 1 and 4.");
      }

      if (totalPreviousCreditHours < 1 || totalPreviousCreditHours > 150) {
        errors.add("Total Credit Hours should be less than or equal to 150.");
      }
    }
    if (errors.isNotEmpty) {
      _showErrorDialog(errors.join('\n'));
      return;
    }

    double cgpa = ((previousGpa * totalPreviousCreditHours) + (currentGpa * currentCreditHours)) / (totalPreviousCreditHours + currentCreditHours);

    setState(() {
      calculatedCgpa = cgpa;
    });
  }


  void _showErrorDialog(String message) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Calculate CGPA", style: TextStyle(color: Color(0xFF00205C))),
      content: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              _buildInputRow("Current GPA", currentGpaController),
              SizedBox(height: 10),
              _buildInputRow("Credit Hours", currentCreditHoursController),
              SizedBox(height: 10),
              _buildInputRow("Previous CGPA", previousGpaController),
              SizedBox(height: 10),
              _buildInputRow("Total Credit Hours", totalPreviousCreditHoursController),
              SizedBox(height: 20),
              if (calculatedCgpa != null)
                Text('Your Cgpa is : ${calculatedCgpa!.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF00205C)))
            ],
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Calculate", style: TextStyle(color: Color(0xFF00205C), fontWeight: FontWeight.bold)),
          onPressed: calculateCgpa,
        ),
        CupertinoDialogAction(
          child: Text("Close", style: TextStyle(color: Color(0xFFFF0000))),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Row _buildInputRow(String labelText, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(labelText, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00205C))),
        Container(
          width: 120,
          child: CupertinoTextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            placeholder: "Enter value",
          ),
        ),
      ],
    );
  }
}
