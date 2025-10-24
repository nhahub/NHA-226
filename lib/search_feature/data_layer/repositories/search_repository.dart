import 'package:lingo_sign/search_feature/data_layer/data_source/remote_data_source.dart';
import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';

class SearchRepository {
  final RemoteDataSource remote;
  SearchRepository(this.remote);

  Future<List<UserModel>> search(String query) => remote.searchUsers(query);
  Future<List<UserModel>> getRecent() => remote.getUsers();
  Future<void> saveUser(UserModel user) => remote.saveUser(user);
}
