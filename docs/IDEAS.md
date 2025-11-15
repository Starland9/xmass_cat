# Xmass Cat — Idées et contributions (Checklist)

Cochez les éléments réalisés et liez les PR correspondantes. Ajoutez des notes courtes sous chaque case au besoin.

## Mécaniques et obstacles
- [ ] Tuiles glissantes (glace) — friction faible
  - Notes: TileSet custom_data `surface="ice"`; Cat réduit friction sur contact
- [ ] Plateformes friables — disparaissent 0.5s après atterrissage
  - Notes: `FloorCrumble.tscn` + Timer → `queue_free()`
- [ ] Trampolines — rebond x1.6
  - Notes: tile metadata `bounce=1.6`; Cat applique `jump_force*bounce`
- [ ] Plateformes mobiles — aller-retour
  - Notes: `Tween/PathFollow2D`; spawn ~1/5
- [ ] Boules de neige roulantes — obstacles mobiles
  - Notes: `Snowball.tscn`; knockback ou mort à l’impact

## Power-ups (temporisés)
- [ ] Aimant à collectibles
  - Notes: `Area2D` autour du Cat; tween des collectibles vers le joueur
- [ ] Double saut
  - Notes: compteur `jump_air_left`; reset `is_on_floor()`
- [ ] Dash/ATTACK amélioré (i-frames)
  - Notes: vitesse x2 sur 0.25s; masque collision adapté
- [ ] Bouclier 1 coup
  - Notes: bool `shield_active`; effet visuel `Sprite2D`

## Score, boucles et objectifs
- [ ] Multiplicateur de combo
  - Notes: combo dans `main.gd`; HUD affiche x1..x5; reset au hit
- [ ] Missions rapides (ex: ramasse 10 cannes, survis 45s)
  - Notes: Autoload `Missions.gd`; récompenses cosmétiques
- [ ] Daily run (seed du jour)
  - Notes: `RNG.seed = hash(date)`; bouton “Daily” dans menu

## Variété de biomes et génération
- [ ] Biomes (Village, Forêt, Grotte glacée)
  - Notes: `AtlasManager.Floors.*` par biome; switch toutes N plateformes
- [ ] Segments préfabriqués (set-pieces/chunks)
  - Notes: `scenes/chunks/*.tscn`; insérer ~1/8 spawns

## Polish et feedback
- [ ] Parallax + neige (`Particles2D`)
  - Notes: intensité selon difficulté
- [ ] Screen shake (atterrissage/ATTACK)
  - Notes: `Camera2D` + `Tween` secousse légère
- [ ] Trails de vitesse sur Cat (haut multiplicateur)
  - Notes: `Line2D`/`GPUParticles2D`
- [ ] SFX/Haptique
  - Notes: `AudioStreamPlayers`; `OS.vibrate()` sur Android (guard)

## Progression et rétention
- [ ] Skins du chat à débloquer
  - Notes: `Inventory.gd` + `res://characters/cat/skins/*`
- [ ] Défis hebdo avec badges
  - Notes: `Missions.gd` “weekly”; persistence via `ConfigFile` `user://`

## Qualité de vie et debug
- [ ] Overlay debug génération (seeds, thresholds)
  - Notes: `DebugOverlay.tscn` relié à `main.gd`
- [ ] Mode training (vitesse fixe, segments répétés)
  - Notes: flag `main.gd` qui fige `speed_factor`

---

Références utiles:
- `scenes/main/main.gd` — génération, difficulté, RNG
- `characters/cat/cat.gd` — state machine, input, vitesse/sauts
- `scripts/atlas_manager.gd` — atlas et variantes de sols
- `scenes/tilemap/*` — `TileMapLayer` et plateformes