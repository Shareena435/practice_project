
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Realtimedatabase extends StatefulWidget {
  const Realtimedatabase({super.key});

  @override
  State<Realtimedatabase> createState() => _RealtimedatabaseState();
}

class _RealtimedatabaseState extends State<Realtimedatabase> {
  TextEditingController namecontroller=TextEditingController();
  TextEditingController agecontroller=TextEditingController();
  TextEditingController educontroller=TextEditingController();
  late final DatabaseReference Studentsreference;
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    final Database=FirebaseDatabase.instanceFor(app: Firebase.app(),
    databaseURL: 'https://practiceproject-ee047-default-rtdb.firebaseio.com/'
    );
    Studentsreference=Database.ref('Details');
  }
  
  Future<void>Addstudent()async{
    await Studentsreference.push().set(
      {
        'Name':namecontroller.text.trim(),
        'Age':agecontroller.text.trim(),
        'Education':educontroller.text.trim(),
      }
    );
    namecontroller.clear();
    agecontroller.clear();
    educontroller.clear();
  }
  // Future<void>Update(String key)async{
    
  //   await Studentsreference.child(key).update({
     

      

  //   });
    
  // }
  Future<void>Deletestudent(String key)async{
    await Studentsreference.child(key).remove();
  }
  Future<void>Confirmupdate(
    String key,
    String name,
    String age,
    String education,
    
  )async{
    await Studentsreference.child(key).update({
            'Name':name,
             'Age':age,
              'Education':education,
    });

  }
 Future<void>UpdateStudent(String key, String Name,String?age,String ? education)async{
  
    TextEditingController editnamecontroller=TextEditingController(text: Name);
     TextEditingController editagecontroller=TextEditingController(text: age??'');
      TextEditingController editEducontrolller=TextEditingController(text: education??'');

       await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Edit details'),
        content:SingleChildScrollView(
          child: Column(
            children: [
                TextFormField(
               
                  controller:editnamecontroller ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',

                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                 
                  controller:editagecontroller ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Age',

                  ),
                ),
                 SizedBox(height: 10,),
                TextFormField(
                  
                  controller:editEducontrolller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Education',

                  ),
                ),
                
            ],
          ),
        ) ,
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text('Cancel')),
          ElevatedButton(onPressed: ()async {
            await Confirmupdate(key,
             editnamecontroller.text.trim(),
              editagecontroller.text.trim(),
               editEducontrolller.text.trim(),
            );
            Navigator.pop(context);
          }, child: Text('Ok'))
        ],
      );
   
    });
  }

 
  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
     backgroundColor: const Color(0xffFFF7ED),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double horizontalpadding=screenWidth * 0.06; 
             double steamwidth=constraints.minWidth;
          
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: horizontalpadding,
              vertical: 62
            ),
            child: Column(
              children: [
                Text('Add Your Details',
                style: TextStyle(
                  color: const Color.fromARGB(255, 5, 32, 54),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ),),
                SizedBox(height: 20,),
                TextFormField(
                  
                  controller: namecontroller,
                  decoration: InputDecoration(
                     filled: true,
                     fillColor: const Color.fromARGB(255, 237, 244, 228),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Name',
                  ),
                ),
                SizedBox(height: 15,),
                 TextFormField(
                  controller: agecontroller,
                  decoration: InputDecoration(
                    filled: true,
                     fillColor: const Color.fromARGB(255, 237, 244, 228),
                     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Age',
                  ),
                ),
                SizedBox(height: 15,),
                 TextFormField(
                  controller: educontroller,
                  decoration: InputDecoration(
                    filled: true,
                     fillColor: const Color.fromARGB(255, 237, 244, 228),
                   border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Education',
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  

                
                    height:40,
                    width:200,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 17, 66, 72),
                         borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                   
                    child: TextButton(
                     
                      onPressed: () {
                        Addstudent();
                      
                    }, child: Text('Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),)),
                  ),

                
                 const SizedBox(height: 20,),
                Expanded(child: StreamBuilder(stream: Studentsreference.onValue, builder:(context, snapshot) {
                  if(snapshot.hasError){
                    return const Center(
                      child: Text('Something Wrong'),
                    );
                  }
                    final event =snapshot.data;
                    if(event==null || event.snapshot.value==null){

                    
                    return const Center(
                      child: Text('No data Found'),
                    );
                    }
                    final student=event.snapshot.children.toList();
                    return ListView.builder( 
                      itemCount: student.length,
                      itemBuilder: (context, index) {
                        final students=student[
                          index
                        ];
                       final Key=students.key!;
                        final Name=students.child('Name').value.toString();

                        final age=students.child('Age').value?.toString();
                        final education=students.child('Education').value?.toString();
                        return Card(
                          elevation: 3,
                          shadowColor: Colors.red,
                          color: const Color.fromARGB(255, 215, 229, 240),
                          child: ListTile(
                            title: Text(Name),
                            subtitle: Text('Age: $age,   Edu: $education' ),
                            trailing:Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                               IconButton(onPressed: () {
                                       
                                 UpdateStudent(Key,Name,age,education);

                               }, icon:Icon(Icons.edit),color: const Color.fromARGB(255, 109, 204, 112),),
                                IconButton(onPressed: () {
                                  showDialog(context: context, builder:(context){
                                      return  AlertDialog(
                                             
                                           content: Text('Are you sure you want to delete this item'),

                                           actions: [
                                            TextButton(onPressed: () {
                                              Navigator.pop(context);
                                            }, child: Text('Ok'))
                                           ],
                                      );
                                  }
                                  );
                                  Deletestudent(Key);
                                  
                                }, icon: Icon(Icons.delete),
                                color: const Color.fromARGB(255, 35, 70, 99)
                              // color: Colors.red,
                                )
                              ],
                            ),

                          ),
                        );
                      
                    },);
                  
                }, ))
              ],
            ),
          
          );
          }
        ),
      ),
    );
  }
}