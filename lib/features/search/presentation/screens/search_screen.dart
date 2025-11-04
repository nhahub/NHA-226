import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/widget/custom_app_bar.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_event.dart';
import 'package:lingo_sign/features/search/presentation/bloc/search_state.dart';
import 'package:lingo_sign/features/search/presentation/widgets/custom_search_user.dart';
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
    bloc.add(LoadRecentUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: 'Search'),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12.h),
              ),
              margin: EdgeInsets.all(0),
              child: TextField(
                onChanged: (value) => bloc.add(SearchTextChangedEvent(value)),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(12),

                  hintText: 'Search for...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColor.darkGray,
                    size: 24.h,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
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
                  Checkbox(
                    value: showAll,
                    onChanged: (value) {
                      setState(() {
                        showAll = !showAll;
                        bloc.add(LoadRecentUsersEvent(showAll: showAll));
                      });
                    },
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
                      itemCount: state.users.length,
                      itemBuilder: (context, i) {
                        final user = state.users[i];
                        return GestureDetector(
                          child: CustomSearchUser(user: user),
                          onTap: () {
                            bloc.add(UserProfileClickedEvent(user));
                            // Navigator.pushNamed(
                            //   context,
                            //   '/profile',
                            //   arguments: user,
                            // );
                          },
                        );
                      },
                    );
                  } else if (state is SearchEmptyState) {
                    return Center(child: Text(state.message));
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
