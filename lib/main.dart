import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_fonts/google_fonts.dart'; // Descomenta si usas Google Fonts

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _selectedFont = 'Roboto';
  Color _primaryColor = Colors.purple;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar preferencias guardadas
  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
      _primaryColor = Color(
        prefs.getInt('primaryColor') ?? Colors.purple.value,
      );
      _userName = prefs.getString('userName') ?? '';
    });
  }

  // Guardar preferencias
  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('selectedFont', _selectedFont);
    await prefs.setInt('primaryColor', _primaryColor.value);
    await prefs.setString('userName', _userName);
  }

  // Métodos para actualizar configuraciones
  void updateTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
    _savePreferences();
  }

  void updateFont(String font) {
    setState(() {
      _selectedFont = font;
    });
    _savePreferences();
  }

  void updatePrimaryColor(Color color) {
    setState(() {
      _primaryColor = color;
    });
    _savePreferences();
  }

  void updateUserName(String name) {
    setState(() {
      _userName = name;
    });
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador',
      theme: ThemeData(
        fontFamily: _selectedFont == 'Default' ? null : _selectedFont,
        // textTheme: GoogleFonts.getTextTheme(_selectedFont), // Usa esto si instalas Google Fonts
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: HomeNavigation(
        isDarkMode: _isDarkMode,
        selectedFont: _selectedFont,
        primaryColor: _primaryColor,
        userName: _userName,
        onThemeChanged: updateTheme,
        onFontChanged: updateFont,
        onColorChanged: updatePrimaryColor,
        onUserNameChanged: updateUserName,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeNavigation extends StatefulWidget {
  final bool isDarkMode;
  final String selectedFont;
  final Color primaryColor;
  final String userName;
  final Function(bool) onThemeChanged;
  final Function(String) onFontChanged;
  final Function(Color) onColorChanged;
  final Function(String) onUserNameChanged;

  const HomeNavigation({
    super.key,
    required this.isDarkMode,
    required this.selectedFont,
    required this.primaryColor,
    required this.userName,
    required this.onThemeChanged,
    required this.onFontChanged,
    required this.onColorChanged,
    required this.onUserNameChanged,
  });

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
            DrawerHeader(
              decoration: BoxDecoration(color: widget.primaryColor),
              child: const Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      isDarkMode: widget.isDarkMode,
                      selectedFont: widget.selectedFont,
                      primaryColor: widget.primaryColor,
                      userName: widget.userName,
                      onThemeChanged: widget.onThemeChanged,
                      onFontChanged: widget.onFontChanged,
                      onColorChanged: widget.onColorChanged,
                      onUserNameChanged: widget.onUserNameChanged,
                    ),
                  ),
                );
              },
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
      body: Column(
        children: [
          Expanded(child: _screens[_selectedIndex]),
          // Nombre en la parte inferior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).colorScheme.surface,
            child: Text(
              widget.userName.isNotEmpty
                  ? 'Usuario: ${widget.userName}'
                  : 'Mauro Ricardo Franco Castelan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
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

// Pantalla de configuración
class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final String selectedFont;
  final Color primaryColor;
  final String userName;
  final Function(bool) onThemeChanged;
  final Function(String) onFontChanged;
  final Function(Color) onColorChanged;
  final Function(String) onUserNameChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.selectedFont,
    required this.primaryColor,
    required this.userName,
    required this.onThemeChanged,
    required this.onFontChanged,
    required this.onColorChanged,
    required this.onUserNameChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late bool _isDarkMode;
  late String _selectedFont;
  late Color _primaryColor;

  final List<String> _fonts = [
    'Roboto',
    'Roboto Mono',
    'Roboto Slab',
    'Roboto Condensed',
  ];
  final List<Color> _colors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _isDarkMode = widget.isDarkMode;
    _selectedFont = widget.selectedFont;
    _primaryColor = widget.primaryColor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de nombre de usuario
            const Text(
              'Nombre de Usuario:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tu nombre',
              ),
              onChanged: (value) {
                widget.onUserNameChanged(value);
              },
            ),
            const SizedBox(height: 24),

            // Switch para tema oscuro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tema Oscuro:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    widget.onThemeChanged(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Selector de fuente
            const Text(
              'Fuente:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedFont,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _fonts.map((font) {
                return DropdownMenuItem(
                  value: font,
                  child: Text(font, style: TextStyle(fontFamily: font)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFont = value;
                  });
                  widget.onFontChanged(value);
                }
              },
            ),
            const SizedBox(height: 24),

            // Selector de color primario
            const Text(
              'Color Principal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _primaryColor = color;
                    });
                    widget.onColorChanged(color);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _primaryColor == color
                            ? Colors.white
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Botón para guardar configuración
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuración guardada exitosamente'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Guardar Configuración'),
              ),
            ),
          ],
        ),
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
  final int maxCounter = 20;
  final int minCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // Cargar el contador guardado
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
    });
  }

  // Guardar el contador
  _saveCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }

  void increment() {
    setState(() {
      if (counter < maxCounter) {
        counter++;
        _saveCounter();
      } else {
        showSnackBar('No se permiten mas de 20 numeros');
      }
    });
  }

  void decrement() {
    setState(() {
      if (counter > minCounter) {
        counter--;
        _saveCounter();
      } else {
        showSnackBar('No se permiten negativos');
      }
    });
  }

  void reset() {
    setState(() {
      counter = 0;
      _saveCounter();
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
            'Mauro Ricardo Franco Castelan',
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
