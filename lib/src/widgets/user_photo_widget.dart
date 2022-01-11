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
      {Key? key,
      this.showActivityStatus = true,
      this.circleCrop = true,
      this.constraints,
      this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: StreamBuilder<DatabaseEvent>(
        stream: GetIt.I<FirebaseDatabase>()
            .ref()
            .child('Users/${user.uid}/lastSeen')
            .onValue,
        builder: (context, activity) {
          if (!user.hasPhoto)
            return Stack(
              children: [
                Positioned.fill(
                  child: Icon(Icons.account_circle,
                      size: MediaQuery.of(context).size.height / 16.56),
                ),
                if (showActivityStatus &&
                    activity.data?.snapshot.value == 'Active')
                  Align(
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
                  ),
              ],
            );

          return Stack(
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
              if (showActivityStatus &&
                  activity.data?.snapshot.value == 'Active')
                Align(
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
                ),
            ],
          );
        },
      ),
    );
  }
}
