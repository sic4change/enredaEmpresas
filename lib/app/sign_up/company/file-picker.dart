import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import '../../models/file_data.dart';

class FilePickerForm extends StatefulWidget {
  final BuildContext context;
  final List<FileData> filesList;
  final Future<void> Function() onTap;
  final String label;
  final void Function(FileData) onDeleteDocument;

  FilePickerForm({
    required this.context,
    required this.filesList,
    required this.onTap,
    required this.label,
    required this.onDeleteDocument,
  });

  @override
  _FilePickerFormState createState() => _FilePickerFormState();
}

class _FilePickerFormState extends State<FilePickerForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextBold(title: widget.label),
            SizedBox(height: 4,),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8),),
                color: AppColors.white,
                border: Border.all(color: AppColors.greyUltraLight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.UPLOAD, height: 25, width: 25,),
                  SizedBox(height: 10,),
                  CustomTextSmall(text: StringConst.ADD_FILE, color: AppColors.blue050,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

