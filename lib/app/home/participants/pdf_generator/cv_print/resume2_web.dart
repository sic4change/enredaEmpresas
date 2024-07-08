import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../models/certificationRequest.dart';
import '../../../../models/experience.dart';
import '../../../../models/language.dart';
import '../../../../models/userEnreda.dart';
import '../../../../values/strings.dart';
import '../../../../values/values.dart';
import 'package:http/http.dart';

import 'data.dart';


const PdfColor lilac = PdfColor.fromInt(0xF8A6A83);
const PdfColor lightLilac = PdfColor.fromInt(0xFFF4F5FB);
const PdfColor blue = PdfColor.fromInt(0xFF002185);
const PdfColor grey = PdfColor.fromInt(0xFF535A5F);
const PdfColor greyDark = PdfColor.fromInt(0xFFD6DAFB);
const PdfColor primary900 = PdfColor.fromInt(0xFF054D5E);
const PdfColor white = PdfColor.fromInt(0xFFFFFFFF);
const PdfColor greyLight = PdfColor.fromInt(0xFFADADAD);
const leftWidth = 200.0;
const rightWidth = 350.0;

Future<Uint8List> generateResume2(
    PdfPageFormat format,
    CustomData data,
    UserEnreda? user,
    String? city,
    String? province,
    String? country,
    List<Experience>? myExperiences,
    List<Experience>? myPersonalExperiences,
    List<Experience>? myEducation,
    List<Experience>? mySecondaryEducation,
    List<String>? competenciesNames,
    List<Language>? languagesNames,
    String? aboutMe,
    List<String>? myDataOfInterest,
    String myCustomEmail,
    String myCustomPhone,
    bool myPhoto,
    List<CertificationRequest>? myReferences,
    String myMaxEducation,
    ) async {
  final doc = pw.Document(title: 'Mi Currículum');
  var fontPoppins = await PdfGoogleFonts.poppinsExtraBold();

  var url = user?.profilePic?.src ?? "";

  Future<Uint8List> imageFromUrl(String url) async {
    final uri = Uri.parse(url);
    final Response response = await get(uri);
    return response.bodyBytes;
  }

  Future<Uint8List> myFutureUint8List = imageFromUrl(url);
  Uint8List myUint8List = await myFutureUint8List;

  final profileImageWeb = url == ""
      ? pw.MemoryImage((await rootBundle.load(ImagePath.USER_DEFAULT)).buffer.asUint8List(),)
      : pw.MemoryImage(myUint8List);

  PdfPageFormat format1 = format.applyMargin(
      left: 0,
      top: 0,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);

  final pageTheme = await _myPageTheme(format1, myPhoto, profileImageWeb);
  final DateFormat formatter = DateFormat('yyyy');
  List<String>? dataOfInterest = myDataOfInterest;
  List<Language>? languages = languagesNames;


  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Pág. ${context.pageNumber} de ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      header: (pw.Context context) {
        if (context.pageNumber > 1) {
          return
            pw.Container(
                alignment: pw.Alignment.topLeft,
                margin: const pw.EdgeInsets.only(left: 30, bottom: 30),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text('${user?.firstName}',
                        textScaleFactor: 1.2,
                        style: pw.TextStyle(
                            font: fontPoppins,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18,
                            color: primary900)),
                    pw.Text('${user?.lastName}',
                        textScaleFactor: 1.2,
                        style: pw.Theme.of(context)
                            .defaultTextStyle
                            .copyWith(fontWeight: pw.FontWeight.bold, color: primary900)),
                  ],
                )
            );
        }
        return
          pw.Container(
            alignment: pw.Alignment.topLeft,
            margin: const pw.EdgeInsets.only(left: 30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text('${user?.firstName}',
                    textScaleFactor: 1.5,
                    style: pw.TextStyle(
                        font: fontPoppins,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 18,
                        color: primary900)),
                pw.Text('${user?.lastName}',
                    textScaleFactor: 1.2,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontWeight: pw.FontWeight.bold, color: primary900)),
              ],
            )
          );
      },
      build: (pw.Context context) => <pw.Widget> [
        pw.Partitions(
          children: [
            pw.Partition(
              width: leftWidth,
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.SizedBox(height: 120),
                    myCustomEmail != "" ?
                    _Category(title: StringConst.PERSONAL_DATA, color: primary900) : pw.Container(),
                    myCustomEmail != "" ?
                    pw.Row(
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          width: 15,
                          height: 15,
                          padding: const pw.EdgeInsets.all(2.0),
                          decoration: pw.BoxDecoration(
                            color: primary900,
                            shape: pw.BoxShape.circle,
                          ),
                          child: pw.Icon(pw.IconData(0xe0be), size: 8.0, color: white),
                        ),
                        pw.SizedBox(width: 4),
                        _UrlText(myCustomEmail, 'mailto: $myCustomEmail')
                      ],
                    ) : pw.Container(),
                    pw.SizedBox(height: 4),
                    myCustomPhone != "" ?
                    pw.Row(
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.center,
                            width: 15,
                            height: 15,
                            padding: const pw.EdgeInsets.all(2.0),
                            decoration: pw.BoxDecoration(
                              color: primary900,
                              shape: pw.BoxShape.circle,
                            ),
                            child: pw.Icon(pw.IconData(0xe0b0), size: 10.0, color: white),
                          ),
                          pw.SizedBox(width: 4),
                          pw.Text(myCustomPhone,
                              textScaleFactor: 0.9,
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                  fontWeight: pw.FontWeight.normal,
                                  color: grey)) ,
                        ]
                    ) : pw.Container(),
                    pw.SizedBox(height: 4),
                    city != "" || province != "" || country != "" ?
                    pw.Row(
                        children: [
                          pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Container(
                                  alignment: pw.Alignment.center,
                                  width: 15,
                                  height: 15,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  decoration: pw.BoxDecoration(
                                    color: primary900,
                                    shape: pw.BoxShape.circle,
                                  ),
                                  child: pw.Icon(pw.IconData(0xe8b4), size: 10.0, color: white),
                                ),
                                pw.SizedBox(width: 4),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('${city ?? ''}',
                                          textScaleFactor: 0.8,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                              fontWeight: pw.FontWeight.normal,
                                              color: grey)),
                                      pw.Text('${province ?? ''}',
                                          textScaleFactor: 0.8,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                              fontWeight: pw.FontWeight.normal,
                                              color: grey)),
                                      pw.Text('${country?.toUpperCase() ?? ''}',
                                          textScaleFactor: 0.8,
                                          style: pw.Theme.of(context)
                                              .defaultTextStyle
                                              .copyWith(
                                              fontWeight: pw.FontWeight.normal,
                                              color: grey)),
                                    ]
                                )
                              ]
                          ),
                        ]
                    ) : pw.Container(),
                    pw.SizedBox(height: 10),
                    aboutMe != null && aboutMe != "" ?
                    _BlockSimple(
                      title: StringConst.ABOUT_ME,
                      description: aboutMe,) : pw.Container(),
                    pw.SizedBox(height: 10),
                    myDataOfInterest != null && myDataOfInterest.isNotEmpty ? _Category(title: StringConst.DATA_OF_INTEREST, color: primary900) : pw.Container(),
                    for (var data in dataOfInterest!)
                      _CustomChipList(
                        title: data,
                        color: primary900,
                      ),
                    pw.SizedBox(height: 15),
                    languagesNames != null && languagesNames.isNotEmpty ? _Category(title: StringConst.LANGUAGES, color: primary900) : pw.Container(),
                    for (var data in languages!)
                      _BlockSimpleList(
                        title: data.name,
                        color: grey,
                        dotsSpeaking: data.speakingLevel,
                        dotsWriting: data.writingLevel,
                      ),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      child: pw.Column(
                        children: [
                          myReferences != null && myReferences.isNotEmpty ? _Category(title: StringConst.REFERENCES, color: primary900) : pw.Container(),
                          for (var reference in myReferences!)
                            _BlockIcon(
                              title: '${reference.certifierName}',
                              description1: '${reference.certifierPosition} - ${reference.certifierCompany}',
                              description2: '${reference.email}',
                              description3: '${reference.phone}',
                            ),
                        ]
                      )
                    ),

                  ],
                ),
              ),
            ),
            pw.Partition(
              width: rightWidth,
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(myMaxEducation.toUpperCase() ?? '',
                        textScaleFactor: 1.2,
                        style: pw.Theme.of(context)
                            .defaultTextStyle
                            .copyWith(
                            fontWeight: pw.FontWeight.normal,
                            color: grey)),
                    pw.SizedBox(height: 10),
                    myExperiences != null && myExperiences.isNotEmpty ? _Category(title: StringConst.MY_PROFESIONAL_EXPERIENCES, color: primary900) : pw.Container(),
                    for (var experience in myExperiences!)
                      _Block(
                          title: (experience.activity != null) ? experience.activity : '',
                          organization: experience.organization != "" && experience.organization != null && experience.position != "" && experience.position != null ? '${experience.position} - ${experience.organization}'
                              : experience.organization != null || experience.organization != "" ? experience.organization :  experience.position != null && experience.position != "" ? experience.position : "",
                          showDescriptionDate: true,
                          descriptionDate:'${experience.startDate != null ? formatter.format(experience.startDate!.toDate())
                              : '-'} / ${experience.endDate != null ? formatter.format(experience.endDate!.toDate()) : 'Actualmente'}',
                          descriptionPlace: '${experience.location}',
                          descriptionActivities:
                          experience.professionActivitiesText != null ? experience.professionActivitiesText!
                              .split(' / ')
                              .where((item) => item.isNotEmpty) // Filter out empty items.
                              .map((item) => '• $item')         // Prefix each item with a bullet point.
                              .join('\n') :
                          experience.professionActivities
                              .where((item) => item.isNotEmpty) // Filter out empty items.
                              .map((item) => '• $item')         // Prefix each item with a bullet point.
                              .join('\n')
                      ),
                    pw.SizedBox(height: 10),

                    myPersonalExperiences != null && myPersonalExperiences.isNotEmpty ? _Category(title: StringConst.MY_PERSONAL_EXPERIENCES, color: primary900) : pw.Container(),
                    for (var experience in myPersonalExperiences!)
                      _Block(
                        title: experience.subtype == 'Responsabilidades familiares' || experience.subtype == "Compromiso social" ? experience.subtype :
                        experience.activityRole != null && experience.activity != null && experience.subtype != null
                            ? '${experience.subtype} - ${experience.activityRole} - ${experience.activity}'
                            : experience.activityRole != null && experience.activity != null ? '${experience.activityRole} - ${experience.activity}' :
                        experience.activity != null && experience.subtype != null ? '${experience.subtype} - ${experience.activity}' :
                        experience.activity != null ? experience.activity : '',
                        organization: experience.organization != "" && experience.organization != null && experience.position != "" && experience.position != null ? '${experience.position} - ${experience.organization}'
                            : experience.organization != null || experience.organization != "" ? experience.organization :  experience.position != null && experience.position != "" ? experience.position : "",
                        showDescriptionDate: true,
                        descriptionDate:'${experience.startDate != null ? formatter.format(experience.startDate!.toDate())
                            : '-'} / ${experience.endDate != null ? formatter.format(experience.endDate!.toDate()) : 'Actualmente'}',
                        descriptionPlace: '${experience.location}',
                      ),
                    pw.SizedBox(height: 10),

                    myEducation!.isNotEmpty ? _Category(title: StringConst.EDUCATION, color: primary900) : pw.Container(),
                    for (var education in myEducation)
                      _Block(
                        title: education.institution != null && education.nameFormation != null && education.nameFormation != ''
                            ? '${education.institution} - ${education.nameFormation}'
                            : education.institution == null ? education.nameFormation : education.institution,
                        organization: education.organization != "" && education.organization != null ? education.organization : '',
                        showDescriptionDate: true,
                        descriptionDate:'${education.startDate != null ? formatter.format(education.startDate!.toDate())
                            : '-'} / ${education.endDate != null ? formatter.format(education.endDate!.toDate()) : 'Actualmente'}',
                        descriptionPlace: '${education.location}',
                      ),
                    pw.SizedBox(height: 10),

                    mySecondaryEducation!.isNotEmpty ? _Category(title: StringConst.SECONDARY_EDUCATION, color: primary900) : pw.Container(),
                    for (var education in mySecondaryEducation)
                      _Block(
                        title: education.institution != null && education.nameFormation != null && education.nameFormation != ''
                            ? '${education.institution} - ${education.nameFormation}'
                            : education.institution == null ? education.nameFormation : education.institution,
                        organization: education.organization != "" && education.organization != null ? education.organization : '',
                        showDescriptionDate: true,
                        descriptionDate:'${education.startDate != null ? formatter.format(education.startDate!.toDate())
                            : '-'} / ${education.endDate != null ? formatter.format(education.endDate!.toDate()) : 'Actualmente'}',
                        descriptionPlace: '${education.location}',
                      ),
                    pw.SizedBox(height: 10),
                    competenciesNames != null && competenciesNames.isNotEmpty ? _Category(title: StringConst.COMPETENCIES, color: primary900) : pw.Container(),
                    for (var data in competenciesNames!)
                      _BlockSimpleList(
                        title: data,
                        color: grey,
                      ),
                  ],
                ),
              )
            )
          ],
        ),
      ],
    ),
  );
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format, bool myPhoto, profileImageWeb) async {
  final bgShape = await rootBundle.loadString('assets/images/polygon.svg');
  final bgShape2 = await rootBundle.loadString('assets/images/polygon2.svg');
  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 2.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
    margin: pw.EdgeInsets.only(top: 50, left: 0.0, right: 20, bottom: 10),
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.poppinsLight(),
      bold: await PdfGoogleFonts.poppinsMedium(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (pw.Context context) {
      if (context.pageNumber > 1) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Stack(
            children: [
              pw.Container(
                width: 200,
                decoration: pw.BoxDecoration(
                  color: greyDark,
                  shape: pw.BoxShape.rectangle,
                ),
                child: pw.Positioned(
                  child: pw.Container(),
                  left: 0,
                  top: 0,
                  bottom: 0,
                ),
              ),
              pw.Positioned(
                child: pw.SvgImage(svg: bgShape2),
                left: 0,
                top: 10,
              ),
            ],
          ),
        );
      }
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Container(
              width: 200,
              decoration: pw.BoxDecoration(
                color: greyDark,
                shape: pw.BoxShape.rectangle,
              ),
              child: pw.Positioned(
                child: pw.Container(),
                left: 0,
                top: 0,
                bottom: 0,
              ),
            ),
            pw.Positioned(
              child: pw.SvgImage(svg: bgShape),
              left: 0,
              top: 10,
            ),
            myPhoto == true ?
            pw.Positioned(
              right: 380,
              top: 110,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(
                      color: white,
                    )
                ),
                child: pw.ClipOval(
                  child: pw.Container(
                    width: 80,
                    height: 80,
                    child: pw.Image(profileImageWeb, fit: pw.BoxFit.cover),
                  ),
                )
              ),
            ) : pw.Container(),
          ],
        ),
      );
    },
  );
}

