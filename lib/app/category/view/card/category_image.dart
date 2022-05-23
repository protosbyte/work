import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whiteboard/app/utils/colors.dart';

class CategoryImage extends StatelessWidget {
   const CategoryImage({Key? key, required this.imageUrl}) : super(key: key);
   final String imageUrl;

   @override
   Widget build(BuildContext context) {
     return Container(
       height: 90,
       margin: EdgeInsets.only(top: 10),
       child: CachedNetworkImage(
         imageUrl: imageUrl,
         imageBuilder: (context, imageProvider) => Container(
           width: 80, height: 80,
           decoration: BoxDecoration(
             image: DecorationImage(
               image: imageProvider,
               fit: BoxFit.contain,
             ),
           ),
         ),
         placeholder: (context, url) => LinearProgressIndicator(backgroundColor: Colors.white, color: whiteboard_red,),
         errorWidget: (context, url, error) => Icon(Icons.error),
         httpHeaders: {
           'User-Agent': 'whiteboardagent',
         },
       ),
     );
   }
 }
