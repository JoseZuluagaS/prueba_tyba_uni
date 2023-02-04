import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:prueba_tyba_universities/model/University.dart';

class UniversityScreen extends StatefulWidget {
  University universityData;

  UniversityScreen({Key? key, required this.universityData}) : super(key: key);

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController studentsController = TextEditingController();
  String errorText = "The filed must have only numbers and/or not be empty";
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.universityData.nombre)),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  foregroundImage: widget.universityData.imagen == null
                      ? null
                      : FileImage(widget.universityData.imagen!),
                  radius: 100,
                  child: const Text("No picture available"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () => modalBottomSheet(context),
                  child: const Text("Change Photo")),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const Text("Country: "),
                    Text(widget.universityData.pais)
                  ],),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const Text("State or Providence: "),
                    widget.universityData.estado_provincia != null ? Text(widget.universityData.pais) : const Text("N/A")
                  ],),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const Text("Web Page: "),
                    Text(widget.universityData.paginasWeb[0])
                  ],),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const Text("Students: "),
                    Text(widget.universityData.cantidadEstudiantes == 0 ? "N/A" : widget.universityData.cantidadEstudiantes.toString())
                  ],),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
              ),
              ElevatedButton(
                  onPressed: () => modalAsignarEstudiantes(context),
                  child: const Text("Asign Students"))
            ],
          ),
        ));
  }

  modalBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _onImageButtonPressed(ImageSource.camera),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add a photo",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => _onImageButtonPressed(ImageSource.gallery),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.browse_gallery_sharp,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Import from gallery",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ],
              ),
            ));
  }

  modalAsignarEstudiantes(BuildContext context){
    showDialog(context: context, builder: (context) => AlertDialog(
      
      title: const Text("Asign Students"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please, insert number of students to asign to the institution"),
          const SizedBox(height: 20,),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: studentsController,
          ),
          isError ? Text(errorText) : const Text(""),
          ElevatedButton(
              onPressed: () => asignarEstudiantes(),
              child: const Text("Asign")),
          
        ],
      ),
    ));
  }

  asignarEstudiantes(){
    if(studentsController.text.isEmpty){
      setState(() {
        isError = true;
      });
    }else{
      setState(() {
        widget.universityData.cantidadEstudiantes = int.tryParse(studentsController.text)!;
        isError = false;
      });
      studentsController.text = "";
      Navigator.pop(context);
    }
  }

  Future _onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile == null) return;
      File? img = File(pickedFile.path);
      setState(() {
        widget.universityData.imagen = img;
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}
