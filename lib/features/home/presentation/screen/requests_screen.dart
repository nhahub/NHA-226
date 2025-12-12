import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/home/presentation/bloc/requests/requests_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/request_friend.dart';
import 'package:lingo_sign/features/home/presentation/widget/request_friend_shimmer.dart';

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
                BlocBuilder<RequestsBloc, RequestsState>(
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
                      return Padding(
                        padding: EdgeInsets.only(top: context.height * 0.11),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                child: SvgPicture.asset(
                                  'assets/images/rafiki.svg',
                                ),
                              ),
                              SizedBox(height: context.height * 0.03),
                              Text(
                                'No friend requests',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppColor.main,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is RequestsLoading) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return RequestFriendShimmer();
                        },
                      );
                    }
                    if (state is RequestsError) {
                      return Center(child: Text(state.message));
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
