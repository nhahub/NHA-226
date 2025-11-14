import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/data/home_repository_impl.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';
import 'package:lingo_sign/features/home/presentation/bloc/requests/requests_bloc.dart';
import 'package:lingo_sign/features/home/presentation/widget/request_friend.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({super.key});

  final List<Request> requests = [
    Request(
      uid: '1',
      name: 'Ahmed H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      createdAt: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    Request(
      uid: '2',
      name: 'Ahmed H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Request(
      uid: '3',
      name: 'Youssef A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Request(
      uid: '4',
      name: 'Omar S',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Request(
      uid: '5',
      name: 'Ahmed H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      createdAt: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    Request(
      uid: '6',
      name: 'Ahmed H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Request(
      uid: '7',
      name: 'Youssef A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      createdAt: DateTime.now().subtract(Duration(days: 1, hours: 3)),
    ),
    Request(
      uid: '8',
      name: 'Omar S',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 4)),
    ),
    Request(
      uid: '9',
      name: 'Ahmed H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      createdAt: DateTime.now().subtract(Duration(minutes: 15)),
    ),
    Request(
      uid: '10',
      name: 'Ahmed H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      createdAt: DateTime.now().subtract(Duration(hours: 3)),
    ),
    Request(
      uid: '11',
      name: 'Youssef A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      createdAt: DateTime.now().subtract(Duration(days: 1, minutes: 5)),
    ),
    Request(
      uid: '12',
      name: 'Omar S',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      createdAt: DateTime.now().subtract(Duration(days: 2, minutes: 20)),
    ),
  ];

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
                  create: (context) => RequestsBloc(HomeRepositoryImpl()),
                  child: BlocBuilder<RequestsBloc, RequestsState>(
                    builder: (context, state) {
                      if (state is RequestsLoaded) {
                        if (state.requests.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: requests.length,
                            itemBuilder: (context, index) {
                              return RequestFriend(request: requests[index]);
                            },
                          );
                        }
                        return SizedBox.shrink();
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
