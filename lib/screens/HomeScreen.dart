import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:prueba_tyba_universities/api/api.dart';
import 'package:prueba_tyba_universities/model/University.dart';
import 'package:prueba_tyba_universities/screens/screens.dart';

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<University> universidades = [];

  TipoVista vistaPrincipal = TipoVista.list;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Universities"), actions: [
        IconButton( icon:  Icon(vistaPrincipal == TipoVista.list ? Icons.grid_on : Icons.list)  
        ,onPressed: (){
          if(vistaPrincipal == TipoVista.list){
            vistaPrincipal = TipoVista.grid;
          }else{
            vistaPrincipal = TipoVista.list;
          }
          setState(() {});
        } ,)
      ],),
      body: isLoading ? const Center(child: CircularProgressIndicator()) :
       vistaPrincipal == TipoVista.list ? 
        ListView.builder(itemBuilder: universityBuilder, itemCount: universidades.length,)
      :
        GridView.builder(gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, childAspectRatio: 3/2, crossAxisSpacing: 10, mainAxisSpacing: 10,
        ), itemBuilder: universityBuilder)
    );
  }

  Widget universityBuilder(BuildContext context, int index){
    if(vistaPrincipal == TipoVista.list){
      return ListTile(
      leading: const Icon(Icons.school),
      title: Text(universidades[index].nombre),
      trailing: Text(universidades[index].pais),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) =>  UniversityScreen(universityData: universidades[index])));
      },
      );
    }else{
      return Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:(context) =>  UniversityScreen(universityData: universidades[index])));
          },
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text(universidades[index].nombre),
                const SizedBox(height: 5,),
                Text(universidades[index].pais)
              ]),
            ),
          ),
        ),
      );
    }
    
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUniversities().then((value){
      List respuesta = jsonDecode(value.body);
      for (var element in respuesta) {
        Map<String, dynamic> u = element;
        University newUniversity = University(u["alpha_two_code"], u["domains"], u["state-providence"], u["name"], u["web_pages"], u["country"]);
        universidades.add(newUniversity);
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
enum TipoVista{grid, list}

