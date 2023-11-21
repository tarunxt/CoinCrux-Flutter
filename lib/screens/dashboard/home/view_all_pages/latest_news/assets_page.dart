import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../base/resizer/fetch_pixels.dart';
import '../../../../auth/personalise_feed/widget/personalsei_widget.dart';
import '../../model/category_model.dart';

class AssetsView extends StatelessWidget {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(
      builder: (context, auth, child) {
        return ListView(children: [
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: FetchPixels.getPixelHeight(10),
            spacing: FetchPixels.getPixelWidth(10),
            children: List.generate(auth.categoriesList.length, (index) {
              CategoryModel model = auth.categoriesList[index];
              return PerWidget(
                index: index,
                model: model,
                isAsset: true,
              );
            }),
          ),
        ]);
      },
    );
  }
}
