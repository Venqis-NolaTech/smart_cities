import 'package:flutter/material.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';


class CategoryItem extends StatelessWidget {
  final CatalogItem categoria;
  final bool selected;
  final Function(CatalogItem) onTap;

  CategoryItem({Key key, this.categoria, this.selected, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(categoria),
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric( vertical: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    categoria.value,
                    style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
                  )),
                  selected ? Icon(Icons.check, color: AppColors.blueLight,) : Container()
                ],
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
