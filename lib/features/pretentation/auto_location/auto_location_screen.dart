import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/load_status.dart';
import 'auto_location_cubit.dart';

class AutoLocationScreen extends StatefulWidget {
  const AutoLocationScreen({super.key});

  @override
  AutoLocationScreenState createState() => AutoLocationScreenState();
}

class AutoLocationScreenState extends State<AutoLocationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AutoLocationCubit, AutoLocationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
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
                          context
                              .read<AutoLocationCubit>()
                              .getAutoLocation(value);
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _controller.clear();
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ))
                  ],
                ),
                const SizedBox(height: 16),
                if (state.status == LoadStatus.Loading)
                  Center(
                    child: Image.asset(
                      'assets/gif/loading-load.gif',
                      height: 30,
                      width: 30,
                    ),
                  )
                else if (state.status == LoadStatus.Error)
                  const Center(child: Text('Đã xảy ra lỗi, vui lòng thử lại!'))
                else if (state.status == LoadStatus.Done &&
                    state.suggestions.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = state.suggestions[index];
                        return ListTile(
                          title: Text(suggestion.region),
                          onTap: () async {
                            await context.read<AutoLocationCubit>().fetchWeather(suggestion.latitude, suggestion.longitude);
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
