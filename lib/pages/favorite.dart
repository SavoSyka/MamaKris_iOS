import 'dart:math';
import 'package:MamaKris/pages/tinder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/icon.dart';
import 'package:MamaKris/pages/details.dart';
class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}




class _FavoritePageState extends State<FavoritePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 1; // Индекс для отслеживания текущего выбранного элемента


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TinderPage()),
              (_) => false,
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/support');
        break;
    }
  }
  Future<List<DocumentSnapshot>> getLikedJobs() async {
    User? user = _auth.currentUser;
    List<DocumentSnapshot> likedJobs = [];
    if (user != null) {
      var userActionsDoc = await _firestore.collection('userActions').doc(user.uid).get();
      List<dynamic> likedJobsIds = userActionsDoc.data()?['likes'] ?? [];
      for (String jobId in likedJobsIds) {
        var jobDoc = await _firestore.collection('jobs').doc(jobId).get();
        if (jobDoc.exists) {
          likedJobs.add(jobDoc);
        }
      }
    }
    return likedJobs;
  }
  void _viewJobDetails(Map<String, dynamic> jobData) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => JobDetailsPage(jobData: jobData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0ECD3),

        title: const Text('Мои проекты',
          style: TextStyle(fontSize: 25, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFF343434)),
        ),
      ),
      backgroundColor: const Color(0xFFF0ECD3),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: getLikedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Произошла ошибка"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Нет лайкнутых объявлений"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var jobData = snapshot.data![index].data() as Map<String, dynamic>;
                return Padding(
                  padding:  EdgeInsets.only(left: 20*HorizontalMultiply, right: 20*HorizontalMultiply, bottom: 8*VerticalMultiply),
                  child: SizedBox(
                    height: 136*TextMultiply,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10*TextMultiply),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          jobData['title'] ?? 'Без названия',
                          style:  TextStyle(fontSize: 18*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          jobData['description'] ?? 'Без описания',
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(fontSize: 12*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                          maxLines: 2,
                        ),
                        onTap: () =>_viewJobDetails(jobData),


                      //       showModalBottomSheet(
                      //     context: context,
                      //     isScrollControlled: true,
                      //     builder: (context) => FractionallySizedBox(
                      //       heightFactor: 0.8, // Высота модального окна как 50% от высоты экрана
                      //       child: Container(
                      //         padding:  EdgeInsets.all(16*TextMultiply),
                      //         // Удалите width, чтобы Container растягивался на всю ширину экрана
                      //         width: MediaQuery.of(context).size.width,
                      //         decoration:  BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(20*TextMultiply),
                      //             topRight: Radius.circular(20*TextMultiply),
                      //           ),
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //              SizedBox(height: 10*TextMultiply),
                      //             Center( // Добавляем Center для центрирования текста
                      //               child: Text(
                      //                 jobData['contactLink'] ?? 'Нет контактов',
                      //                 style: const TextStyle(fontSize: 30, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),
                      //                 textAlign: TextAlign.center, // Центрируем текст внутри Text виджета
                      //               ),
                      //             ),
                      //              SizedBox(height: 20*TextMultiply),
                      //             Expanded(
                      //               child: SingleChildScrollView(
                      //                 child: Column(
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //
                      //                     Text(
                      //
                      //                       jobData['title'] ?? 'Без названия',
                      //                       style:  TextStyle(fontSize: 22*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                      //                     ),
                      //                     const SizedBox(height: 10),
                      //
                      //                     Text(
                      //                       jobData['description'] ?? 'Без описания',
                      //                       style:  TextStyle(fontSize: 18*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/main.svg'),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: DoubleIcon(
              bottomIconAsset: 'images/icons/projects-bg.svg',
              topIconAsset: 'images/icons/projects.svg',
            ),            label: 'Проекты',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/profile.svg'),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/support.svg',
            ),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Цвет выбранного элемента
        unselectedItemColor: Colors.black, // Цвет не выбранного элемента
        onTap: _onItemTapped,
      ),
    );
  }
}
