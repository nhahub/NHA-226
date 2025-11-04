import 'package:lingo_sign/features/friend_account/Freind.dart';
import 'package:lingo_sign/features/friend_account/friend_data/friend_data_source.dart';

class FriendRepository {
  final FriendDataSource remoteDataSource;

  FriendRepository(this.remoteDataSource);

  Stream<Friend> getFriendByUid(String uid) {
    return remoteDataSource.getFriendByUid(uid);
  }

  Future<void> addToFavourite(String uid) {
    return remoteDataSource.updateFavourite(uid, true);
  }

  Future<void> removeFromFavourite(String uid) {
    return remoteDataSource.updateFavourite(uid, false);
  }

  Future<void> unfriend(String uid) {
    return remoteDataSource.deleteFriend(uid);
  }
}
