//App  5 - buscador de Gifs

//primeiro precisamos adicionar ao pubspec.yaml:
//share: ^0.6.1+1
// transparent_image: ^1.0.0
// http: ^0.12.0+2

//depois pegamos as urls da API

//libraries necessárias:
import 'package:flutter/material.dart';

//importando os arquivos para a main acessar:
//home page:
import 'package:buscador_de_gifs/ui/home_page.dart';

//função principal
void main(){
  //material app:
  runApp(const MaterialApp(
    //como o app vai ter mais de uma tela, então diferenciamos elas:
    //foi criado um diretório ui que contém a home page
    home: HomePage(),
  ));
}



