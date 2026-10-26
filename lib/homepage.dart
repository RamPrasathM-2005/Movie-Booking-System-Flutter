import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/detail_page.dart';
import 'package:movie_booking_app/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> movies = [
    {
      "name": "Infinity Wars",
      "type": "Action, Adventure",
      "desc":
          "Infinity War is a Marvel superhero film where the Avengers and their allies battle Thanos, who seeks to collect all six Infinity Stones to wipe out half of all life. The movie features action, emotion, and shocking consequences as heroes from across the universe.",
      "poster": "images/infinity.jpg"
    },
    {
      "name": "Pushpa 2",
      "type": "Action, Emotion",
      "desc":
          "The Rise, starring Allu Arjun. The film continues Pushpa Raj's journey as he faces new challenges and rivalries in the red sandalwood smuggling world. With intense action, powerful dialogues, and stylish performances, the movie promises to be even bigger and bolder.",
      "poster": "images/pushpa.jpg"
    },
    {
      "name": "Jailer",
      "type": "Action, Thriller",
      "desc":
          "A retired jailer returns to face a new threat, blending mass action with sharp emotions and swagger.",
      "poster": "https://upload.wikimedia.org/wikipedia/en/thumb/c/cb/Jailer_2023_Tamil_film_poster.jpg/250px-Jailer_2023_Tamil_film_poster.jpg"
    },
    {
      "name": "Vikram",
      "type": "Action, Crime",
      "desc":
          "A black-ops story that unites legends against a powerful drug syndicate, packed with gritty action.",
      "poster": "https://upload.wikimedia.org/wikipedia/en/9/93/Vikram_2022_poster.jpg"
    },
    {
      "name": "Leo",
      "type": "Action, Mystery",
      "desc":
          "A quiet café owner’s past resurfaces, pulling him into a violent world he wants to escape.",
      "poster": "https://upload.wikimedia.org/wikipedia/en/7/75/Leo_%282023_Indian_film%29.jpg"
    },
    {
      "name": "Master",
      "type": "Action, Drama",
      "desc":
          "A professor is sent to reform juvenile inmates, but a dangerous gang leader complicates everything.",
      "poster": "https://upload.wikimedia.org/wikipedia/en/5/53/Master_2021_poster.jpg"
    },
    {
      "name": "Soorarai Pottru",
      "type": "Drama, Biography",
      "desc":
          "A dreamer challenges the aviation industry to make air travel affordable for everyone.",
      "poster": "https://upload.wikimedia.org/wikipedia/en/thumb/6/61/Soorarai_Pottru.JPG/250px-Soorarai_Pottru.JPG"
    },
    {
      "name": "Jawan",
      "type": "Action, Thriller",
      "desc":
          "A high-energy action thriller with themes of justice and identity, blending explosive set pieces with emotional depth.",
      "poster": "images/shahrukhmovies.png"
    },
    {
      "name": "Tiger 3",
      "type": "Action, Spy",
      "desc":
          "A fast-paced spy adventure that follows a legendary agent through international threats and personal stakes.",
      "poster": "images/salman.jpg"
    },
    {
      "name": "Interstellar",
      "type": "Sci-Fi, Drama",
      "desc":
          "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival, combining science with an emotional family story.",
      "poster": "images/infinity.jpg"
    },
    {
      "name": "Dune",
      "type": "Sci-Fi, Adventure",
      "desc":
          "A sweeping epic of politics, prophecy, and survival on the desert planet Arrakis, home to the most valuable resource in the universe.",
      "poster": "images/shahrukhmovies.png"
    },
  ];
  String? id,name,email,image;

  Widget _posterImage(String path){
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.black12,
            child: Center(
              child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
            ),
          );
        },
      );
    }
    return Image.asset(path, fit: BoxFit.cover);
  }

  getthesharedpref()async{
    id =await SharedpreferenceHelper().getUserId();
    name =await SharedpreferenceHelper().getNameId();
    email=await SharedpreferenceHelper().getEmailId();
    image=await SharedpreferenceHelper().getImageId();
    setState(() {

    });
  }
  @override
  void initState(){
    getthesharedpref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: name==null?Center(child: CircularProgressIndicator()):Container(
        margin: EdgeInsets.only(top: 30.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("images/wave.png",
                    height: 50, width: 50, fit: BoxFit.cover),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Hello, "+name!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        image!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Welcome To,",
                style: TextStyle(
                    color: Color.fromARGB(186, 255, 255, 255),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500)),
            Row(
              children: [
                Text(
                  "Filmy",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "Fun",
                  style: TextStyle(
                      color: Color(0xffedb41d),
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: 20.0,),
            Center(
              child: CarouselSlider(items: movies.map((movie){
                return Builder(builder: ( context){
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: _posterImage(movie["poster"]!)));
                });
              }).toList(), options: CarouselOptions(
                height: 270,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16/9,
                viewportFraction: 1.0
              )),
            ),
            SizedBox(height: 30.0,),
            Text(
              "Top Trending Movies",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30.0,),
            Container(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context)=>DetailPage(
                                moviename: movie["name"]!,
                                movietype: movie["type"]!,
                                moviedesc: movie["desc"]!,
                                movieposter: movie["poster"]!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color:Colors.white),borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                  child: SizedBox(
                                    height: 220,
                                    width: 220,
                                    child: _posterImage(movie["poster"]!),
                                  )),

                              Container(
                                padding: EdgeInsets.only(left:10.0),
                                margin:EdgeInsets.only(top:180),
                                width: 220,
                                decoration: BoxDecoration(color: Colors.black45,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(movie["name"]!,style: TextStyle(color: Colors.white,fontSize: 22.0,fontWeight: FontWeight.bold),),
                                    Text(movie["type"]!,style: TextStyle(color: Color.fromARGB(173, 255, 255, 255),fontSize: 16.0,fontWeight: FontWeight.w500),),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width:20.0),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
