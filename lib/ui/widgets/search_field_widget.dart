import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practicletestone/app/app_colour.dart';

import '../dashboard/dashboard_cubit.dart';
import '../dashboard/dashboard_state.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget({super.key});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DashboardCubit>();
    _controller = TextEditingController(text: cubit.state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();

    return Container(
      decoration: BoxDecoration(
        color: AppColour.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColour.white.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: cubit.searchQueryChanged,
        style: const TextStyle(
          color: AppColour.white,
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(
            color: AppColour.white38,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColour.white70,
            size: 20,
          ),
          suffixIcon: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state.searchQuery.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColour.white70,
                  size: 20,
                ),
                onPressed: () {
                  _controller.clear();
                  cubit.searchQueryChanged('');
                },
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}
