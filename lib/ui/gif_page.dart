//aqui é a página para mostrar o gif clicado

//para compartilhar usaremos um plug in:
// adicionar no pubspec.yaml share: ^2.0.4

import 'package:share/share.dart';

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

        //vamos adicionar a ação de compartilhar na AppBar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              //compartilhando o link:
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
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

