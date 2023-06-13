import 'dart:async';
import 'dart:typed_data';

import 'package:enreda_empresas/app/home/participants/pdf_generator/data.dart';
import 'package:enreda_empresas/app/models/certificationRequest.dart';
import 'package:enreda_empresas/app/models/experience.dart';
import 'package:enreda_empresas/app/models/userEnreda.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



const PdfColor lilac = PdfColor.fromInt(0xFF6768AB);
const PdfColor lightLilac = PdfColor.fromInt(0xFFF4F5FB);
const PdfColor blue = PdfColor.fromInt(0xFF002185);
const PdfColor grey = PdfColor.fromInt(0xFF535A5F);
const PdfColor greyDark = PdfColor.fromInt(0xFF44494B);
const PdfColor green = PdfColor.fromInt(0xF0DA1A0);
const PdfColor black = PdfColor.fromInt(0xF44494B);
const PdfColor white = PdfColor.fromInt(0xFFFFFFFF);
const leftWidth = 230.0;
const rightWidth = 350.0;

Future<Uint8List> generateResume3(
    PdfPageFormat format,
    CustomData data,
    UserEnreda? user,
    String? city,
    String? province,
    String? country,
    List<Experience>?
    myExperiences,
    List<Experience>? myEducation,
    List<String>? competenciesNames,
    List<String>? languagesNames,
    String? aboutMe,
    List<String>? myDataOfInterest,
    String myCustomEmail,
    String myCustomPhone,
    bool myPhoto,
    List<CertificationRequest>? myReferences,
    ) async {
  final doc = pw.Document(title: 'Mi Currículum');

  var url = user?.profilePic?.src ?? "";

  final profileImage = url == ""
      ? pw.MemoryImage(
    (await rootBundle.load(ImagePath.USER_DEFAULT)).buffer.asUint8List(),
  )
      : pw.MemoryImage(
    (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List(),
  );

  PdfPageFormat format1 = format.applyMargin(
      left: 0,
      top: 0,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);

  final pageTheme = await _myPageTheme(format1, myPhoto, profileImage);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<String>? dataOfInterest = myDataOfInterest;
  List<String>? languages = languagesNames;

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      build: (pw.Context context) => [
        pw.Partitions(
          children: [
            pw.Partition(
              width: leftWidth,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Container(
                    margin: const pw.EdgeInsets.only(left: 30.0),
                    height: pageTheme.pageFormat.availableHeight,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 30.0),
                      child: pw.Center(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: <pw.Widget>[
                                myPhoto == true ? pw.ClipOval(
                                  child: pw.Container(
                                    width: 120,
                                    height: 120,
                                    child: pw.Image(profileImage, fit: pw.BoxFit.cover),
                                  ),
                                ) : pw.Container(),
                                pw.SizedBox(height: 5),
                                pw.Text('${user?.firstName!.toUpperCase()} ${user?.lastName!.toUpperCase()}',
                                    textScaleFactor: 2,
                                    textAlign: pw.TextAlign.center,
                                    style: pw.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(fontWeight: pw.FontWeight.bold, color: white)),
                                pw.SizedBox(height: 5),
                                pw.Text(user?.educationName?.toUpperCase() ?? '',
                                    textScaleFactor: 1,
                                    textAlign: pw.TextAlign.center,
                                    style: pw.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                        fontWeight: pw.FontWeight.normal,
                                        color: white)),
                                pw.SizedBox(height: 5),
                                myCustomEmail != "" ?
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Icon(pw.IconData(0xe0be), size: 10.0, color: white),
                                    pw.SizedBox(width: 4),
                                    _UrlText(myCustomEmail, 'mailto: $myCustomEmail')
                                  ],
                                ) : pw.Container(),
                                pw.SizedBox(height: 5),
                                myCustomPhone != "" ?
                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Icon(pw.IconData(0xe0b0), size: 10.0, color: white),
                                      pw.SizedBox(width: 4),
                                      pw.Text(myCustomPhone,
                                          textScaleFactor: 0.8,
                                          textAlign: pw.TextAlign.center,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                              fontWeight: pw.FontWeight.normal,
                                              color: white)) ,
                                    ]
                                ) : pw.Container(),
                                pw.SizedBox(height: 5),
                                city != "" || province != "" || country != "" ?
                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Row(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          mainAxisAlignment: pw.MainAxisAlignment.start,
                                          children: [
                                            pw.Icon(pw.IconData(0xe8b4), size: 10.0, color: white),
                                            pw.Column(
                                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                                children: [
                                                  pw.Text('${city ?? ''}',
                                                      textScaleFactor: 0.8,
                                                      style: pw.Theme.of(context)
                                                          .defaultTextStyle
                                                          .copyWith(
                                                          fontWeight: pw.FontWeight.normal,
                                                          color: white)),
                                                  pw.Text('${province ?? ''}',
                                                      textScaleFactor: 0.8,
                                                      style: pw.Theme.of(context)
                                                          .defaultTextStyle
                                                          .copyWith(
                                                          fontWeight: pw.FontWeight.normal,
                                                          color: white)),
                                                  pw.Text('${country ?? ''}',
                                                      textScaleFactor: 0.8,
                                                      style: pw.Theme.of(context)
                                                          .defaultTextStyle
                                                          .copyWith(
                                                          fontWeight: pw.FontWeight.normal,
                                                          color: white)),
                                                ]
                                            )
                                          ]
                                      ),
                                      // _UrlText(
                                      //     'wholeprices.ca', 'https://wholeprices.ca'),
                                    ]
                                ) : pw.Container(),
                                pw.SizedBox(height: 5),
                                competenciesNames != null && competenciesNames.isNotEmpty ? _CategoryLabel(title: StringConst.COMPETENCIES, color: green) : pw.Container(),
                                for (var data in competenciesNames!)
                                  _BlockSimpleListLabel(
                                      title: data.toUpperCase(),
                                      color: white
                                  ),
                                pw.SizedBox(height: 5),
                                myReferences != null && myReferences.isNotEmpty ? _CategoryLabel(title: StringConst.REFERENCES, color: green) : pw.Container(),
                                for (var reference in myReferences!)
                                  _BlockIcon(
                                    title: '${reference.certifierName}',
                                    description1: '${reference.certifierPosition} - ${reference.certifierCompany}',
                                    description2: '${reference.email}',
                                    description3: '${reference.phone}',
                                  ),
                                // pw.Center(
                                //   child: pw.BarcodeWidget(
                                //       data: 'mailto:<${user?.email}>?subject=&body=',
                                //       width: 60,
                                //       height: 60,
                                //       barcode: pw.Barcode.qrCode(),
                                //       drawText: false,
                                //       color: white
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Partition(
              width: rightWidth,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    height: pageTheme.pageFormat.availableHeight,
                    padding: const pw.EdgeInsets.only(left: 50, right: 30),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        myExperiences != null && myExperiences.isNotEmpty ? _Category(title: StringConst.MY_EXPERIENCES, color: green) : pw.Container(),
                        for (var experience in myExperiences!)
                          _Block(
                            title: experience.activityRole != null &&
                                experience.activity != null
                                ? '${experience.activityRole} - ${experience.activity}'
                                : experience.position == ""
                                ? experience.activity
                                : experience.organization == ""
                                ? experience.position
                                : '${experience.position} - ${experience.organization}',
                            descriptionDate:'${formatter.format(experience.startDate.toDate())} / ${experience.endDate != null
                                ? formatter.format(experience.endDate!.toDate())
                                : 'Actualmente'}',
                            descriptionPlace: '${experience.location}',
                          ),
                        pw.SizedBox(height: 5),
                        myEducation!.isNotEmpty ? _Category(title: StringConst.EDUCATION, color: green) : pw.Container(),
                        for (var education in myEducation)
                          _Block(
                            title: education.activityRole == null
                                ? education.activity
                                : '${education.activityRole} - ${education.activity}',
                            descriptionDate:'${formatter.format(education.startDate.toDate())} / ${education.endDate != null
                                ? formatter.format(education.endDate!.toDate())
                                : 'Actualmente'}',
                            descriptionPlace: '${education.location}',
                          ),
                        pw.SizedBox(height: 15),
                        pw.Partitions(
                            children: [
                              pw.Partition(
                                  width: rightWidth / 2,
                                  child: pw.Column(
                                      children: [
                                        myDataOfInterest != null && myDataOfInterest.isNotEmpty ? _Category(title: StringConst.DATA_OF_INTEREST, color: green) : pw.Container(),
                                        for (var data in dataOfInterest!)
                                          _BlockSimpleList(
                                              title: data,
                                              color: grey
                                          ),
                                        pw.SizedBox(height: 15),
                                      ]
                                  )
                              ),
                              pw.Partition(
                                  width: rightWidth / 2,
                                  child: pw.Column(
                                      children: [
                                        languagesNames != null && languagesNames.isNotEmpty ? _Category(title: StringConst.LANGUAGES, color: green) : pw.Container(),
                                        for (var data in languages!)
                                          _BlockSimpleList(
                                              title: data,
                                              color: grey
                                          ),
                                        pw.SizedBox(height: 15),
                                      ]
                                  )
                              ),
                            ]
                        ),
                        aboutMe != null && aboutMe != "" ?
                        _BlockSimple(
                          title: StringConst.ABOUT_ME,
                          description: aboutMe,) : pw.Container(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format, bool myPhoto, profileImageWeb) async {
  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 3.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
    margin: pw.EdgeInsets.only(top: 70, left: 0.0, right: 20, bottom: 10),
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.latoRegular(),
      bold: await PdfGoogleFonts.alataRegular(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Container(
              margin: const pw.EdgeInsets.only(left: 30.0, right: 30, top: 60, bottom: 60),
              width: 200,
              decoration: pw.BoxDecoration(
                color: green,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(20)),
                shape: pw.BoxShape.rectangle,
              ),
              child: pw.Positioned(
                child: pw.Container(),
                left: 0,
                top: 0,
                bottom: 0,
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _Block extends pw.StatelessWidget {
  _Block({
    this.title,
    this.descriptionDate,
    this.descriptionPlace,
  });

  final String? title;
  final String? descriptionDate;
  final String? descriptionPlace;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                title != null ? pw.Expanded(
                  child: pw.Text(
                      title!.toUpperCase(),
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.bold,
                          color: grey)),
                ) : pw.Container()
              ]),
          pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(descriptionDate!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.normal,
                          color: grey)),
                ]),
          ),
          pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(descriptionPlace!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.normal,
                          color: grey)),
                ]),
          ),
          pw.SizedBox(height: 8),
        ]);
  }
}

