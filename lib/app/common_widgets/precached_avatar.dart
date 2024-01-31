import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class PrecacheAvatarCard extends StatefulWidget {
  const PrecacheAvatarCard({super.key,
    this.imageUrl = "",
    this.width = 0,
    this.height = 0,
  });

  final String imageUrl;
  final double width;
  final double height;

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
      width: widget.width,
      height: widget.height,
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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(60)),
      child: profileImage,
    );
  }
}

class PrecacheResourceCard extends StatefulWidget {
  const PrecacheResourceCard({super.key,
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


class PrecacheResourcePicture extends StatefulWidget {
  const PrecacheResourcePicture({super.key,
    this.imageUrl = "",
    this.width = 0,
    this.height = 0,
  });

  final String imageUrl;
  final double width;
  final double height;

  @override
  _PrecacheResourcePictureState createState() => _PrecacheResourcePictureState();
}

class _PrecacheResourcePictureState extends State<PrecacheResourcePicture> {

  late FadeInImage profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = FadeInImage.assetNetwork(
      placeholder: ImagePath.USER_DEFAULT,
      width: widget.width,
      height: widget.height,
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
      child: Center(
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


