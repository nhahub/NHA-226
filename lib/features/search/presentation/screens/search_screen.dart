import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_card.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_event.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_state.dart';
import 'package:lingo_sign/features/search/presentation/widgets/search_bar.dart';

import '../bloc/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchBloc bloc;
  bool showAll = false;
  @override
  void initState() {
    super.initState();
    bloc = context.read<SearchBloc>();
    bloc.add(LoadRecentFriendsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: 'Search'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            CustomSearchBar(bloc: bloc),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Recently Searched',
                    style: TextStyle(
                      fontSize: 18.h,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      bloc.add(LoadRecentFriendsEvent());
                    },
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        bool showAll = false;
                        if (state is SearchLoadedState) {
                          showAll = state.showAll;
                        }
                        return Text(showAll ? 'Show Less' : 'Show All');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoadedState) {
                    return ListView.builder(
                      itemCount: state.friends.length,
                      itemBuilder: (context, i) {
                        final friend = state.friends[i];
                        return GestureDetector(
                          child: FriendUserCallCard(userFriend: friend),
                        );
                      },
                    );
                  } else if (state is SearchEmptyState) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: context.width / 3),
                          SvgPicture.asset(
                            'assets/images/empty_search_history.svg',
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: AppColor.main,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
