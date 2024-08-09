import 'dart:html';

import 'package:enreda_empresas/app/home/participants/participant_detail/documentation/popup_menu_actions.dart';
import 'package:enreda_empresas/app/models/personalDocumentType.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/services/database.dart';
import '../../../../models/documentCategory.dart';
import '../../../../models/documentationParticipant.dart';
import '../../../../utils/responsive.dart';
import '../../../../values/values.dart';
import '../../../resources/list_item_builder.dart';
import 'add_documents_form.dart';
import 'custom_menu_entry.dart';
import 'menu_item.dart';
import 'menu_items.dart';

class DocumentCategoryTile extends StatefulWidget {
  const DocumentCategoryTile({
    Key? key,
    required this.documentCategory,
    required this.participantUser,
  }) : super(key: key);
  final DocumentCategory documentCategory;
  final UserEnreda participantUser;

  @override
  State<DocumentCategoryTile> createState() => _DocumentCategoryTileState();
}

class _DocumentCategoryTileState extends State<DocumentCategoryTile> {

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<PersonalDocumentType>>(
              stream: database.documentSubCategoriesByCategoryStream(widget.documentCategory.documentCategoryId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                if (snapshot.hasData){
                  List<PersonalDocumentType> documentSubCategories =  snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: documentSubCategories.map((documentSubCategory) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: Responsive.isMobile(context) ? const EdgeInsets.only(left: 20.0, right: 31.0) :
                            const EdgeInsets.symmetric(horizontal: 55.0, vertical: 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomTextSmall(text: documentSubCategory.title),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context){
                                              return AddDocumentsForm(
                                                participantDocument: documentSubCategory,
                                                participantUser: widget.participantUser,);
                                            }
                                        );
                                      },
                                      child: Image.asset(
                                        ImagePath.ICON_PLUS,
                                        height: Responsive.isMobile(context) ? 25 : 30,)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                documentationParticipantBySubCategory(documentSubCategory, widget.participantUser),
                              ],
                            ),
                          ),
                          Divider(thickness: 1, color: AppColors.greyDropMenuBorder,),
                        ],
                      );
                    }).toList(),
                  );
                }
                return Container();
              }
          ),
        ],
      ),
    );
  }

  Widget documentationParticipantBySubCategory(PersonalDocumentType documentSubCategory, UserEnreda participantUser) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<DocumentationParticipant>>(
      stream: database.documentationParticipantBySubCategoryStream(documentSubCategory, participantUser),
      builder: (context, documentationParticipantSnapshot) {
        if (!documentationParticipantSnapshot.hasData) return Container();
        if(documentationParticipantSnapshot.hasData) {
          return ListItemBuilder<DocumentationParticipant>(
            emptyTitle: 'Sin documentos',
            emptyMessage: 'Aún no se ha agreado ningún documento',
            snapshot: documentationParticipantSnapshot,
            itemBuilder: (context, documentParticipant) {
              return Container(
                height: Responsive.isMobile(context) ? 25 : 30,
                child: Row(
                  children: [
                    Icon(Icons.file_copy_outlined, color: AppColors.greyAlt, size: 20.0,),
                    SizedBox(width: 5),
                    CustomTextSmall(text: documentParticipant.name),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      width: Responsive.isMobile(context) ? 25 : 30,
                      child: PopupMenuButton<MenuItem>(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        surfaceTintColor: Colors.white,
                        iconColor: AppColors.primary900,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_horiz, color: AppColors.primary900,),
                        offset: Offset.fromDirection(0.6, 100),
                        iconSize: 30,
                        tooltip: documentParticipant.name,
                        onSelected: (item) => onSelected(context, item, documentSubCategory, participantUser, documentParticipant),
                        itemBuilder: (context) => [
                          CustomPopupMenuEntry(child: null, documentationParticipant: documentParticipant),
                          ...MenuItems.getItemOpen(context).map(buildItem).toList(),
                          ...MenuItems.getItemDownload(context).map(buildItem).toList(),
                          ...MenuItems.getItemEdit(context).map(buildItem).toList(),
                          ...MenuItems.getItemDelete(context).map(buildItemRed).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        };
        return Container(
          child: Text('no data'),
        );
      },
    );
  }


}