import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight/Screens/home.dart';

class FirstRunScreen extends StatefulWidget {
  const FirstRunScreen({super.key});

  @override
  _FirstRunScreenState createState() => _FirstRunScreenState();
}

class _FirstRunScreenState extends State<FirstRunScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _savedName;
  @override
  void initState() {
    super.initState();
    _loadName(); 
  }

  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('userName'); 
    });
  }

  Future<void> _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text); 
    _loadName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              if (_savedName == null) ...[
                Lottie.asset('assets/hi.json'),
                const Text(
                'Welcome to Weight Tracker!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please enter your name to get started.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _saveName,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), 
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(155, 155, 155, 110),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(50, 0, 0, 0), 
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Save Name',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                        ),
                      ),
                    ),
                  ),
                )
              ]else ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    Lottie.asset('assets/weight.json'),
                    const SizedBox(height: 20),
                    const Text(
                      'Let\'s Get Started!', 
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), 
                    Center(
                      child: Text(
                        'Hello, $_savedName!',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 20), 
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WeightHomePage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), 
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(155, 155, 155, 110),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(50, 0, 0, 0), 
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Let\'s Continue',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],

          
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
