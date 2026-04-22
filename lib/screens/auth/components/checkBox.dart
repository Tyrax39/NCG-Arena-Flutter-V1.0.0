
import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.value;
  }

  void _toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
      widget.onChanged(isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isChecked ? widget.activeColor : Colors.transparent,
          border: Border.all(
            color: isChecked ? widget.activeColor : AppColor.primaryColor,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        width: 17.0,
        height: 17.0,
        child: isChecked
            ? Icon(
                Icons.check,
                size: 15.0,
                color: widget.checkColor,
              )
            : null,
      ),
    );
  }
}
