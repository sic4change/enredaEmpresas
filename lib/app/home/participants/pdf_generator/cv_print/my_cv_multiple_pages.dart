import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../models/certificationRequest.dart';
import '../../../../models/experience.dart';
import '../../../../models/language.dart';
import '../../../../models/userEnreda.dart';
import '../../../../values/values.dart';
import 'cv_multiple_pages.dart';
import 'data.dart';

class MyCvMultiplePages extends StatefulWidget {
  const MyCvMultiplePages({
    Key? key,
    required this.user,
    required this.city,
    required this.province,
    required this.country,
    required this.myExperiences,
    required this.myPersonalExperiences,
    required this.myEducation,
    required this.mySecondaryEducation,
    required this.competenciesNames,
    required this.languagesNames,
    required this.aboutMe,
    required this.myDataOfInterest,
    required this.myCustomEmail,
    required this.myCustomPhone,
    required this.myPhoto,
    required this.myCustomReferences,
    required this.myMaxEducation,
  }) : super(key: key);

  final UserEnreda? user;
  final String? city;
  final String? province;
  final String? country;
  final List<Experience>? myExperiences;
  final List<Experience>? myPersonalExperiences;
  final List<Experience>? myEducation;
  final List<Experience>? mySecondaryEducation;
  final List<String> competenciesNames;
  final List<Language> languagesNames;
  final String? aboutMe;
  final List<String> myDataOfInterest;
  final String myCustomEmail;
  final String myCustomPhone;
  final String myMaxEducation;
  final bool myPhoto;
  final List<CertificationRequest>? myCustomReferences;

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyCvMultiplePages> with SingleTickerProviderStateMixin {

  int _tab = 0;
  TabController? _tabController;
  PrintingInfo? printingInfo;
  var _data = const CustomData();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    _tabController = TabController(
      vsync: this,
      length: examplesMultiplePages.length,
      initialIndex: _tab,
    );
    _tabController!.addListener(() {
      if (_tab != _tabController!.index) {
        setState(() {
          _tab = _tabController!.index;
        });
      }
    });

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary020,
        content: Text('Documento impreso con éxito'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary020,
        content: Text('Documento compartido con éxito'),
      ),
    );
  }

  Future<void> _saveAsFile(
      BuildContext context,
      LayoutCallback build,
      PdfPageFormat pageFormat,
      ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/miCurriculum.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final actions = <PdfPreviewAction>[
      /*if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )*/
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary100,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primary900,),
        title: const Text('Mi Currículum'),
        titleTextStyle: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary900,
            fontSize: 22.0),
        bottom: TabBar(
          controller: _tabController,
          tabs: examplesMultiplePages.map<Tab>((e) => Tab(text: e.name)).toList(),
          labelColor: AppColors.primary900,
          labelStyle: TextStyle(fontSize: 20),
          isScrollable: true,
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => examplesMultiplePages[_tab].builder(
            format,
            _data,
            widget.user!,
            widget.city!,
            widget.province!,
            widget.country!,
            widget.myExperiences!,
            widget.myPersonalExperiences,
            widget.myEducation!,
            widget.mySecondaryEducation,
            widget.competenciesNames,
            widget.languagesNames,
            widget.aboutMe,
            widget.myDataOfInterest,
            widget.myCustomEmail,
            widget.myCustomPhone,
            widget.myPhoto,
            widget.myCustomReferences,
            widget.myMaxEducation,
        ),
        actions: actions,
        canDebug: false,
        initialPageFormat: PdfPageFormat.a4,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
        canChangeOrientation: false,
      ),
    );
  }
}
