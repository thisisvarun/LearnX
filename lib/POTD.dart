import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class POTD extends StatefulWidget{
  const POTD({super.key});
  @override
  State<POTD> createState() => _POTDState();
}
class _POTDState extends State<POTD>{
  Container Question(double wi,String que){
    return Container(
      width: wi,
      padding: EdgeInsets.all(wi*0.08),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
      ),
      child: Text(
        que,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: wi*0.06,
            )
        ),
      ),
    );
  }

  Container Option(int i,double wi,String s){
    return Container(
      width: wi,
      padding: EdgeInsets.all(wi*0.05),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white
      ),
      child: Text(
        s,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: wi*0.05,
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            SizedBox(
              width: wi,
              height: hi,
              child: Image(
                image: AssetImage('assets/images/potdbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            ListView(
              padding: EdgeInsets.all(wi*0.05),
              children: [
                SizedBox(height: hi*0.1,),
                Question(wi*0.9,'What is the name of the First Programming Language ? '),
                SizedBox(height: hi*0.015),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context,int ind){
                    return Option(ind+1,wi,'option');
                  },
                  separatorBuilder: (BuildContext context,int ind){
                    return SizedBox(height: hi*0.015);
                  },
                    itemCount: 4
                )
              ],
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.chevron_left_circle_fill,
                size: 40,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      )
    );
  }
}