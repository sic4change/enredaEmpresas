import 'package:enreda_empresas/app/home/applicants/applicants_list_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/custom_text.dart';
import '../../models/company.dart';
import '../../models/jobOfferApplication.dart';
import '../../models/resource.dart';
import '../../services/database.dart';
import '../../utils/adaptative.dart';
import '../../values/strings.dart';
import '../../values/values.dart';
import 'package:enreda_empresas/app/home/resources/global.dart' as globals;

class HeaderJobOffer extends StatelessWidget {
  const HeaderJobOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildHeader(context, globals.currentResource!);
  }

  Widget _buildHeader(BuildContext context, Resource resource) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double fontSize = responsiveSize(context, 12, 14, md: 13);
    final database = Provider.of<Database>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.mainPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextMediumBold(text: '${resource.title}'),
          Container(
            height: 30,
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: StreamBuilder<Company>(
                        stream: database.companyStreamById(resource.organizer),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var company = snapshot.data!;
                            String companyName = '${company.name}';
                            return Text(
                              '$companyName  |  ',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.greyTxtAlt,
                                height: 1.2,
                                fontSize: fontSize,
                              ),
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        }),
                  ),
                  WidgetSpan(
                    child: StreamBuilder<List<JobOfferApplication>>(
                      stream: database.applicantsStreamByJobOffer(
                          resource.jobOfferId!, null),
                      builder: (context, snapshot) {
                        int count = 0;
                        if (snapshot.hasData) {
                          count = snapshot.data!.length;
                        }
                        return Text(
                          '$count ', // The number of applications or 0
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.greyTxtAlt,
                            height: 1.5,
                            fontSize: fontSize,
                          ),
                        );
                      },
                    ),
                  ),
                  TextSpan(
                    text: StringConst.JOB_OFFER_REGISTERED_TITLE,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.greyTxtAlt,
                      height: 1.5,
                      fontSize: fontSize,
                    ),
                  ),
                  TextSpan(
                    text: StringConst.JOB_OFFER,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.greyTxtAlt,
                      height: 1.5,
                      fontSize: fontSize,
                      decoration: TextDecoration.underline,  // Add underline decoration
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        ApplicantsListPage.selectedIndex.value = 4;
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
