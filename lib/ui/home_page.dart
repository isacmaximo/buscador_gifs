//aqui fica a Home Page

//libraries necessárias:
import 'package:buscador_de_gifs/ui/gif_page.dart';
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
  int _offset = 0;

  //função que vai fazer as requisições de busca dos gifs:
  //como não é instantâneo, usamos async:
  Future<Map> _getGifs() async {
    http.Response response;
    //no caso vai ter dois tipos de resposta: top gis e pesquisa

    //se na pesquisa não estiver nada, então os top gifs aparecerão:
    if (_search == null) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=qPx7EIu7Jk8dAwWIb57xNBHkO6QQcP7w&limit=20&rating=g"));
    }
    //no caso se for uma pesquisa:
    else {
      //parâmetros da busca: (q = _search) | (offset = _offset)
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=qPx7EIu7Jk8dAwWIb57xNBHkO6QQcP7w&q=$_search&limit=19&offset=$_offset&rating=g&lang=en"));
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
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
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
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
                //quando clicar no input (campo de pesquisa):
                onSubmitted: (text){
                  //para atualizar a tela que vai pesquisar:
                  setState(() {
                    _search = text;
                    //offset vai para zero pois vai mostrar os primeiros ítens:
                    _offset = 0;
                  });

                },
              )
          ),

          //grade de gifs: como queremos que ocupe o resto da homepage, usaremos um expanded:
          Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                //verifica o estado:
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    //primeiro caso: esteja esperando por algo
                    case ConnectionState.waiting:
                      //segundo caso: esteja esperando por nada
                    case ConnectionState.none:
                      //aqui vai mostrar o widget de carregamento:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        //tipo circular:
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      //se o snapshot tem um erro:
                      if (snapshot.hasError){
                        return Container();
                      }
                      //se não, ele carrega a tabela de gifs
                      else{
                        return _createGifTable(context, snapshot);
                      }
                  }
                }
              ),
          ),
        ],
      ),
    );
  }


  int _getCount(List data){
    //se no campo de pesquisa não tiver nada:
    if(_search == null){
      //retorna o tamanho:
      return data.length;
    }
    else{
      //vai somar a quantidade dew gifs + 1 para colocar o botão de carregar mais gifs
      return data.length + 1;
    }
  }

  //grade de gifs:
Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    //retornando um widget gridview
  return GridView.builder(
    padding: EdgeInsets.all(10.0),

    //como ops ítens vão ser organizados na tela:
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //quantos ítens ele vai ter na horizontal:
      crossAxisCount: 2,
      //espaçamento entre os ítens na horizontal
      crossAxisSpacing: 10.0,
      //espaçamento na vertical
      mainAxisSpacing: 10.0,
    ),

    //quantidade de gifs:
    itemCount: _getCount(snapshot.data["data"]),

    itemBuilder: (context, index){
      //se não estiver pesquisando, ou não for o último ítem:
      if (_search == null || index < snapshot.data["data"].length){
        //aqui vai retornar o ítem que aparece em cada posição:
        //gesture detector serve para interagir (dectecta se é tocado por exemplo)
        return GestureDetector(
          //imagem da internet que no caso vai ser o gif:
          child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"], height: 300.0, fit: BoxFit.cover,),
          //se clicar no gif:
          onTap: (){
            //o navigator vai levá-lo a uma rota de ou página (arquivo)
            Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
          },
        );
      }
      //se estiver pesquisando:
      else{
        return Container(
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //ícone de adicionar (+)
                Icon(Icons.add, color: Colors.white, size: 70.0,),
                Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 22.0))
              ],
            ),
            //ao clicar nesse botão:
            onTap: (){
              setState(() {
                _offset += 19;
              });
            },
          ),
        );
      }

    },
  );
}

}
