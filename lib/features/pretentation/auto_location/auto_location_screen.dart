import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/load_status.dart';
import 'auto_location_cubit.dart';

class AutoLocationScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AutoLocationCubit, AutoLocationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Tìm tên thành phố",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<AutoLocationCubit>().getAutoLoacation(value);
                  },
                ),
                const SizedBox(height: 16),
                if (state.status == LoadStatus.Loading)
                  Image.asset(
                    'assets/gif/loading.gif',
                    height: 50,
                    width: 50,
                  )
                else if (state.status == LoadStatus.Error)
                  const Center(child: Text('Đã xảy ra lỗi, vui lòng thử lại!'))
                else if (state.status == LoadStatus.Done && state.suggestions.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        return ListTile(
                          title: Text(suggestion.region),
                          onTap: () {
                            _controller.text = suggestion.name;
/* context.read<HomeWeatherCubit>().fetchWeather(suggestion.name);*/
                            FocusScope.of(context)
                                .unfocus();
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  )
                else
                  const Center(child: Text('Không có kết quả.')),
              ],
            ),
          );
        },
      ),
    );
  }
}