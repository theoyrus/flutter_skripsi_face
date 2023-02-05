import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  final String username;
  final String? noinduk;
  final String? divisi;

  const ProfileCardWidget({
    required this.username,
    this.noinduk,
    this.divisi,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      height: 76,
      decoration: BoxDecoration(
        // color: Color(0xFF191919),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 48,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              margin: const EdgeInsets.only(right: 20),
              child: Image.asset('assets/images/face-icon.png'),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '$noinduk - $divisi',
                    style: TextStyle(
                      // color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
