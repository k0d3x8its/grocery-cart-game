# 🎮 Grocery Cart Game Roadmap

This roadmap is structured in **Phases → Epochs → Goals → Tasks**.

---

## **Phase 1: Foundation**

> Focus: Intial setup of environment

### **Epoch 1.1: Project Setup**

**Goal:** Prepare a clean environment for development
- [x] Create GitHub repository (`main` for releases, `dev` for building)
- [x] Setup project folder structure (`scenes/`, `scripts/`, `assets/`, `ui/`)
- [ ] Configure viewport for mobile-friendly dimensions (e.g., 1080x1920)

### **Epoch 1.2: Player Control**

**Goal:** Implement grocery cart movement
- [ ] Create `Cart` scene (Node2D + Sprite + CollisionShape2D)
- [ ] Add left-right input controls (touch + keyboard fallback)
- [ ] Constrain cart within screen bounds

### **Epoch 1.3: Falling Objects**

**Goal:** Build item spawn & fall mechanic
- [ ] Create placeholder `Item` scene (Sprite + CollisionShape2D)
- [ ] Add random spawn logic (bread, apple, fish as test)
- [ ] Apply gravity/falling motion
- [ ] Despawn items when off-screen

### **Epoch 1.4: Collision & Scoring**

**Goal:** Detect catches and update score
- [ ] Add collision detection between cart & items
- [ ] Increase score when valid item caught
- [ ] Trigger **game over** when mascot caught
- [ ] Display temporary score UI (basic Label)

---

## **Phase 2: Gameplay Loop**

> Focus: Making it a playable game

### **Epoch 2.1: Core Loop**

**Goal:** Implement main menu → gameplay → game over → restart
- [ ] Add `MainMenu` scene with “Start Game” button
- [ ] Connect button to load `Game` scene
- [ ] Add `GameOver` screen with score & restart option

### **Epoch 2.2: Difficulty Scaling**

**Goal:** Keep the game engaging
- [ ] Increase spawn rate over time
- [ ] Increase fall speed over time
- [ ] Add score multiplier bonuses

### **Epoch 2.3: Basic Polish**

**Goal:** Make gameplay feel smoother
- [ ] Add placeholder sound effects (catch, miss, mascot)
- [ ] Add particle effect when catching items
- [ ] Add background color or gradient

---

## **Phase 3: Assets & Polish**

> Focus: Replacing placeholders with real assets

### **Epoch 3.1: Final Assets**

**Goal:** Swap in branded visuals
- [ ] Import mascot sprite
- [ ] Import food item sprites
- [ ] Import cart sprite
- [ ] Add background art

### **Epoch 3.2: UI & Feedback**

**Goal:** Add juice & clarity
- [ ] Style score UI with proper font & visuals
- [ ] Animate score pop-ups when items caught
- [ ] Add transition animations between scenes

### **Epoch 3.3: Audio**

**Goal:** Enhance immersion
- [ ] Add background music
- [ ] Add final sound effects
- [ ] Balance volumes

---

## **Phase 4: Testing & Release**

> Focus: Playability, fixes, deployment

### **Epoch 4.1: Testing**

**Goal:** Fix bugs & refine difficulty
- [ ] Test on desktop
- [ ] Test on mobile browsers
- [ ] Adjust item spawn rates

### **Epoch 4.2: Deployment**

**Goal:** Get the game out
- [ ] Export for Web (HTML5 build)
- [ ] Export for Android/iOS
- [ ] Upload to GitHub Pages / Itch.io for web play

---

✅ Following this roadmap will ensure you get a **working prototype early**
and only polish with final assets once mechanics are complete.

