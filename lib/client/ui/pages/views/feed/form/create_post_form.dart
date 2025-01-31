import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gamma/server/models/post_model.dart';
import 'package:gamma/server/services/StorageService.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controllers/user_controller.dart';

class CreatePostForm extends StatefulWidget {
  CreatePostForm(
    this.callback, {
    Key? key,
  }) : super(key: key);

  final Function callback;

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  UserController userController = Get.find();
  StorageService storage = StorageService();

  TextEditingController controller = TextEditingController();
  String mediaPath = '', mediaName = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        _buildTextField(controller, width, height),
        _buildUploadButton(width, height),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, double width, double height) {
    UserController userController = Get.find();
    const maxLines = 15;
    return ListTile(
      leading: FutureBuilder(
        future: storage.downloadURL(userController.loggedUser.profilePhoto),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!),
              radius: width * 0.0888,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      title: Container(
        margin: const EdgeInsets.all(12),
        height: maxLines * 24.0,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color.fromARGB(109, 255, 255, 255),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (10.0 / 360) * width),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.hind(
              color: const Color.fromARGB(255, 254, 244, 255),
              fontSize: (16 / 360) * width,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              // contentPadding: const EdgeInsets.only(top: 14.0),
              hintText: '¿Qué quieres compartir?',
              hintStyle: GoogleFonts.hind(
                  color: const Color.fromARGB(164, 254, 244, 255),
                  fontWeight: FontWeight.normal,
                  fontSize: (16 / 360) * width),
            ),
          ),
        ),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.send_rounded,
            color: Colors.white,
            size: width * 0.06,
          ),
          onPressed: () async {
            log('Create post button pressed');
            String caption = controller.text;
            controller.clear();
            await storage.uploadFile(mediaName, mediaPath, 2).then((reference) {
              widget.callback(PostModel(
                userID: userController.loggedUser.id,
                userUsername: userController.loggedUserUsername,
                userProfilePicture: userController.loggedUserPicture,
                picture: reference,
                caption: caption,
                postedTimeStamp: DateTime.now(),
                likes: List<String>.empty(growable: true),
                comments: List<Map<String, String>>.empty(growable: true),
                shares: List<String>.empty(growable: true),
              ));
            }).catchError((onError) => log('Error uploading file: $onError'));
          }),
    );
  }

  Widget _buildUploadButton(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPostActions('Subir Imagen', width, height),
      ],
    );
  }

  Widget _buildPostActions(String post, double width, double height) {
    return Container(
        width: width * 0.3,
        padding: EdgeInsets.only(top: 0.0132 * height),
        child: TextButton(
          onPressed: () async {
            var results = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png', 'jpeg'],
            );

            if (results != null) {
              mediaPath = results.files.single.path!;
              mediaName = results.files.single.name;
            }

            log('$post Column Pressed');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.0132, horizontal: width * 0.0138),
            backgroundColor: const Color.fromARGB(255, 54, 9, 91),
            minimumSize: const Size(150, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: Text(
            post,
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
                color: const Color.fromARGB(255, 241, 219, 255),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.042),
          ),
        ));
  }
}
