import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/data/home_repository_impl.dart';
import 'package:lingo_sign/features/home/presentation/bloc/requests/requests_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/request_friend.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Requests",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                BlocProvider(
                  create: (context) =>
                      RequestsBloc(HomeRepositoryImpl())
                        ..add(GetAllRequestsEvent()),
                  child: BlocBuilder<RequestsBloc, RequestsState>(
                    builder: (context, state) {
                      if (state is RequestsLoaded) {
                        final requests = state.requests;
                        if (requests.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: requests.length,
                            itemBuilder: (context, index) {
                              return RequestFriend(
                                request: requests[index],
                                onIgnore: () =>
                                    context.read<RequestsBloc>().add(
                                      RejectRequestEvent(requests[index].uid),
                                    ),
                                onAccept: () =>
                                    context.read<RequestsBloc>().add(
                                      AcceptRequestEvent(requests[index].uid),
                                    ),
                              );
                            },
                          );
                        }
                        return Center(
                          child: Text('There are not any requestes yet'),
                        );
                      }
                      if (state is RequestsLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is RequestsError) {
                        return Center(child: Text(state.message));
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
