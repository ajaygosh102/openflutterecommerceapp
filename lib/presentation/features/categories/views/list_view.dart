// Category List View
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openflutterecommerce/config/theme.dart';
import 'package:openflutterecommerce/data/fake_repositories/models/category.dart';
import 'package:openflutterecommerce/presentation/features/products/products.dart';
import 'package:openflutterecommerce/presentation/widgets/widgets.dart';
import 'package:openflutterecommerce/presentation/features/wrapper.dart';

import '../categories.dart';
import '../categories_bloc.dart';
import '../categories_event.dart';
import '../categories_state.dart';

class CategoriesListView extends StatefulWidget {
  final Function changeView;

  const CategoriesListView({Key key, this.changeView}) : super(key: key);

  @override
  _CategoriesListViewState createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var widgetWidth = width - AppSizes.sidePadding * 4;
    var _theme = Theme.of(context);
    return BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
      if (state is CategoryErrorState) {
        return Container(
            padding: EdgeInsets.all(AppSizes.sidePadding),
            child: Text('An error occured',
                style: _theme.textTheme.headline3
                    .copyWith(color: _theme.errorColor)));
      }
      return Container();
    }, child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoryListViewState) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
              OpenFlutterButton(
                onPressed: (() => {
                      BlocProvider.of<CategoryBloc>(context)
                          .add(CategoryShowTilesEvent(1)),
                      widget.changeView(changeType: ViewChangeType.Forward)
                    }),
                title: 'VIEW ALL ITEMS',
                width: widgetWidth,
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.sidePadding,
                ),
              ),
              state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: buildCategoryList(state.categories),
                    )
            ],
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    }));
  }

  List<Widget> buildCategoryList(List<Category> categories) {
    var elements = <Widget>[];
    for (var i = 0; i < categories.length; i++) {
      elements.add(
        InkWell(
          onTap: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductsScreen(categoryId: categories[i].id);
                },
              ),
            );
          }),
          child: OpenFlutterCatregoryListElement(category: categories[i]),
        ),
      );
    }
    return elements;
  }
}
