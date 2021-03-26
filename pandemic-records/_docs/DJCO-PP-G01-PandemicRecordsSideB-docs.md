# DJCO Preliminary Project

**Group:** G01

**Game Title:** Pandemic Records: Side B

| Name | Contact | UP Number |
| :- | :- | :- |
| Diogo José de Sousa Machado | diogo.machado@fe.up.pt | 201706832 |
| João Pedro da Costa Ribeiro | up201704851@fe.up.pt   | 201704851 |

---

## Table of Contents
  - [Project Description](#project-description)
    - [Concept](#concept)
    - [Game Characteristics](#game-characteristics)
    - [Installation Instructions](#installation-instructions)
    - [Playing Instructions](#playing-instructions)
  - [Game Mechanics](#game-mechanics)
    - [Weapons](#weapons)
    - [Enemies](#enemies)
    - [Power-Ups](#power-ups)
    - [Obstacles](#obstacles)
  - [Development Process](#development-process)
    - [Creation of Art Assets (Sprites and Sounds)](#creation-of-art-assets-sprites-and-sounds)
    - [Working with Godot Engine](#working-with-godot-engine)
    - [Head Start from Learning Projects](#head-start-from-learning-projects)
  - [Resources Used](#resources-used)
    - [Learning Projects](#learning-projects)
    - [Visuals](#visuals)
    - [Sounds](#sounds)

<div style="page-break-after: always;"></div>

## Project Description

In this section, we will tell you a little bit about the basics of the game, including the story, and how to play.

### Concept

Setting: Hall B @ FEUP

11PM arrives. And with it, the attack of the COVID hordes is launched. With FEUP closed down, it is up to you, the night guard, to fend off the disease.

To do this, you count on your trusty Sanitizer Dispensers, as you clear the seemingly endless hallway of the different COVID variants. Will you be able to wipe out their forces, and allow classes to go on as if nothing had ever happened? (Spoiler Alert: you won’t)

### Game Characteristics

The game is a retro-style **vertical scrolling shooter**, developed on **Godot Engine**.

There is **no end** to the game, except for **death of the player**, which occurs when they lose their **3 lives**.

The camera moves along the hallway, with the **player moving relatively to the camera**. Under no (intended!) circumstances does the player leave the camera's field of vision during the game.

The player **gains score by killing enemies**, each variant giving a different score.

The player takes **damage** from: (1) colliding with an enemy, or (2) colliding with an obstacle.

There is **no HP bar**. If you **get hit once**, you **lose a life**. From COVID. Horribly.

### Installation Instructions

In the file `DJCO-PP-G01-PandemicRecordsSideB-game.zip` archive, you will find executables to run the game on Linux and on Windows. You do not need to install anything else, you can just open the executable, and have fun!

### Playing Instructions

The game's controls are very simple. The only commands you can use are **moving**, **aiming** and **shooting**.

- You can **move**, as is tradition, using the **WASD** keys.
- To **aim**, simply **move your mouse**, and you will see a reticle on the screen which gives you visual feedback.
- To **shoot**, you can click the **Left and Right buttons on your mouse**. The **Left** button fires the **Squirt Gun** (rifle-like), while the **Right** button fires the **Sanitizer Spray** (shotgun-like).
- Finally, you can control the **Menus** using your **mouse**, by clicking on the buttons. The WASD or Arrow keys are not usable to navigate the menu.

---

## Game Mechanics

In this section, we will elaborate on the mechanics of the game, including a description of how they interact with one another.

### Weapons

The player has two weapons which can be used infinitely , limited only by their fire rate.

- **Squirt Gun:** this weapon shoots sanitizer at a distance, with the bullet only stopping upon contact with an enemy. You can think of it as a standard rifle.
- **Sanitizer Spray:** this weapon fires in a short-ranged cone, with the bullets going through all enemies in that area. You can think of it as a shotgun.

### Enemies

There are three enemy variants which threaten the player:

- **Standard Variant:** moves menacingly, and should be avoided by the player, and is the most common enemy in the game.
- **British Variant:** behaves aggressively, relentlessly chasing the player instead of shooting projectiles.
- **Dormant Clusters:** move slowly, due to their small size, and have a chance to drop Power-Ups when killed by the player’s bullets.

Enemies spawn at random intervals, which get progressively shorter over time.

<center>
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-amwm{font-weight:bold;text-align:center;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-amwm">Standard</th>
    <th class="tg-baqh"><span style="font-weight:bold">British</span></th>
    <th class="tg-amwm">Dormant</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-baqh"><img width='150px' src='https://i.imgur.com/2zwdtX9.png'></td>
    <td class="tg-baqh"><img width='150px' src='https://i.imgur.com/mQ8N4Z3.png'></td>
    <td class="tg-baqh"><img width='150px' src='https://i.imgur.com/M2T6g5u.png'></td>
  </tr>
</tbody>
</table>
</center>

### Power-Ups

Two types of Power-Ups can drop from the Dormant Cluster enemies:
- **Quick Fire:** this Power-Up doubles the fire rate on both of the player’s weapons. It is the most common drop and it is very useful for clearing clusters of Bri’ish enemies, among other things.
- **Nuke:** this Power-Up kills all enemies on the screen instantly. It is your best friend on extended runs, when the screen fills up very quickly.

<center>
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-amwm{font-weight:bold;text-align:center;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-amwm">Quick Fire</th>
    <th class="tg-baqh"><span style="font-weight:bold">Nuke</span></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-baqh"><img width='150px' src='https://i.imgur.com/IS2Snwo.png'></td>
    <td class="tg-baqh"><img width='150px' src='https://i.imgur.com/WGSv52e.png'></td>
  </tr>
</tbody>
</table>
</center>

The Power-Ups will remain on the ground until you catch them. If you leave them behind, however, they are gone.

### Obstacles

Along the hallway, two obstacles will spawn: the **Printers** which rest against the walls, and the **Columns** which ensure the building’s structural integrity.

The player must be mindful of these obstacles, as **colliding with them will cost one life**, destroying the obstacle in the process.

**However**, being part of the environment in which the students go to classes, the obstacles are heavily sanitized, **killing enemies on contact** (which gives no score, because there are no handouts in the fight for public health). This **does not destroy the obstacle**.

Your **bullets** also **don't destroy the obstacles**. They are made of sanitizer, after all!

---

## Development Process

In this section we will highlight the highs and lows of the process of developing this game, explaining the problems/limitations that we faced, and how we handled those situatons.

### Creation of Art Assets (Sprites and Sounds)

Having little experience in this area, it is noticeable that some of our assets are not very elaborate pieces. For example, most of the sound assets used in the game were downloaded from royalty-free sources online (we will specify and reference them in a later section). However, some of the assets, such as the Enemies and Hall B, ended up going better than expected, and we could say that we were proud of the result, in this aspect.

### Working with Godot Engine

Although we were not 100% new to the engine, we had very limited experience with it, and as such we had a hard time interiorizing some of its characteristics. The little experience that we had helped us not have to spend as much time investigating Godot's tree structure, or its organization in Scenes to represent different concepts.

One example of the difficulties we faced is the system of positions working relatively to parent nodes in the tree structure that Godot uses. One concrete situation where we faced this difficulty was in coding the British variant enemy to chase the player's position. In the end, we found that placing the parent elements (such as the spawners for the player and the enemies) in a common location allowed us to effectively compare and manipulate their real positions. Even though this was a slightly naive solution, it worked perfectly for our game in specific, saving us time that would otherwise have been spent in manipulating the positions in a more convoluted way.

### Head Start from Learning Projects

One solution which worked well for us in terms of learning different functionalities of the engine was inspecting templates on Godot's downloadable asset library. This helped us massively in implementing features such as the player aiming and shooting bullets with the mouse, or animating the player's sprite, as well as the infinite scrolling of textures.

---

## Resources Used

In this section, we will credit the people responsible for the assets that we did not create.

### Learning Projects

- "[Scrolling Backgrounds Demo](https://godotengine.org/asset-library/asset/708)", submitted by Godot user `Gaspi`
- "[Slime Shooter - Godot & FOSS Learning Project](https://godotengine.org/asset-library/asset/544)", submitted by Godot user `FreedCreative`

### Visuals

- "[A Cuchillada](https://www.font-generator.com/fonts/ACuchillada/)", font submitted by user `deFharo`, on the website `www.font-generator.com`. This font was used in the logo of the game.
- "[Press Start 2P](http://www.zone38.net/font/#pressstart)", font made by [codeman38](https://twitter.com/codeman38), shared under the [SIL Open Font License](http://scripts.sil.org/OFL). This font was used in the game's UI.
- Reticle Sprite, included in the referred project "[Slime Shooter - Godot & FOSS Learning Project](https://godotengine.org/asset-library/asset/544)", under the [CC BY-SA License](https://creativecommons.org/licenses/by-sa/4.0/)

### Sounds

- Obstacle Crash sound, from "[Chairs Break, Crash, pieces move](https://freesound.org/people/issalcake/sounds/115919/)", submitted by user `issalcake` in the website `freesound.org`, under the [CC0 1.0 License](https://creativecommons.org/publicdomain/zero/1.0/)
- "Gun" Firing sound, from "[Disinfectant Spray | HQ Sound Effects](https://www.youtube.com/watch?v=RHg6Jv4B6TM)" sound effect, made available by Youtube channel [Everyday Cinematic Sound](https://www.youtube.com/channel/UCKhZFIZjpB7Vtf_XKOvBzrg)
- Nuke Explosion sound, from "[Explosion Sound Effects 7](https://www.youtube.com/watch?v=aZZmZqaCwSI)", on Youtube channel [solosound](https://www.youtube.com/user/ATLASSOUNDEFFECTS) (no artist credited)
- Quick Fire Power-Up sound, from "[Gun Cocking Sound 3 - Sound Effect (HD)](https://www.youtube.com/watch?v=P5vmt35574U)", on Youtube channel [Sound Effect](https://www.youtube.com/channel/UCACmOPj06sNjJyHt20dFFmQ) (no artist credited)
