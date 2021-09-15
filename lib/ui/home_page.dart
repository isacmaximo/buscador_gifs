//aqui fica a Home Page

//libraries necessárias:
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//stateful:
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //variável de pesquisa:
  //colocamos interrogação pois estão com valor inicial null
  String? _search;
  //vai representar a quantidade de páginas
  int? _offset;

  //função que vai fazer as requisições de busca dos gifs:
  //como não é instantâneo, usamos async:
  Future<Map> _getGifs() async{
    http.Response response;
    //no caso vai ter dois tipos de resposta: top gis e pesquisa

    //se na pesquisa não estiver nada, então os top 20 gifs aparecerão:
    if(_search == null){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=qPx7EIu7Jk8dAwWIb57xNBHkO6QQcP7w&limit=20&rating=g"));
    }
    //no caso se for uma pesquisa:
    else{
      //parâmetros da busca: (q = _search) | (offset = _offset)
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=qPx7EIu7Jk8dAwWIb57xNBHkO6QQcP7w&q=$_search&limit=20&offset=$_offset&rating=g&lang=en"));
    }

    //precisamos requisitar o arquivo no formato json:
    return json.decode(response.body);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Homepage Interface:
      appBar: AppBar(
        backgroundColor: Colors.black,
        //o título do AppBar pode ser uma imagem também, não precisa ser um texto
        //no caso vamos pegar uma imagem da internet:
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),

      //corpo da homepage:
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui!",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                style: TextStyle(color: Colors.white,fontSize: 18.0),
                textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}