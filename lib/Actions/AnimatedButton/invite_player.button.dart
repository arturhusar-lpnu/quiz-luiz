import "package:flutter/material.dart";

class InviteButton extends StatefulWidget {
  final double width;
  final double height;
  final double fontSize;
  final Color color;
  final String userId;
  final String opponentId;
  final VoidCallback onInviteTapped;
  final bool isSelected;
  void invite() {
    print("$opponentId is invited to game with $userId(You)");
  }

  const InviteButton({
    super.key,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.color,
    required this.userId,
    required this.opponentId,
    required this.onInviteTapped,
    required this.isSelected,
  });

  @override
  InviteButtonState createState() => InviteButtonState();
}

class InviteButtonState extends State<InviteButton> {
  void _handlePress() {
    widget.onInviteTapped();
  }

  @override
  void initState() {
    super.initState();
  }

  Color _getLighterColor(Color color, double amount) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor.withLightness((hslColor.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = widget.isSelected
        ? _getLighterColor(widget.color, 0.1)
        : Colors.transparent;
    final String buttonText = widget.isSelected
        ? "Invited"
        : "Invite";

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: widget.color, width: 2.0),
          ),
          minimumSize: Size(widget.width, widget.height),
        ),
        onPressed: _handlePress,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
