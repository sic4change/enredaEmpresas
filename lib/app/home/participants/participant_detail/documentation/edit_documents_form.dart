import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enreda_empresas/app/home/participants/participant_detail/documentation/default_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/alert_dialog.dart';
import '../../../../common_widgets/custom_date_picker_open.dart';
import '../../../../common_widgets/custom_text.dart';
import '../../../../common_widgets/custom_text_form_field_title.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../models/file_data.dart';
import '../../../../models/documentationParticipant.dart';
import '../../../../models/userEnreda.dart';
import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../../../utils/adaptative.dart';
import '../../../../utils/responsive.dart';
import '../../../../values/strings.dart';
import '../../../../values/values.dart';
import 'files_picker.dart';

class EditDocumentsForm extends StatefulWidget {
  EditDocumentsForm({Key? key,
    required this.documentationParticipant,
    required this.participantUser}) : super(key: key);

  final DocumentationParticipant documentationParticipant;
  final UserEnreda participantUser;

  @override
  _EditDocumentsFormState createState() => _EditDocumentsFormState();
}

class _EditDocumentsFormState extends State<EditDocumentsForm> {
  late DocumentationParticipant documentationParticipant;
  String? _documentationParticipantId;
  List<FileData> filesList = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerDateInput = TextEditingController();
  late String _documentName;
  late String _formattedBDate;
  DateTime _creationDate = new DateTime.now();
  DateTime? _renovationDate;
  DocumentationParticipant? documentationParticipantFromStorage;
  bool isFileRemoved = false;

  Future<void> loadDocumentationParticipantData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    DocumentationParticipant documentationParticipant = widget.documentationParticipant;
    _documentationParticipantId = documentationParticipant.documentationParticipantId;
    _documentName = documentationParticipant.name;
    _creationDate = documentationParticipant.createDate;
    _renovationDate = documentationParticipant.renovationDate;

    documentationParticipantFromStorage = await database.documentationParticipantStream(widget.documentationParticipant.documentationParticipantId!).first;

    var file = await DefaultCacheManager().getSingleFile(documentationParticipant.urlDocument!);
    final data = file.readAsBytesSync();
    setState(() {
      filesList.add(FileData(documentationParticipant.nameDocument!, data, file));
    });

  }

  @override
  void initState() {
    loadDocumentationParticipantData(context);
    super.initState();
  }

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          filesList.add(FileData(
              result.files.first.name, result.files.first.bytes, null));
        } else {
          filesList.add(FileData(
              result.files.first.name, null, File(result.files.single.path!)));
        }
      });
    }
  }

  void deleteFile(FileData file) {
    setState(() {
      filesList.removeWhere((f) => f == file);
      isFileRemoved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double fontSizeButton = responsiveSize(context, 12, 15, md: 13);
    return AlertDialog(
      content: Container(
        width: 500,
        height: Responsive.isMobile(context) ? MediaQuery.of(context).size.height : 560,
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomTextBoldCenter(
                title: StringConst.EDIT_DOCUMENT_TITLE, color: AppColors.primary900,),
              CustomTextBoldCenter(
                title: '${widget.documentationParticipant.name}', color: AppColors.primary900,),
              SizedBox(height: 20,),
              filesList.length == 0 ? FilesPicker(
                context: context,
                filesList: filesList,
                onTap: () async => pickFiles(),
                onDeleteDocument: deleteFile,
              ) : Container(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: filesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filesList[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteFile(filesList[index]),
                    ),
                  );
                },
              ),
              SizedBox(height: 20,),
              CustomTextFormFieldTitle(
                labelText: StringConst.DOCUMENT_NAME,
                initialValue: _documentName,
                validator: (value) =>
                value!.isNotEmpty ? null : StringConst.FORM_GENERIC_ERROR,
                onSaved: (value) => _documentName = value!,
              ),
              SizedBox(height: 20,),
              CustomDatePickerTitleOpen(
                labelText: StringConst.CREATION_DOCUMENT,
                initialValue: _creationDate,
                onChanged: (value){
                  _formattedBDate = DateFormat('dd-MM-yyyy').format(value!);
                  setState(() {
                    textEditingControllerDateInput.text = _formattedBDate; //set output date to TextField value.
                    _creationDate = value;
                  });
                },
                validator: (value) => value != null ? null : StringConst.FORM_GENERIC_ERROR,
              ),
              SizedBox(height: 20,),
              CustomDatePickerTitleOpen(
                labelText: StringConst.RENOVATION_DOCUMENT,
                initialValue: _renovationDate,
                onChanged: (value){
                  _formattedBDate = DateFormat('dd-MM-yyyy').format(value!);
                  setState(() {
                    textEditingControllerDateInput.text = _formattedBDate; //set output date to TextField value.
                    _renovationDate = value;
                  });
                },
              ),
              SizedBox(height: 20,),
              Flex(
                direction: Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () => Navigator.of(context).pop((false)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(StringConst.CANCEL,
                            style: textTheme.bodySmall?.copyWith(
                                color: AppColors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                fontSize: fontSizeButton)),
                      )),
                  SizedBox(width: 20,),
                  SizedBox(height: 20,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () => _submit(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(StringConst.EDIT_DOC,
                            style: textTheme.bodySmall?.copyWith(
                                color: AppColors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                fontSize: fontSizeButton)),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateAndSaveForm() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (filesList.length == 0) {
      await showAlertDialog(context,
          title: StringConst.FORM_MISSING_DOCUMENT_TITLE,
          content: StringConst.FORM_MISSING_DOCUMENT,
          defaultActionText: StringConst.CLOSE);
    }
    if (_validateAndSaveForm() == false) {
      await showAlertDialog(context,
          title: StringConst.FORM_COMPANY_ERROR,
          content: StringConst.FORM_COMPANY_CHECK,
          defaultActionText: StringConst.CLOSE);
    }
    if (_validateAndSaveForm() && filesList.length > 0) {
      _formKey.currentState!.save();
      final auth = Provider.of<AuthBase>(context, listen: false);
      DocumentationParticipant document = DocumentationParticipant(
        userId: widget.participantUser.userId!,
        name: _documentName,
        createDate: _creationDate,
        renovationDate: _renovationDate,
        documentationParticipantId: _documentationParticipantId,
        documentCategoryId: widget.documentationParticipant.documentCategoryId,
        documentSubCategoryId: widget.documentationParticipant.documentSubCategoryId,
        createdBy: auth.currentUser!.uid,
      );
      try {
        final database = Provider.of<Database>(context, listen: false);
        if (isFileRemoved = true) {
          filesList.forEach((file) async {
            await database.editFileDocumentationParticipant(widget.participantUser.userId!, file.name, file.data!, document);
          });
        }
        await database.updateDocumentationParticipant(document);
        await showAlertDialog(
          context,
          title: StringConst.UPDATED_DOCUMENT,
          content: StringConst.UPDATED_DOC_SUCCESS,
          defaultActionText: StringConst.FORM_ACCEPT,
        );
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: StringConst.FORM_ERROR, exception: e).then((value) => Navigator.pop(context));
      }
    }
  }

}

