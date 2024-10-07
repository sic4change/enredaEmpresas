
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/province.dart';
import '../models/userEnreda.dart';
import '../services/database.dart';
import '../utils/responsive.dart';
import 'custom_text.dart';

Widget MyCustomLocation(BuildContext context, UserEnreda? user) {
  final database = Provider.of<Database>(context, listen: false);
  Country? myCountry;
  Province? myProvince;
  City? myCity;
  String? city;
  String? province;
  String? country;

  return StreamBuilder<Country>(
      stream: database.countryStream(user?.address?.country),
      builder: (context, snapshot) {
        myCountry = snapshot.data;
        return StreamBuilder<Province>(
            stream: database.provinceStream(user?.address?.province),
            builder: (context, snapshot) {
              myProvince = snapshot.data;

              return StreamBuilder<City>(
                  stream: database.cityStream(user?.address?.city),
                  builder: (context, snapshot) {
                    myCity = snapshot.data;
                    city = myCity?.name ?? '';
                    province = myProvince?.name ?? '';
                    country = myCountry?.name ?? '';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black.withOpacity(0.7),
                          size: Responsive.isDesktop(context) && !Responsive.isDesktopS(context)? 22: 14,
                        ),
                        const SpaceW4(),
                        /*Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextSmall(text: city ?? ''),
                              CustomTextSmall(text: province ?? ''),
                              CustomTextSmall(text: country ?? ''),
                            ],
                          ),*/
                        CustomTextSmall(text: city ?? ''),
                      ],
                    );
                  });
            });
      });
}