class _Category extends pw.StatelessWidget {
  _Category({required this.title, required this.color});

  final String title;
  final PdfColor color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
          title.toUpperCase(),
          textScaleFactor: 1,
          style: pw.Theme.of(context)
              .defaultTextStyle
              .copyWith(
              fontWeight: pw.FontWeight.bold,
              color: color)),
    );
  }
}

class _Percent extends pw.StatelessWidget {
  _Percent({
    required this.size,
    required this.value,
    required this.title,
  });

  final double size;

  final double value;

  final pw.Widget title;

  static const fontSize = 1.2;

  PdfColor get color => lilac;

  static const backgroundColor = PdfColors.grey300;

  static const strokeWidth = 5.0;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: <pw.Widget>[
            pw.Center(
              child: pw.Text(
                '${(value * 100).round().toInt()}%',
                textScaleFactor: fontSize,
              ),
            ),
            pw.CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return pw.Column(children: widgets);
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
        destination: url,
        child: pw.Text(text,
            textScaleFactor: 0.8,
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(
                fontWeight: pw.FontWeight.normal,
                color: white))
    );
  }
}

class _BlockSimple extends pw.StatelessWidget {
  _BlockSimple({
    this.title,
    this.description,
  });

  final String? title;
  final String? description;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                title != null ? pw.Expanded(
                  child:
                  pw.Text(
                      title!.toUpperCase(),
                      textScaleFactor: 1,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.bold,
                          color: green)),
                ) : pw.Container()
              ]),
          pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  description != null ? pw.Text(description!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.normal,
                          color: grey)) : pw.Container(),
                ]),
          ),
          pw.SizedBox(height: 5),
        ]);
  }
}

