import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class PrecacheAvatarCard extends StatefulWidget {
  PrecacheAvatarCard({
    this.imageUrl = "",
  });

  final String imageUrl;

  @override
  _PrecacheAvatarCardState createState() => _PrecacheAvatarCardState();
}

class _PrecacheAvatarCardState extends State<PrecacheAvatarCard> {

  late FadeInImage profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = FadeInImage.assetNetwork(
      placeholder: ImagePath.USER_DEFAULT,
      width: 35,
      height: 35,
      fit: BoxFit.cover,
      image: widget.imageUrl,
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(profileImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: defaultChild(),
    );
  }

  Widget defaultChild() {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(60)),
        child:
        Center(
          child: profileImage,
        ),
      );
  }

}

class PrecacheCompetencyCard extends StatefulWidget {
  PrecacheCompetencyCard({
    this.imageUrl = "",
    this.imageWidth = 0.0,
  });

  final String imageUrl;
  final double imageWidth;

  @override
  _PrecacheCompetencyCardState createState() => _PrecacheCompetencyCardState();
}

class _PrecacheCompetencyCardState extends State<PrecacheCompetencyCard> {

  late FadeInImage profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = FadeInImage.assetNetwork(
      width: widget.imageWidth,
      placeholder: ImagePath.IMAGE_DEFAULT,
      alignment: Alignment.center,
      image: widget.imageUrl,
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(profileImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: defaultChild(),
    );
  }

  Widget defaultChild() {
    return profileImage;
  }

}

class PrecacheResourceCard extends StatefulWidget {
  PrecacheResourceCard({
    this.imageUrl = "",
  });

  final String imageUrl;

  @override
  _PrecacheResourceCardState createState() => _PrecacheResourceCardState();
}

class _PrecacheResourceCardState extends State<PrecacheResourceCard> {

  late FadeInImage resourceImage;

  @override
  void initState() {
    super.initState();
    resourceImage = FadeInImage.assetNetwork(
      placeholder: ImagePath.IMAGE_DEFAULT,
      fit: BoxFit.cover,
      image: widget.imageUrl,
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(resourceImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: defaultChild(),
    );
  }

  Widget defaultChild() {
    return resourceImage;
  }

}


