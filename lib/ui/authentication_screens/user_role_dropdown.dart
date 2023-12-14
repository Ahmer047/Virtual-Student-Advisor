import 'package:flutter/material.dart';

class UserRoleDropdown extends StatefulWidget {
  final String selectedUserRole;
  final Function(String) onUserRoleChanged;

  UserRoleDropdown({
    required this.selectedUserRole,
    required this.onUserRoleChanged,
  });

  @override
  _UserRoleDropdownState createState() => _UserRoleDropdownState();
}

class _UserRoleDropdownState extends State<UserRoleDropdown> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: DropdownButton<String>(
          value: widget.selectedUserRole,
          onChanged: (String? newValue) {
            setState(() {
              widget.onUserRoleChanged(newValue!);
            });
          },
          items: <String>['Student', 'Admin'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: Color(0xFF00205C),
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          underline: SizedBox(), // Remove the default underline
          icon: Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF00205C),
          ),
        ),
      ),
    );
  }
}