class _BlockSimpleList extends pw.StatelessWidget {
  _BlockSimpleList({
    this.title,
    this.color
  });

  final String? title;
  final PdfColor? color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 3,
                  height: 3,
                  margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                    color: grey,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                title != null ? pw.Expanded(
                  child:
                  pw.Text(
                      title!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(fontWeight: pw.FontWeight.normal, color: color)),
                ) : pw.Container()
              ]),
          pw.SizedBox(height: 5),
        ]);
  }
}

class _BlockSimpleListLabel extends pw.StatelessWidget {
  _BlockSimpleListLabel({
    this.title,
    this.color
  });

  final String? title;
  final PdfColor? color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                title != null ? pw.Expanded(
                  child:
                  pw.Text(
                      title!.toUpperCase(),
                      textScaleFactor: 0.7,
                      textAlign: pw.TextAlign.center,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(fontWeight: pw.FontWeight.normal, color: color)),
                ) : pw.Container()
              ]),
          pw.SizedBox(height: 5),
        ]);
  }
}

class _CategoryLabel extends pw.StatelessWidget {
  _CategoryLabel({
    required this.title,
    required this.color,
  });

  final String title;
  final PdfColor color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 10, top: 10),
      padding: const pw.EdgeInsets.fromLTRB(20, 4, 20, 5),
      child: pw.Text(
          title.toUpperCase(),
          textScaleFactor: 1,
          style: pw.Theme.of(context)
              .defaultTextStyle
              .copyWith(fontWeight: pw.FontWeight.normal, color: color)
      ),
    );
  }
}

