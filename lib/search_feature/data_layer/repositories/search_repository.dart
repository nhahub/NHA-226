import 'package:lingo_sign/search_feature/data_layer/data_source/local_data_source.dart';
import 'package:lingo_sign/search_feature/data_layer/data_source/remote_data_source.dart';
import 'package:lingo_sign/search_feature/data_layer/model/user_model.dart';

class SearchRepository {
  final RemoteDataSource remote;
  final LocalDataSource local;

  SearchRepository(this.remote, this.local);

  Future<List<UserModel>> search(String query) => remote.searchUsers(query);
  Future<List<UserModel>> getRecent() => local.getUsers();
  Future<void> saveUser(UserModel user) => local.saveUser(user);
}
