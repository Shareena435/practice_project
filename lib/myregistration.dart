import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_project/classAuthservice.dart';
import 'package:intl/intl.dart';

import 'package:practice_project/loginscreen.dart';

class Myregistration extends StatefulWidget {
  const Myregistration({super.key});


  @override
  State<Myregistration> createState() => _MyregistrationState();
}

class _MyregistrationState extends State<Myregistration> {
  TextEditingController namecontroller=TextEditingController();
   TextEditingController emailcontroller=TextEditingController();
   TextEditingController passwordcontroller=TextEditingController();
  TextEditingController confirmcontroller=TextEditingController();
   TextEditingController birthdatecontroller=TextEditingController();

   String ?errormessage='';
   bool _isLoading=false;
   bool num1=false;
    final _formKey = GlobalKey<FormState>();
    
   Future<void>Myregistration()async{
    
    setState(() {
      errormessage=null;
      _isLoading=true;
    });
    try{
      final email=emailcontroller.text.trim();
      final password=passwordcontroller.text.trim();
      if(passwordcontroller.text.trim()==confirmcontroller.text.trim()){
      final credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      
      final uid=credential.user!.uid;
      
      await FirebaseFirestore.instance.collection('mystudent').doc(uid).set({
        'uid':uid,
        'name':namecontroller.text.trim(),
         'email':emailcontroller.text.trim(),
         
            'year':birthdatecontroller.text.trim(),
      
      });
      }
      //if(confirmcontroller.text.trim().isEmpty){
     
      //   errormessage='Confirm Your Password';
        
      // }
      else{
       setState(() {
         
         errormessage='password do not Match';
       });
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('password do not Match'))
       );
       
      }

      
    }on  FormatException {
      setState(() => errormessage = 'Please enter a valid age');
    } catch (e) {
      setState(() => errormessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    

   }
   @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmcontroller.dispose();
    birthdatecontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 226, 223),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 77, horizontal: 24),
        child:SingleChildScrollView(
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create You Account',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20,),
              Text('Full Name'),
              SizedBox(height: 5,),
              TextFormField(
                 validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Name is required';
                        }},
                controller: namecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                  hintText: 'Enter Your Full Name',
                  prefixIcon: Icon(Icons.person_outline)
                ),
              ),
              SizedBox(height: 10,),
              Text('Email'),
              SizedBox(height: 5,),
              TextFormField(
                validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Email is required';
                        }},
                controller: emailcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                  hintText: 'Enter Your email',
                  prefixIcon: Icon(Icons.email_outlined)
                ),
              ),
              SizedBox(height: 10,),
              Text('Password'),
              SizedBox(height: 5,),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one number';
                      }
            
                  },
                controller: passwordcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                  hintText: 'Enter Your password',
                  prefixIcon: Icon(Icons.lock_outline)
                ),
              ),
              SizedBox(height: 10,),
              Text('Confirm Password'),
              SizedBox(height: 5,),
              TextFormField(
                controller: confirmcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                  hintText: 'Confirm Your Password',
                  prefixIcon: Icon(Icons.lock_outline)
                ),
              ),
              SizedBox(height: 10,),
              Text('Date Of Bith'),
              SizedBox(height: 5,),
              TextFormField(
                 validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Date of Birth is required';
                        }},
                controller: birthdatecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    
                  ),
                  hintText: 'Enter Date of Birth',
                  prefixIcon:IconButton(onPressed: ()async {
                     final Date=  await showDatePicker(context: context, firstDate: DateTime(1900), lastDate:DateTime.now(),initialDate: DateTime(2004));
                   
                   if (Date != null) {
                   birthdatecontroller.text = DateFormat('dd-MM-yyyy').format(Date);
                   }
                  }, icon: Icon(Icons.calendar_today_outlined))
                ),
              ),
              SizedBox(height: 15,),
                CheckboxListTile( 
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                 activeColor:  const Color.fromARGB(255, 232, 226, 223),
                // fillColor: WidgetStatePropertyAll(Colors.white),// background color
                  checkColor: Colors.black,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: -4),
                   title: Text('I agree to the Terms of Service and Privacy Policy',
                style: TextStyle(
                  fontSize: 13
                ),), value: num1, onChanged: (value) {
             if (value != null) {
             setState(() {

               num1=value;
             });
             }
             
           },
           controlAffinity:ListTileControlAffinity.leading ,),
              SizedBox(height: 15,),
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: const Color.fromARGB(255, 90, 32, 190)
                ),
                child: TextButton(onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                     if(num1==true){
                  
          
                  print('Button Clicked');
                 await Myregistration();
                 print('After registration');
                 print('Error:$errormessage');
                 if(errormessage==null){
                  print('Navigation to loginpage');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Loginpage(),));
                 }
                    }}
                  
                }, 
                child: _isLoading
    ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
    : const Text(
        'Create Account',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
                // child: Text('Create Account',
                // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                // color: Colors.white),
                // ),
                )),
                 SizedBox(height: 32,),
                
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        
                        color: Color(0xff8D8585),
                         endIndent: 10,
                      ),
                    ),
                    Text('or Sign in with'),
                    Expanded(
                      child: Divider(
                        color: Color(0xff8D8585),
                        indent: 10,
                      ),
                    ),
          
                  ],
                ),
                SizedBox(height: 14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    InkWell(
                      onTap: ()async {
                        await GoogleAuthService.signinWithGoogle();
                      },
                      child: Image.asset('assets/images/Component 4.png',
                      height: 24,
                      width: 23.5,
                      color: Color(0xff000000),),
                    ),
                    SizedBox(width: 20,),
                    Image.asset('assets/images/Component 5.png',
                      height: 24,
                    width: 24.15,
                    color: Color(0xff000000)),
                     SizedBox(width: 22.22,),
                    Image.asset('assets/images/Vector.png',
                      height: 24,
                    width: 19.55,
                    color: Color(0xff000000)),
                  ],
                ),
              
            ],
          ),
                ),
        ),
      )
    );
  }
}