class _BlockIcon extends pw.StatelessWidget {
  _BlockIcon({
    this.title,
    this.description1,
    this.description2,
    this.description3,
  });

  final String? title;
  final String? description1;
  final String? description2;
  final String? description3;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              title != null ? pw.Expanded(
                child: pw.Text(
                    title!,
                    textScaleFactor: 0.9,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(
                        fontWeight: pw.FontWeight.bold,
                        color: white)),
              ) : pw.Container()
            ]),
        pw.SizedBox(height: 2),
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              description1 != null ? pw.Expanded(
                child: pw.Text(
                    description1!.toUpperCase(),
                    textScaleFactor: 0.8,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(
                        fontWeight: pw.FontWeight.bold,
                        color: white)),
              ) : pw.Container()
            ]),
        pw.SizedBox(height: 2),
        description2 != "" ?
        pw.Row(
          children: [
            pw.Icon(pw.IconData(0xe0be), size: 10.0, color:white),
            pw.SizedBox(width: 4),
            _UrlText(description2!, 'mailto: $description1')
          ],
        ) : pw.Container(),
        pw.SizedBox(height: 4),
        description3 != "" ?
        pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe0b0), size: 10.0, color:white),
              pw.SizedBox(width: 4),
              pw.Text(description3!,
                  textScaleFactor: 0.8,
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                      fontWeight: pw.FontWeight.normal,
                      color: white)) ,
            ]
        ) : pw.Container(),
        pw.SizedBox(height: 7),
      ],
    );
  }
}

