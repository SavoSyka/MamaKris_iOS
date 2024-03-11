import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        Navigator.pushNamed(context, '/tinder');
        break;
      case 1:
        Navigator.pushNamed(context, '/projects');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushNamed(context, '/support');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAEE),

        title: const Text('Мои проекты',
          style: TextStyle(fontSize: 25, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFF343434)),
        ),
      ),
      backgroundColor: const Color(0xFFFCFAEE),
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
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 120,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          jobData['title'] ?? 'Без названия',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          jobData['description'] ?? 'Без описания',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => FractionallySizedBox(
                            heightFactor: 0.8, // Высота модального окна как 50% от высоты экрана
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              // Удалите width, чтобы Container растягивался на всю ширину экрана
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Center( // Добавляем Center для центрирования текста
                                    child: Text(
                                      jobData['contactLink'] ?? 'Нет контактов',
                                      style: const TextStyle(fontSize: 30, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),
                                      textAlign: TextAlign.center, // Центрируем текст внутри Text виджета
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text(

                                            jobData['title'] ?? 'Без названия',
                                            style: const TextStyle(fontSize: 22, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                                          ),
                                          const SizedBox(height: 10),

                                          Text(
                                            jobData['description'] ?? 'Без описания',
                                            style: const TextStyle(fontSize: 18, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ),),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),


  bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_sharp),
            label: 'Проекты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF93D56F),
        unselectedItemColor: Colors.grey, // Цвет неактивных элементов+
        onTap: _onItemTapped,
      ),
    );
  }
}
