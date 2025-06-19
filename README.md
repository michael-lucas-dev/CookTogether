# 🍳 CookTogether – Mobile App

Application Flutter de partage de recettes en groupe.

---

## 🧱 Architecture
Le project est constitué de 2 packages :
- app : le package principal
- design_system : le package de composants UI

Le projet app/ est basé sur une architecture **modulaire et orientée feature**, avec les couches suivantes :
- **Domain** : logique métier, modèles purs
- **Data** : accès aux services externes (Firestore, FirebaseAuth, etc.)
- **Presentation** : UI + gestion d'état via Riverpod
- **Providers** : providers Riverpod
- **Core** : code partagé entre features (logger, router, exceptions, etc.)

---

## 📁 Structure du projet
app/lib/
├── core/ # Services globaux, logger, router, etc.
│ ├── exceptions/
│ ├── logger/
│ ├── router/
│ ├── services/
│ └── widgets/
├── features/ # Découpage par fonctionnalité
│ ├── auth/
│ │ ├── data/
│ │ ├── domain/
│ │ ├── presentation/
│ │ └── providers/
│ ├── recipes/
│ ├── groups/
│ └── users/
├── main.dart # Point d’entrée principal
└── bootstrap.dart # Initialisation de Riverpod, Firebase, etc.

---

## 🛠️ Packages utilisés

| Package | Rôle |
|--------|------|
| `flutter_riverpod` | Gestion d'état typée avec codegen |
| `go_router` | Navigation declarative avec nested routing |
| `firebase_auth`, `cloud_firestore`, `firebase_storage` | Backend |
| `firebase_crashlytics`, `firebase_performance` | Monitoring |
| `logger` | Logs dev/debug |
| `riverpod_generator`, `build_runner` | Génération automatique de providers |
| `widgetbook` | Design system preview |

---

## 🚦 Routing (via `go_router`)

- Authentification protégée via `redirect` logique
- `ShellRoute` pour la `BottomNavigationBar`
- Navigation imbriquée pour les écrans à tabs

```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (!isLoggedIn && state.location != '/login') return '/login';
    return null;
  },
  routes: [
    ShellRoute(...),
    GoRoute(path: '/login', builder: ...),
  ],
);
```

---

🧪 Tests

  - Tests unitaires via flutter_test
  - Mock Firebase avec fake_cloud_firestore
  - Dossier test/ structuré comme lib/features/

```bash
flutter test
```

🔍 Linting & Analyse

  - Utilise flutter_lints
  - Active l’analyse stricte via analysis_options.yaml
  - Vérifie avec :

```bash
flutter analyze
```

⚙️ Génération de code (Riverpod)

Utilise riverpod_generator pour les providers typés.
➤ Installer les dépendances :

```bash
flutter pub get
```

➤ Générer le code :

```bash
dart run build_runner watch --delete-conflicting-outputs
```

📦 Environnements

Configure Firebase via :
```swift
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

Variables d'environnement (via flutter_dotenv, à ajouter si nécessaire).

🔐 Authentification

  - Firebase Auth avec email/password
  - Stream de l’état auth via un authStateProvider
  - Routage protégé automatiquement

💾 Accès Firestore

  - Repositories par feature
  - Utilisation de withConverter() pour typage fort
  - Accès via Riverpod

🧰 Logging

  - Utilise Logger (console)
  - Intégration à Crashlytics avec un LogService

🚀 Déploiement (CI/CD)

Build Android APK :
```bash
flutter build apk --build-name=1.0.0 --build-number=ENV_VERSION_CODE
```

La CI effectue :
- Vérification des tests
- Build APK
- Upload sur Firebase App Distribution

✅ Checklist de migration Windsurf

- [ ] Activer le plugin Riverpod (auto-complete des providers)
- [ ] Lancer dart run build_runner watch
- [ ] Vérifier l’import de flutter_riverpod au lieu de hooks_riverpod si pas utilisé
- [ ] Ajouter les fichiers .env si gestion d’environnements
- [ ] Configurer FirebaseOptions dans main.dart si usage multiplateforme

🤝 Contribuer

  1. Fork / Pull Request
  2. Convention de nommage : feature/nom ou fix/nom
  3. Tests unitaires pour toute logique non-UI
  4. Convention commits : Conventional Commits

