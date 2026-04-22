import 'package:flutter/material.dart';
import 'package:neoncave_arena/theme/colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;
  bool currentValue = false;

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60));

    _circleAnimation = AlignmentTween(
            begin: currentValue ? Alignment.centerRight : Alignment.centerLeft,
            end: currentValue ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            setState(() {
              currentValue = !currentValue;
            });
            widget.onChanged(currentValue);
          },
          child: Container(
            width: 40.0,
            height: 22.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: _circleAnimation!.value == Alignment.centerLeft
                  ? AppColor.primaryColor
                  : AppColor.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment: currentValue
                    ? ((Directionality.of(context) == TextDirection.rtl)
                        ? Alignment.centerRight
                        : Alignment.centerLeft)
                    : ((Directionality.of(context) == TextDirection.rtl)
                        ? Alignment.centerLeft
                        : Alignment.centerRight),
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
