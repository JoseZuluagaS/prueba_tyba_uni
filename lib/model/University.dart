

import 'dart:io';


class University{

  String alphaCode = "";
  List domains = [];
  String pais = "";
  String? estado_provincia;
  List paginasWeb = [];
  String nombre = "";
  File? imagen;
  int cantidadEstudiantes;

  University(this.alphaCode, this.domains, this.estado_provincia, this.nombre, this.paginasWeb, this.pais, {this.imagen, this.cantidadEstudiantes = 0});

}