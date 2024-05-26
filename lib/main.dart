import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MathGameApp());
}

class MathGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Poppins"),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => GameMenuPage(name: emailController.text)),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content:
              Text("Failed to sign in. Please check your email and password."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.png'),
                    fit: BoxFit.fill),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 130),
                      child: Center(
                        child: Column(
                          children: [
                            Text("Welcome to",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                            Text("MATHPUZZLE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff1d1617).withOpacity(0.11),
                                blurRadius: 40,
                                spreadRadius: 0.0)
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email Address',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              obscureText: true,
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20.0),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => signIn(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(132, 138, 242, 1),
                            Color.fromRGBO(132, 138, 242, .6),
                          ]),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Create one.",
                          style: TextStyle(
                            color: Color.fromRGBO(132, 138, 242, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        await userCredential.user!.updateDisplayName(nameController.text);
        await userCredential.user!.reload();
        User? updatedUser = FirebaseAuth.instance.currentUser;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GameMenuPage(name: updatedUser!.displayName ?? 'User'),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('The passwords do not match.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create an account',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(132, 138, 242, 1),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 40, right: 40),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0),
          ]),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your username",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your Email",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: "Confirm your password",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => signUp(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(132, 138, 242, 1),
                        Color.fromRGBO(132, 138, 242, .6),
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameMenuPage extends StatefulWidget {
  final String name;

  GameMenuPage({required this.name});

  @override
  _GameMenuPageState createState() => _GameMenuPageState();
}

class _GameMenuPageState extends State<GameMenuPage> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playLocal();
  }

  void playLocal() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource('music_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Main Menu',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(132, 138, 242, 1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello, ${widget.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => GamePage())),
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(132, 138, 242, 1),
                      Color.fromRGBO(132, 138, 242, .6),
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage())),
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(132, 138, 242, 1),
                      Color.fromRGBO(132, 138, 242, .6),
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // audioPlayer.dispose();
    super.dispose();
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int remainingAttempts = 3;
  int currentLevel = 1;
  int score = 0;
  List<Question> questions = [
    Question('What is the result of 2 + 2?', ['3', '4', '5', '6'], 1),
    Question('What is the result of 10 - 5?', ['3', '4', '5', '6'], 2),
    Question('What is the result of 2 * 4?', ['10', '8', '6', '1'], 3),
    Question('What is the result of 24 / 2?', ['4', '13', '11', '12'], 4),
    Question('What is the result of 5 + (24 / 2)?', ['9', '13', '11', '17'], 5),
    Question('What is the result of (5 + 9) / 2 ?', ['3', '7', '14', '9'], 6),
    Question('What is the result of (10 / 2) + 5?', ['16', '13', '6', '10'], 7),
    Question('What is the result of 4 + 3?', ['6', '7', '8', '9'], 8),
    Question('What is the result of 15 - 7?', ['6', '7', '8', '9'], 9),
    Question('What is the result of 3 * 3?', ['6', '7', '8', '9'], 10),
    Question('What is the result of 28 / 4?', ['6', '7', '8', '9'], 11),
    Question(
        'What is the result of 10 + (28 / 4)?', ['13', '14', '15', '16'], 12),
    Question(
        'What is the result of (10 + 14) / 2 ?', ['12', '13', '14', '15'], 13),
    Question(
        'What is the result of (20 / 2) + 7?', ['12', '13', '14', '15'], 14),
    Question('What is the result of 2 + 5?', ['6', '7', '8', '9'], 15),
  ];

  void handleAnswer(int selectedAnswerIndex) {
    if (questions[currentLevel - 1].correctAnswerIndex == selectedAnswerIndex) {
      setState(() {
        score += 1;
      });

      if (currentLevel == questions.length) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Ended!'),
              content: Text('You Finished All Rounds. Score: $score'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Correct Answer!'),
              content: Text(
                  'Good Job! You Can Continue to the Next Round. Score:$score'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentLevel++;
                      remainingAttempts = 3;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Next'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        remainingAttempts--;
      });

      if (remainingAttempts == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Wrong Answer!'),
              content: Text("Don't worry, you can try again!. Score:$score"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentLevel = 1;
                      score = 0;
                      remainingAttempts = 3;
                    });
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Wrong Answer!'),
              content: Text(
                  "You didn't get the answer, you have $remainingAttempts attempt(s) remaining"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Round $currentLevel',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(132, 138, 242, 1),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ScoreBar(currentLevel: currentLevel, score: score),
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('images/character_cat.png')),
                    Text(
                      questions[currentLevel - 1].questionText,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 20.0),
                    ...questions[currentLevel - 1]
                        .choices
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      String val = entry.value;
                      return ElevatedButton(
                        onPressed: () => handleAnswer(idx),
                        child: Text(val),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  final int currentLevel;
  final int score;

  ScoreBar({required this.currentLevel, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(132, 138, 242, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Score: $score',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  String questionText;
  List<String> choices;
  int correctAnswerIndex;

  Question(this.questionText, this.choices, this.correctAnswerIndex);
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(132, 138, 242, 1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Audio Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Turn music On/Off'),
              value: true,
              onChanged: (bool value) {},
            ),
            const Divider(),
            const Text(
              'Change Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmail(),
                  ),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(132, 138, 242, 1),
                      Color.fromRGBO(132, 138, 242, .6),
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      'Change Your Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNameDialog(),
                  ),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(132, 138, 242, 1),
                      Color.fromRGBO(132, 138, 242, .6),
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      'Change Your Username',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(132, 138, 242, 1),
                      Color.fromRGBO(132, 138, 242, .6),
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      'Change Your Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeEmail extends StatelessWidget {
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(132, 138, 242, 1),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30, left: 30, right: 30),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0),
          ]),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: currentEmailController,
                decoration: InputDecoration(
                  hintText: "Enter your current email",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: newEmailController,
                decoration: InputDecoration(
                  hintText: "Enter your new email",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmEmailController,
                decoration: InputDecoration(
                  hintText: "Confirm your new email",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    String currentEmail = currentEmailController.text;
                    String newEmail = newEmailController.text;
                    String confirmEmail = confirmEmailController.text;
                    String password = passwordController.text;

                    currentEmailController.clear();
                    newEmailController.clear();
                    confirmEmailController.clear();
                    passwordController.clear();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(132, 138, 242, 1),
                        Color.fromRGBO(132, 138, 242, .6),
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        'Change your email',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(132, 138, 242, 1),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 40, right: 40),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0),
          ]),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Old Password ",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter New Password",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
                  hintStyle: TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(height: 20.0),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => const Text('تأكيد التغيير'),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(132, 138, 242, 1),
                        Color.fromRGBO(132, 138, 242, .6),
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        'Confirm Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeNameDialog extends StatelessWidget {
  final TextEditingController newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chnage Username'),
      content: TextField(
        controller: newNameController,
        decoration: const InputDecoration(
          labelText: 'New Username',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String newUserName = newNameController.text;
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
