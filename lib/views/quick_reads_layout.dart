import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:news_today/helpers/shared.dart';
import 'package:news_today/shared_widgets.dart';
import 'package:news_today/themes/app_colors.dart';
import 'package:news_today/themes/app_text_styles.dart';

class QuickReadsLayout extends StatelessWidget {
  const QuickReadsLayout(
      {
      // required this.sources,
      required this.appTextStyles,
      required this.appColors,
      super.key});
  // final List<SourceEntity> sources;
  final AppTextStyles appTextStyles;
  final AppColors appColors;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewsCubit, NewsState, List<SourceEntity>>(
      selector: (state) {
        return state.sources!;
      },
      builder: (context, sources) {
        return Container(
          height: 90.0.sp,
          // padding: EdgeInsets.only(left: spPadding1),
          constraints: const BoxConstraints(maxHeight: 200.0),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sources.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: padding3),
            itemBuilder: (context, index) {
              // if(kDebugMode)print(sources[index].favIconURL!);
              // if(kDebugMode)print('in source: ${sources[index].isImageFetchAvailable}');
              return Container(
                width: 70.0.sp,
                margin: EdgeInsets.only(
                    left: index == 0 ? spPadding1 : 0.0,
                    right: index == sources.length - 1 ? spPadding1 : 0.0),
                constraints: const BoxConstraints(
                  maxWidth: 140.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70.0.sp,
                      width: 70.0.sp,
                      // padding: const EdgeInsets.all(padding2),
                      constraints: const BoxConstraints(
                        maxHeight: 140.0,
                        maxWidth: 140.0,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.seconderColor),
                      child: sources[index].isImageFetchAvailable
                          ? CachedNetworkImage(
                              // fit: BoxFit.contain,
                              // imageUrl: 'https://copilot.microsoft.com/favicon.ico',
                              imageUrl: sources[index].favIconURL! != ''
                                  ? sources[index].favIconURL!
                                  : 'https://www.google.com/favicon.ico',
                              placeholder: (context, url) =>
                                  appImagePlaceholder(appColors.seconderColor,
                                      isCircle: true),
                              errorWidget: (context, url, error) {
                                if (kDebugMode) {
                                  print(
                                      'in error widget ${sources[index].id}: ${sources[index].isImageFetchAvailable}');
                                }
                                context
                                    .read<NewsCubit>()
                                    .onSourceImageError(sources[index].id!);
                                return appImagePlaceholder(
                                    appColors.seconderColor,
                                    isCircle: true);
                              },
                              errorListener: (value) {
                                debugPrint(
                                    'in error listener ${value.toString()}');
                              },
                              // cacheManager: ,
                            )
                          : appImagePlaceholder(appColors.seconderColor,
                              isCircle: true),
                    ),
                    // Text(sources[index].name!,
                    //     textAlign: TextAlign.center,
                    //     maxLines: 1,
                    //     style: appTextStyles.bodySmall),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
