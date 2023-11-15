import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'POTD.dart';
import 'SelectedCourse.dart';
import 'HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// final DocumentReference dbU = FirebaseFirestore.instance.collection('Users').get();
final CollectionReference dbE = FirebaseFirestore.instance.collection('Courses');

class ExplorePage extends StatefulWidget{
  const ExplorePage({super.key});
  @override
  State<ExplorePage> createState() => ExploreState();
}
class ExploreState extends State<ExplorePage>{
  final Color themeblue = const Color.fromARGB(255, 60, 84, 127);
  final Color themegreen = const Color.fromARGB(255, 66, 146, 130);
  Text makeText(String s){
    return Text(
      s,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 17,
          )
      ),
    );
  }
  String process(String s){
    String res = "";
    for (int i=0; i<s.length; i++){
      if (s[i]==' '){
        res+='\n';
      }
      else{
        res+=s[i];
      }
    }
    return res;
  }
  Card Course(double wi,double hi,String cname,Color c){
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: wi,
        height: hi,
        padding: EdgeInsets.all(wi*0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: c,
        ),
        child: Text(
          process(cname),
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: hi*0.09,
              )
          ),
        ),
      ),
    );
  }

  Future<Column> Category(double wi, double hi, String catname, List<String> cc) async {
    List<Widget> courseWidgets = [];
    for (String courseId in cc) {
      DocumentSnapshot docSnapshot = await dbE.doc(courseId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> curC = docSnapshot.data() as Map<String, dynamic>;
        Color curCol = Color.fromARGB(
          curC['color']['a'],
          curC['color']['r'],
          curC['color']['g'],
          curC['color']['b'],
        );
        courseWidgets.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,MaterialPageRoute(builder: (context) => SelectedCourse(cname: curC['courseName'], cc: curCol)),
              );
            },
            child: Course(wi * 0.4, wi * 0.4, curC['courseName'], curCol),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: hi * 0.03,),
        Text(
          catname,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: hi * 0.028,
            ),
          ),
        ),
        SizedBox(height: wi * 0.01,),
        Container(
          width: wi,
          height: hi * 0.24,
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: hi * 0.02),
            scrollDirection: Axis.horizontal,
            itemCount: courseWidgets.length,
            separatorBuilder: (BuildContext context, int ind) {
              return SizedBox(width: wi * 0.02,);
            },
            itemBuilder: (BuildContext context, int ind) {
              return courseWidgets[ind];
            },
          ),
        ),
      ],
    );
  }

  Card potdBox(double wi,double hi){
    return Card(
      elevation: 15,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: wi,
        height: hi,
        padding: EdgeInsets.all(hi*0.08),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            SizedBox(
              width: wi,
              height: hi*0.12,
              child: Text(
                "Solve Today's Challenge",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeblue,
                      fontSize: hi*0.075,
                    )
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  'assets/images/potd.svg',
                  height: hi*0.65,
                  fit: BoxFit.cover,
                  // height: hi,
                ),
                ElevatedButton(
                  onPressed: (){},
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(themegreen),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                      )
                    ),
                    elevation: MaterialStatePropertyAll(15)
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>POTD())
                      );
                    },
                    child: Text(
                      "Solve Now",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: wi*0.05,
                          )
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }

  Center loading(double wi,double hi){
    return Center(
      child: SizedBox(
        width: wi*0.2,
        height: wi*0.2,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<List<String>> fetchData(String catName) async {
    List<String> cc = [];
    for (int i = 0; i < cid.length; i++) {
      DocumentReference docRef = dbE.doc(cid[i]);
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists && docSnapshot['category'] == catName) {
        cc.add(cid[i]);
      }
    }
    return cc;
  }

  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(hi*0.02),
          scrollDirection: Axis.vertical,
          children: [
            Text(
              "Welcome back!",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: hi*0.03,
                  )
              ),
            ),
            SizedBox(height: hi*0.02,),
            potdBox(wi*0.8,wi*0.7),
            FutureBuilder<List<String>>(
              future: fetchData('programming'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loading(wi, hi);
                } else if (snapshot.hasError) {
                  return Text('Error 1: ${snapshot.error}');
                } else {
                  List<String> cc = snapshot.data ?? [];
                  return FutureBuilder<Column>(
                    future: Category(wi, hi, "Programming", cc),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState == ConnectionState.waiting) {
                        return loading(wi, hi);
                      } else if (snapshot2.hasError) {
                        return Center(
                          child: SizedBox(
                            width: wi,
                            height: hi*0.1,
                            child: Text(
                              "No Courses",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  fontSize: hi * 0.025,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return snapshot2.data as Column;
                      }
                    },
                  );

                }
              },
            )
          ],
        ),
      ),
    );
  }
}