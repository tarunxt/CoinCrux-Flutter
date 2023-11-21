import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/auth/userModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
import '../../../dashboard/home/model/category_model.dart';

class PerWidget extends StatefulWidget {
  bool isAsset;
  final CategoryModel model;
  int index;
  PerWidget({
    super.key,
    required this.index,
    required this.model,
    required this.isAsset,
  });

  @override
  State<PerWidget> createState() => _PerWidgetState();
}

class _PerWidgetState extends State<PerWidget> {
  // int currentSelected=0;
  @override
  Widget build(BuildContext context) {
    AuthProviderApp auth = Provider.of(context, listen: false);
    return InkWell(
      onTap: widget.isAsset
          ? null
          : () {
              Topics topics = Topics(newsType: 0, name: widget.model.coinName);
              if (auth.selectedItems.contains(topics)) {
                auth.selectedItems.remove(topics);
              } else {
                auth.selectedItems.add(topics);
              }
              setState(() {});
            },
      child: Container(
        padding: EdgeInsets.all(FetchPixels.getPixelHeight(5)),
        height: FetchPixels.getPixelHeight(100),
        width: FetchPixels.getPixelWidth(100),
        decoration: BoxDecoration(
          border: Border.all(color: R.colors.borderColor, width: 1),
          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(5)),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          widget.isAsset
              ? SizedBox()
              : Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: FetchPixels.getPixelHeight(20),
                    width: FetchPixels.getPixelWidth(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            FetchPixels.getPixelHeight(5)),
                        color: auth.selectedItems.contains(Topics(
                                name: widget.model.coinName!, newsType: 0))
                            ? R.colors.theme
                            : R.colors.transparent,
                        border:
                            Border.all(color: R.colors.borderColor, width: 1)),
                    child: Center(
                        child: Icon(
                      Icons.check,
                      size: FetchPixels.getPixelHeight(15),
                      color: auth.selectedItems.contains(
                              Topics(name: widget.model.coinName!, newsType: 0))
                          ? R.colors.whiteColor
                          : R.colors.transparent,
                    )),
                  ),
                ),
          getAssetImage(
            widget.model.coinLogo!,
            height: FetchPixels.getPixelHeight(35),
            width: FetchPixels.getPixelWidth(35),
          ),
          Text(
            widget.model.coinName!,
            style: R.textStyle.regularLato().copyWith(
                fontSize: FetchPixels.getPixelHeight(14),
                color: R.colors.blackColor),
          )
        ]),
      ),
    );
  }
}