class _Block extends pw.StatelessWidget {
  _Block({
    this.title,
    this.organization,
    this.descriptionDate,
    this.descriptionPlace,
    this.showDescriptionDate,
    this.descriptionActivities,
  });

  final String? title;
  final String? organization;
  final String? descriptionDate;
  final String? descriptionPlace;
  final bool? showDescriptionDate;
  final String? descriptionActivities;

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
          organization != null ? pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Expanded(
                  child: pw.Text(
                      organization!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.bold,
                          color: grey)),
                )
              ]) : pw.Container(),
          pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  (showDescriptionDate ?? true) ? pw.Text(descriptionDate!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.normal,
                          color: grey))
                      : pw.Container(),
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
          descriptionActivities != null ? pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text('Actividades realizadas:',
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.bold,
                          color: grey)),
                  pw.Text(descriptionActivities!,
                      textScaleFactor: 0.8,
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(
                          fontWeight: pw.FontWeight.normal,
                          color: grey)),
                ]),
          ) : pw.Container(),
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
                color: grey))
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
                          color: primary900)),
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
    this.color,
    this.dotsSpeaking,
    this.dotsWriting,
  });

  final String? title;
  final PdfColor? color;
  late int? dotsSpeaking;
  late int? dotsWriting;

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
                    color: primary900,
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
                ) : pw.Container(),
              ]),
          dotsSpeaking != null && dotsWriting != null ? pw.Container() : pw.SizedBox(height: 8),
          dotsSpeaking != null && dotsWriting != null ?
          pw.Column(
              children: [
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(width: 10),
                      pw.Text('Oral:  ', textScaleFactor: 0.8, style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.normal)),
                      _Dots(dotsNumber: dotsSpeaking),
                      pw.SizedBox(width: 10),
                      pw.Text('Escrito:  ', textScaleFactor: 0.8, style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.normal)),
                      _Dots(dotsNumber: dotsWriting
                      ),
                    ]
                )
              ]
          ) : pw.Container()
        ]);
  }
}

