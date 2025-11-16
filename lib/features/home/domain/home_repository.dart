import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';
import 'package:lingo_sign/features/home/domain/entities/user_app.dart';

abstract class HomeRepository {
  Future<UserApp> getUserInfo();

  Future<UserApp> getUserInfoById(String id);

  Future<List<Friend>> getFriends();

  Future<List<Friend>> getFavourites();

  Future<List<Friend>> getLastCalls();

  Future<List<Request>> getRequstes();

  Future<bool> acceptFriendRequest(String friendId);

  Future<bool> rejectFriendRequest(String friendId);
  Future<void> addToFavourite(String friendUid);
  Future<void> removeFromFavourite(String friendUid);
  Future<void> unfriend(String friendUid);
}
