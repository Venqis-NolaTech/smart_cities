import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/category_item.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/header_report.dart';


class ReportType extends StatelessWidget {
  final CreateReportProvider provider;

  ReportType({Key key, this.provider}) : super(key: key);

  ScrollController _scrollController;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderReport( numberStep: S.of(context).two, tittle: S.of(context).selectTypeReport),

        Expanded(
          child:  _builList(provider.allCategory)
        )
      ],
    );
  }

  Widget _builList(List<CatalogItem> categorys) {

    return ListView.builder(
      itemCount: categorys.length,
      controller: _scrollController,
      itemBuilder: (context, index) => CategoryItem(
        categoria: categorys[index],
        selected: provider.selectedCategory== null ? false : provider.selectedCategory.key==categorys[index].key,
        onTap: (valueCategory){
          provider.selectedCategory=valueCategory;
        },
      ),
    );

  }



}
