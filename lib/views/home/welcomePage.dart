import 'package:flutter/material.dart';
import 'package:masterreads/main.dart';
import 'package:masterreads/routes/routes.dart';
import 'package:masterreads/views/login/login_screen.dart';
// import 'package:blur/blur.dart';
class welcomePage extends StatelessWidget {
  const welcomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(



      body:Container(

        // Blur(
        //   blur: 2.5,
        //   blurColor: Theme.of(context).primaryColor,
        //   child: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Text(
        //       'Blur',
        //       style: Theme.of(context).textTheme.headline3,
        //     ),
        //   ),
        // ),
          width: double.infinity,
          decoration:  BoxDecoration(



            image: DecorationImage(
                image: AssetImage("assets/images/images.jpeg"),

                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
                // opacity:0.9,

                fit: BoxFit.cover),
          ),
          child:Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin:EdgeInsets.fromLTRB(5, 60, 0, 0),
                padding:EdgeInsets.all(10.0),
                color: Colors.deepPurple[50],
                child:Text("MASTER E-READS",
                    style: TextStyle(fontSize: 40)),
              ),


              Container(
                // color:Colors.black,
                padding: EdgeInsets.all(5.0),
                margin:EdgeInsets.fromLTRB(10.0, 20.0, 5, 100),
                child:Text("The library brought to your home. \n\t Grab a cup of coffee and enjoy \n\tour online reading services",
                    style:TextStyle(
                        color:Colors.white,
                        fontSize: 18,
                        fontWeight:FontWeight.bold)),
              ),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment:Alignment.bottomCenter,
                  child: SizedBox(

                    width:double.infinity,
                    child: ElevatedButton(onPressed: (
                        ){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(title: "Log in"),
                        ),
                      );
                    },


                      child:Text(
                          "Login",
                          style:TextStyle(color:Colors.white)
                      ),
                    ),


                  ),
                ),
              ),





            ],
          )

        // children:[
        //   Expanded(
        //     flex:2,
        //   child:Image(
        //     width:double.maxFinite,
        //     image:AssetImage("assets/images/welcomepage.jpeg"),
        //     fit:BoxFit.cover,
        //
        //    ),
        //   ),
        //
        //
        // ],
      ),

      // body:Center(
      //   child:Text("You are beautiful",
      //       style: TextStyle
      //         ( fontWeight: FontWeight.bold,
      //         letterSpacing: 2.0,)
      //   ),
      //
      // ),

    );
  }
}


