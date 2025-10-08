import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/photos/data/repositories/photo_repository_impl.dart';
import 'features/photos/data/repositories/recent_folders_repository.dart';
import 'features/photos/domain/services/duplicate_detection_service.dart';
import 'features/photos/domain/services/file_operation_service.dart';
import 'features/photos/domain/services/image_processing_service.dart';
import 'features/photos/presentation/bloc/duplicate_detection_bloc.dart';
import 'features/photos/presentation/bloc/file_operation_bloc.dart';
import 'features/photos/presentation/bloc/image_processing_bloc.dart';
import 'features/photos/presentation/bloc/photo_browser_bloc.dart';
import 'features/photos/presentation/bloc/photo_browser_event.dart';
import 'features/photos/presentation/bloc/recent_folders_bloc.dart';
import 'features/photos/presentation/screens/duplicate_detection_screen.dart';
import 'features/photos/presentation/screens/photo_browser_screen.dart';
import 'features/photos/presentation/screens/recent_folders_screen.dart';
import 'features/photos/presentation/widgets/file_operation_progress_dialog.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhotoManagerApp());
}

class PhotoManagerApp extends StatelessWidget {
  const PhotoManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc(
            repository: SettingsRepository(),
          )..add(LoadSettings()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Photo Manager',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: settingsState.settings.darkMode ? 
                  Brightness.dark : Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhotoBrowserBloc(
            photoRepository: PhotoRepositoryImpl(),
            recentFoldersRepository: RecentFoldersRepository(),
          )..add(const LoadDirectory(path: '/')),
        ),
        BlocProvider(
          create: (context) => FileOperationBloc(
            fileOperationService: FileOperationService(),
          ),
        ),
        BlocProvider(
          create: (context) {
            final photoRepo = PhotoRepositoryImpl();
            return DuplicateDetectionBloc(
              duplicateDetectionService: DuplicateDetectionService(
                photoRepository: photoRepo,
              ),
            );
          },
        ),
        BlocProvider(
          create: (context) => RecentFoldersBloc(
            repository: RecentFoldersRepository(),
          )..add(LoadRecentFolders()),
        ),
        BlocProvider(
          create: (context) => ImageProcessingBloc(
            service: ImageProcessingService(),
          ),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            PhotoBrowserScreen(),
            DuplicateDetectionScreen(),
            RecentFoldersScreen(),
            SettingsScreen()
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.photo_library),
              label: 'Browse',
            ),
            NavigationDestination(
              icon: Icon(Icons.copy_all),
              label: 'Duplicates',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder),
              label: 'Recent',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
