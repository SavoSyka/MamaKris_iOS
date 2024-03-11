import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/pages/job_create.dart';

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
        Navigator.pushNamed(context, '/empl_list');
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
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
    appBar: AppBar(
      backgroundColor: const Color(0xFFFCFAEE),

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
                          style: const TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),

                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          jobData['description'] ?? 'Без описания',
                          style: const TextStyle(fontSize: 13, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),

                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        trailing: PopupMenuButton<String>(
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
                              child: Text('Редактировать'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Удалить'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Главная',
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
        unselectedItemColor: Colors.grey, // Цвет неактивных элементов
        onTap: _onItemTapped,
      ),
    );
  }
}
