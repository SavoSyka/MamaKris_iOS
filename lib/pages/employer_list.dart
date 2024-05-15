import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/pages/job_create.dart';
import 'package:MamaKris/icon.dart';

class JobsListPage extends StatefulWidget {
  @override
  _JobsListPageState createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0; // Индекс для отслеживания текущего выбранного элемента



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/profile_empl');
        break;
      case 2:
        Navigator.pushNamed(context, '/support_empl');
        break;
    }
  }
  void _editJob(Map<String, dynamic> jobData) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => JobPage(jobData: jobData)),
    );
  }

  void _deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
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
      backgroundColor: const Color(0xFFF0ECD3),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF0ECD3),

      title: const Text('Мои объявления',
        style: TextStyle(fontSize: 25, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFF343434)),
      ),
    ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('jobs').where('employerId', isEqualTo: _auth.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Нет данных'));
          }
          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final jobData = job.data() as Map<String, dynamic>;
              jobData['id'] = job.id; // Добавляем id для последующего использования

              // Определяем статус и его цвет
              String statusText = '';
              Color statusColor = Colors.black;
              switch (jobData['status']) {
                case 'approved':
                  statusText = 'Одобрено';
                  statusColor = Color(0xFF659A57);
                  break;
                case 'rejected':
                  statusText = 'Отклонено';
                  statusColor = Color(0xFFF55567);
                  break;
                case 'checking':
                  statusText = 'На рассмотрении';
                  statusColor = Colors.black;
                  break;
                default:
                  statusText = 'Неизвестно';
                  statusColor = Colors.grey;
              }

              return Padding(
                  padding:  EdgeInsets.only(left: 20*HorizontalMultiply, right: 20*HorizontalMultiply, bottom: 8*VerticalMultiply),
                  child: SizedBox(

                    height: 136*VerticalMultiply,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10*TextMultiply),
                      ),
                      color: Color(0xFFFFFFFF),
                      child: PopupMenuButton<String>(
                        onSelected: (String value) {
                        if (value == 'edit') {
                          _editJob(jobData);
                        } else if (value == 'delete') {
                          _deleteJob(job.id);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Редактировать'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Удалить'),
                          ),
                        ),
                      ],
                      child: Stack(
                        children: [
                          ListTile(
                            title: Text(
                              jobData['title'] ?? 'Без названия',
                              style: TextStyle(fontSize: 18 * TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              jobData['description'] ?? 'Без описания',
                              style: TextStyle(fontSize: 12 * TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          Positioned(
                            right: 8*HorizontalMultiply,
                            bottom: 8*VerticalMultiply,
                            child: Text(
                              statusText,
                              style: TextStyle(color: statusColor, fontSize: 12 * TextMultiply, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  )
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JobPage()),
          );
        },
        backgroundColor: Colors.white, // Укажите нужный цвет здесь

        child: const Icon(Icons.add),
        tooltip: 'Добавить вакансию',
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
