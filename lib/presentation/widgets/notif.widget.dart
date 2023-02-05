import 'package:flutter/material.dart';

import '../../infrastructure/theme/app_colors.dart';

class NotifWidget extends StatelessWidget {
  final String text;

  const NotifWidget({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.presensiAccent[200],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  height: 150 / 100,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'inter',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF252525),
                padding: const EdgeInsets.only(
                    left: 14, top: 7, bottom: 7, right: 8),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
              child: Row(
                children: const [
                  Text('More...'),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 14,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
