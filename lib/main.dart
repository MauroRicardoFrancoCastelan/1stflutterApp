import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ), // Color morado
        useMaterial3: true,
      ),
      home: const HomeNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  final GlobalKey<_CounterScreenState> _counterKey =
      GlobalKey<_CounterScreenState>();

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      CounterScreen(key: _counterKey),
      ListScreen(),
      CustomCardScreen(),
      ImageGridScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerOption(BuildContext context, String option) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Elegiste: $option')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Multifuncional'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple), // Morado
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pageview),
              title: const Text('Segunda Página'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cerrar Menú'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex], // Mostrar la pantalla seleccionada
      floatingActionButton: _selectedIndex == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'btn_increment',
                  onPressed: () {
                    _counterKey.currentState?.increment();
                  },
                  tooltip: 'Sumar',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'btn_decrement',
                  onPressed: () {
                    _counterKey.currentState?.decrement();
                  },
                  tooltip: 'Restar',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'btn_reset',
                  onPressed: () {
                    _counterKey.currentState?.reset();
                  },
                  tooltip: 'Reiniciar',
                  child: const Icon(Icons.refresh),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Contador'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Lista'),
          NavigationDestination(icon: Icon(Icons.credit_card), label: 'Card'),
          NavigationDestination(icon: Icon(Icons.grid_on), label: 'Grid'),
        ],
      ),
    );
  }
}

//CONTADOR
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;
  final int maxCounter = 20; // Cambié el valor máximo a 10
  final int minCounter = 0;

  void increment() {
    setState(() {
      if (counter < maxCounter) {
        counter++;
      } else {
        showSnackBar(
          'No se permiten mas de 20 numeros',
        ); // Mensaje si alcanza el máximo
      }
    });
  }

  void decrement() {
    setState(() {
      if (counter > minCounter) {
        counter--;
      } else {
        showSnackBar('No se permiten negativos');
      }
    });
  }

  void reset() {
    setState(() {
      counter = 0;
    });
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mauro Ricardo Franco Castelan', // Tu nombre
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            '$counter',
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// LISTA
class ListScreen extends StatelessWidget {
  ListScreen({super.key});

  final List<Map<String, dynamic>> items = [
    {"id": 1, "title": "Elemento Uno", "subtitle": "Subtítulo 1"},
    {"id": 2, "title": "Elemento Dos", "subtitle": "Subtítulo 2"},
    {"id": 3, "title": "Elemento Tres", "subtitle": "Subtítulo 3"},
    {"id": 4, "title": "Elemento Cuatro", "subtitle": "Subtítulo 4"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text(items[index]["id"].toString())),
          title: Text(items[index]["title"]),
          subtitle: Text(items[index]["subtitle"]),
        );
      },
    );
  }
}

//CARD PERSONALIZADO
class CustomCardScreen extends StatelessWidget {
  const CustomCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Card Personalizado',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este es un ejemplo de una card.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//GRID DE IMÁGENES
class ImageGridScreen extends StatelessWidget {
  ImageGridScreen({super.key});

  final List<Map<String, String>> images = [
    {
      'image':
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
      'desc': 'Imagen 1',
    },
    {
      'image':
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
      'desc': 'Imagen 2',
    },
    {
      'image':
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
      'desc': 'Imagen 3',
    },
    {
      'image':
          'https://cdn.pixabay.com/photo/2013/10/02/23/03/mountains-190055_1280.jpg',
      'desc': 'Imagen 4',
    },
    {
      'image':
          'https://cdn.pixabay.com/photo/2013/10/02/23/03/mountains-190055_1280.jpg',
      'desc': 'Imagen 5',
    },
    {
      'image':
          'https://cdn.pixabay.com/photo/2013/10/02/23/03/mountains-190055_1280.jpg',
      'desc': 'Imagen 6',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Mostrar imagen y descripción en pantalla completa
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageDetailScreen(
                  imageUrl: images[index]['image']!,
                  desc: images[index]['desc']!,
                ),
              ),
            );
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      images[index]['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    images[index]['desc']!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Pantalla para mostrar imagen y descripción individual
class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String desc;
  const ImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Imagen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 300, height: 300),
            const SizedBox(height: 20),
            Text(desc, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

// Segunda página que fue añadida al Drawer
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda página de prueba')),
      body: const Center(child: Text('Esta es una segunda página de prueba')),
    );
  }
}
