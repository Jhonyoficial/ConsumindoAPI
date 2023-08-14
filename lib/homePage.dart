import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teste/Post.dart';
import 'package:http/http.dart' as http;

class homePageList extends StatefulWidget {
  const homePageList({super.key});

  @override
  State<homePageList> createState() => _homePageListState();
}

class _homePageListState extends State<homePageList> {

  String urlBase = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> _recuperarPostagens() async {
      http.Response response = await http.get(Uri.parse(urlBase));
      var dadosJson = json.decode(response.body);

      List<Post> listPostagens = [];
      for(var post in dadosJson){
        Post p = Post(post['userId'], post['id'], post['title'], post['body']);
        listPostagens.add(p);
      }

      return listPostagens;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumindo serviços'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot){
          
          switch(snapshot.connectionState){
            case ConnectionState.none :
            case ConnectionState.waiting :
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active :
            case ConnectionState.done :
              if (snapshot.hasError){
                print('lista: erro ao carregar');
                return ListTile();
              }else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){

                    List<Post> ? lista = snapshot.data;
                    Post item =  lista![index];

                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.id.toString()),
                    );


                  }
                );
              }  
          }
        } 
        ),
    );
  }
}