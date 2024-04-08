import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:MamaKris/wave.dart';
import 'package:MamaKris/icon.dart';
import 'package:MamaKris/pages/subscription.dart';

class TinderPage extends StatefulWidget {
  @override
  TinderPageState createState() => TinderPageState();
}


class TinderPageState extends State<TinderPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _likedJobsIds = [];
  List<String> _dislikedJobsIds = [];
  DocumentSnapshot? _randomJob;
  int _selectedIndex = 0; // Индекс для отслеживания текущего выбранного элемента
  bool _isLoading = true; // Индикатор загрузки


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(index) {
      case 0:
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


  @override
  void initState() {
    super.initState();
    _loadActionsAndFetchRandomJob();
  }

  Future<void> _loadActionsAndFetchRandomJob() async {
    await _loadActionsIds();
    await _fetchRandomJob();
  }

  Future<void> _loadActionsIds() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final docSnapshot = await _firestore.collection('userActions').doc(user.uid).get();
      if (docSnapshot.exists) {
        setState(() {
          _likedJobsIds = List.from(docSnapshot.data()?['likes'] ?? []);
          _dislikedJobsIds = List.from(docSnapshot.data()?['dislikes'] ?? []);
        });
      }
    }
  }

  Future<void> _markJobAsLiked(String jobId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('userActions').doc(user.uid).set({
        'likes': FieldValue.arrayUnion([jobId])
      }, SetOptions(merge: true));
      _likedJobsIds.add(jobId);
    }
  }

  Future<void> _markJobAsDisliked(String jobId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('userActions').doc(user.uid).set({
        'dislikes': FieldValue.arrayUnion([jobId])
      }, SetOptions(merge: true));
      _dislikedJobsIds.add(jobId);
    }
  }

  Future<void> _updateViewedAdsCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Получаем текущее количество просмотров
      final docSnapshot = await _firestore.collection('jobSearches').doc(user.uid).get();
      int currentCount = docSnapshot.data()?['viewedAdsCount'] ?? 0;
      // Увеличиваем счетчик на 1
      await _firestore.collection('jobSearches').doc(user.uid).set({
        'viewedAdsCount': currentCount + 1,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _fetchRandomJob() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('jobSearches')
          .doc(user.uid)
          .get();
      bool hasSubscription = userDoc.data()?['hasSubscription'] ?? false;
      int viewedAdsCount = userDoc.data()?['viewedAdsCount'] ?? 0;

      if (!hasSubscription && viewedAdsCount >= 3) {
        print(userDoc.data()?['hasSubscription']);
        print(userDoc.data()?['employerId']);

        // Показываем диалог о необходимости подписки
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SubscriptionPage()), // Замените SubscribePage() на страницу, на которую хотите перейти
              (_) => false,
        );
        ();
        return;
      }
      final querySnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where(
          'status', isEqualTo: 'approved') // Фильтр по статусу 'approved'

      // .where('jobType', isEqualTo: 'desiredJobType') // Условие для jobType
      // .where('sphere', isEqualTo: 'desiredSphere') // Условие для sphere
          .get();

      final allJobsIds = querySnapshot.docs.map((doc) => doc.id).toList();
      final unviewedJobsIds = allJobsIds.where((id) =>
      !_likedJobsIds.contains(id) && !_dislikedJobsIds.contains(id)).toList();

      if (unviewedJobsIds.isNotEmpty) {
        final randomIndex = Random().nextInt(unviewedJobsIds.length);
        final randomJobId = unviewedJobsIds[randomIndex];
        setState(() {
          _randomJob =
              querySnapshot.docs.firstWhere((doc) => doc.id == randomJobId);
          _isLoading = false; // Загрузка завершена
        });
      } else {
        setState(() {
          _randomJob = null;
          _isLoading = false; // Загрузка завершена
        });
      }
    }
  }

  void _likeJob(String jobId) async {
    await _markJobAsLiked(jobId); // Помечаем вакансию как просмотренную
    await _updateViewedAdsCount(); // Обновляем количество просмотренных объявлений

    // Получаем контакты работодателя из _randomJob
    String employerContacts = _randomJob!['contactLink'] ?? 'Нет контактов';

    // Показываем AlertDialog с контактами
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Контакты работодателя'),
          content: Text(employerContacts),
          actions: <Widget>[
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
            ),
          ],
        );
      },
    ).then((_) => _fetchRandomJob()); // После закрытия диалога загружаем следующую вакансию
  }


  void _dislikeJob(String jobId) async {
    await _markJobAsDisliked(jobId);
    await _updateViewedAdsCount(); // Обновляем количество просмотренных объявлений
    await _fetchRandomJob();
  }




@override
Widget build(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  double width = screenSize.width;
  double height = screenSize.height;
  double TextMultiply = min(width/360, height/800);
  double VerticalMultiply = height/800;
  double HorizontalMultiply = width/360;

  final screenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _randomJob != null
        ? SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[
          Stack(
        children: <Widget>[
          SineWaveWidget(verticalOffset: 206*VerticalMultiply),


          Padding(
            padding:  EdgeInsets.only(
                left: 28*HorizontalMultiply, top: 82*VerticalMultiply, right: 28*HorizontalMultiply, bottom: 0),

            child: Text(
              '${_randomJob!['title']}',
              style: TextStyle(fontSize: 24*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
              textAlign: TextAlign.left, // Добавляем здесь
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(
                left: 32.0*HorizontalMultiply, top: 238.0*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0),
            child: Text(
              ' ${_randomJob!['description']}',
              style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
        padding:  EdgeInsets.only(left: 32.0*HorizontalMultiply, top: 632*VerticalMultiply , right: 32.0*HorizontalMultiply, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        Container(
        decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF93D56F), Color(0xFF659A57)], // Градиент от #93D56F до #659A57
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
      borderRadius: BorderRadius.circular(30*TextMultiply), // Скругление углов
    ),

            child: ElevatedButton(
              onPressed: () => _likeJob(_randomJob!.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Прозрачный фон для отображения градиента
                shadowColor: Colors.transparent, // Убираем тень
                //foregroundColor: Colors.white, // Цвет иконки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30*TextMultiply), // Закругленные углы
                ),
                minimumSize:  Size(144*TextMultiply, 60*TextMultiply), // Минимальный размер кнопки
                padding: EdgeInsets.symmetric(vertical: 15*TextMultiply),

              ),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
        ),
            ElevatedButton(
              onPressed: () => _dislikeJob(_randomJob!.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD1CEB9), // Цвет фона кнопки
                foregroundColor: Colors.white, // Цвет иконки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30*TextMultiply), // Закругленные углы
                ),
                minimumSize:  Size(144*TextMultiply, 60*TextMultiply), // Минимальный размер кнопки

              ),
              child: const Icon(Icons.arrow_forward, color: Color(0xFF343434)),
            ),
          ],
        )

      ),
        ],
      ),],),
    )
        : const Center(
      child: Text('Больше вакансий нет', style: TextStyle(fontSize: 24)),
    ),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: DoubleIcon(
            bottomIconAsset: 'images/icons/main-bg.svg',
            topIconAsset: 'images/icons/main.svg',
          ),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: SvgIcon('images/icons/projects.svg'),
          label: 'Проекты',
        ),
        BottomNavigationBarItem(
          icon: SvgIcon('images/icons/profile.svg',),
          label: 'Профиль',
        ),
        BottomNavigationBarItem(
          icon: SvgIcon('images/icons/support.svg'),
          label: 'Поддержка',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.black, // Цвет выбранного элемента
      unselectedItemColor: Colors.black, // Цвет не выбранного элемента
    ),
    );
  }
}
