# Xmass Cat 🎄🐱

Un jeu de plateforme endless runner mobile développé avec **Godot 4.5** où un chat de Noël court à l'infini en sautant entre des plateformes générées procéduralement.

## 🎮 Caractéristiques

- **Génération procédurale infinie** - Les plateformes apparaissent dynamiquement devant le joueur
- **Difficulté progressive** - Le chat accélère à chaque saut
- **Système de collectibles** - Ramassez des objets pour augmenter votre score
- **Animations fluides** - État machine avec animations de course, saut et attaque
- **Optimisé mobile** - Conçu pour Android avec contrôles tactiles

## 🚀 Démarrage rapide

### Prérequis

- Godot Engine 4.5+
- Pour l'export Android : Android SDK configuré

### Lancer le jeu

1. Ouvrir `project.godot` dans l'éditeur Godot
2. Appuyer sur **F5** pour lancer le jeu
3. **Espace** ou **clic/tap** pour sauter
4. **A** pour attaquer

## 📁 Structure du projet

```
xmass_cat/
├── characters/cat/          # Personnage joueur avec physique et animations
├── scenes/
│   ├── main/               # Scène principale et orchestration du jeu
│   ├── hud/                # Interface utilisateur (score, temps)
│   └── tilemap/            # Génération procédurale des sols
├── objects/collectible/    # Items à collecter
├── scripts/
│   └── atlas_manager.gd    # Singleton pour configuration des tiles
├── assets/
│   ├── audio/              # Musique et effets sonores
│   ├── fonts/              # Police BoldPixels
│   └── images/             # Sprites et textures
└── android/                # Configuration build Android
```

## 🎯 Gameplay

- Le chat court automatiquement vers la droite
- Sautez pour franchir les obstacles et collecter les items
- La vitesse augmente progressivement
- Tombez en dehors de l'écran = Game Over
- Collectez un maximum d'items avant de chuter

## 🛠️ Architecture technique

### Génération procédurale

Le système génère des plateformes basé sur la position de la caméra :
- Nouvelles plateformes créées 900px devant la caméra
- Anciennes plateformes supprimées 500px derrière
- Gaps et hauteurs aléatoires pour la difficulté

### Système de tiles

Utilise `AtlasManager` pour gérer les configurations de tiles :
- Grilles 3x3 avec positions corner/edge/center
- Multiples thèmes de sols (simple, marroon, wall)
- Construction dynamique via coordonnées atlas

### Communication par signaux

```gdscript
Cat.die → Recharge la scène
Cat.picked_collectible → Met à jour le HUD
Collectible.picked → Animation vers HUD puis destruction
```

## 📱 Export Android

Configuration dans `export_presets.cfg` :
- Architecture : ARM64 uniquement
- Package : `org.starland9.xmasscat`
- Output : `./Xmass Cat.apk`

Pour exporter :
1. Project → Export
2. Sélectionner le preset Android
3. Export Project

## 🎨 Paramètres graphiques

- Résolution : 640x360 (canvas_items stretch)
- Rendu : Mobile renderer
- Pixel art : Nearest neighbor filtering
- Snap to pixel activé

## 🧩 Patterns de code

### State Machine

```gdscript
enum State { ATTACK, JUMP, RUN }
func _manage_state() # Évalue les conditions
func _set_state(state: State) # Change l'état si nécessaire
func _update_anim() # Synchronise l'animation
```

### Node References

```gdscript
@onready var anim := $AnimatedSprite2D
@onready var cat : Cat = $Cat
```

### Préchargement

```gdscript
const collectible_scene = preload("res://objects/collectible/collectible.tscn")
```

## 📄 License

Projet personnel - Starland9

## 🤝 Contribution

Pour les développeurs IA et contributeurs, consultez `.github/copilot-instructions.md` pour les détails architecturaux et conventions du projet.
