//aqui é a página para mostrar o gif clicado

import 'package:flutter/material.dart';

//página apenas para mostrar o gif, então ela pode ser stateless:
class GifPage extends StatelessWidget {

  //para passar o conteúdo do gif tem que ter um mapa:
  final Map _gifData;
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"], style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      //o corpo vai ser o gif centralizado:
      body: Center(
        //url do gif:
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

