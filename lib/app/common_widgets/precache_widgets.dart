import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';


class PrecacheImageCard extends StatefulWidget {
  PrecacheImageCard({
    this.imageUrl = "",
  });

  final String imageUrl;

  @override
  _PrecacheImageCardState createState() => _PrecacheImageCardState();
}

class _PrecacheImageCardState extends State<PrecacheImageCard> {

  late Image profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = Image.asset(widget.imageUrl, fit: BoxFit.cover);
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

class PrecacheCarrouselImage extends StatefulWidget {
  PrecacheCarrouselImage({
    this.imageUrl = "",
    this.imageHeight = 0.0,
  });

  final String imageUrl;
  final double imageHeight;

  @override
  _PrecacheCarrouselImageState createState() => _PrecacheCarrouselImageState();
}

class _PrecacheCarrouselImageState extends State<PrecacheCarrouselImage> {

  late Image profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = Image.asset(
      widget.imageUrl,
      height: widget.imageHeight,
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

  late FadeInImage profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = FadeInImage.assetNetwork(
      placeholder: ImagePath.IMAGE_DEFAULT,
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
    return profileImage;
  }

}