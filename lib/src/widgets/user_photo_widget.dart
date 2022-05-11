import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserPhotoWidget extends StatelessWidget {
  final UserBase user;
  final bool showActivityStatus;
  final bool circleCrop;
  final BoxConstraints? constraints;
  final Object? heroTag;

  const UserPhotoWidget(this.user,
      {super.key,
      this.showActivityStatus = true,
      this.circleCrop = true,
      this.constraints,
      this.heroTag});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: PhotoObjectWidget(
              user,
              circleCrop: circleCrop,
              constraints: constraints,
              heroTag: heroTag,
              key: key,
            ),
          ),
          if (showActivityStatus)
            _OnlineDot(
              uid: user.uid,
            ),
        ],
      ),
    );
  }
}

class _OnlineDot extends StatelessWidget {
  final String uid;
  const _OnlineDot({
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: GetIt.I<FirebaseDatabase>()
          .ref()
          .child('Users/$uid/lastSeen')
          .onValue,
      builder: (context, activity) {
        if (activity.data?.snapshot.value == 'Active')
          return Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
                color: Colors.greenAccent,
              ),
            ),
          );

        return const SizedBox.shrink();
      },
    );
  }
}
