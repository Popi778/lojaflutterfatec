import 'package:firebase_core/firebase_core.dart';        // Biblioteca base do Firebase para inicialização
import '../firebase_options.dart';                        // Arquivo gerado pelo FlutterFire CLI com as opções de configuração

Future<void> initFirebase() async {                       // Função assíncrona que inicializa o Firebase
  await Firebase.initializeApp(                           // Inicializa o Firebase na aplicação
    options: DefaultFirebaseOptions.currentPlatform,      // Usa as opções corretas para a plataforma atual (Web, Android, iOS)
  );
}