class _CustomChipList extends pw.StatelessWidget {
  _CustomChipList({
    this.title,
    this.color,
  });

  final String? title;
  final PdfColor? color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
      padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: pw.BoxDecoration(
        color: color ?? primary900,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: title != null ? pw.Text(
          title!,
          textScaleFactor: 0.8,
          style: pw.Theme.of(context)
              .defaultTextStyle
              .copyWith(fontWeight: pw.FontWeight.normal, color: white)) : pw.Container(),
    );
  }
}

class _Dots extends pw.StatelessWidget {
  _Dots({
    this.dotsNumber,
  });

  final int? dotsNumber;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        buildDotRow(),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget buildDotRow() {
    List<pw.Widget> dots = [];
    for (int i = 0; i < 3; i++) {
      PdfColor color = i < (dotsNumber ?? 0) ? primary900 : greyLight;
      dots.add(buildDot(color));
    }
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: dots,
    );
  }

  pw.Widget buildDot(PdfColor color) {
    return pw.Container(
      width: 6,
      height: 6,
      margin: const pw.EdgeInsets.only(top: 10, left: 2, right: 2),
      decoration: pw.BoxDecoration(
        color: color,
        shape: pw.BoxShape.circle,
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
                        color: grey)),
              ) : pw.Container()
            ]),
        pw.SizedBox(height: 4),
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
                        color: grey)),
              ) : pw.Container()
            ]),
        pw.SizedBox(height: 4),
        description2 != "" ?
        pw.Row(
          children: [
            pw.Icon(pw.IconData(0xe0be), size: 10.0, color: primary900),
            pw.SizedBox(width: 4),
            _UrlText(description2!, 'mailto: $description1')
          ],
        ) : pw.Container(),
        pw.SizedBox(height: 4),
        description3 != "" ?
        pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe0b0), size: 10.0, color: primary900),
              pw.SizedBox(width: 4),
              pw.Text(description3!,
                  textScaleFactor: 0.8,
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(
                      fontWeight: pw.FontWeight.normal,
                      color: grey)) ,
            ]
        ) : pw.Container(),
        pw.SizedBox(height: 12),
      ],
    );
  }
}