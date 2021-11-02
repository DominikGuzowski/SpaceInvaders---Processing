Alien[][] theAlien;
Bullets[] bullet;
AlienBullets[] alienBullets;
Player thePlayer;
PImage spaceBG;
PowerUps[] powerUp;
PFont resetFont;
PFont statsFont;
PFont powerUpFont;

void settings() 
{
  size(SCREEN_X, SCREEN_Y);
}

void setup() 
{
  if (NO_OF_ALIEN_ROWS == MAX_ROWS)
  {
    NO_OF_ALIEN_ROWS = 1;
  }

  frameRate(80);
  statsFont = loadFont("Corbel-Bold-15.vlw");
  resetFont = loadFont("Dubai-Bold-48.vlw");
  powerUpFont = loadFont("Arial-BoldMT-25.vlw");
  powerUp = new PowerUps[4];
  thePlayer = new Player(SCREEN_Y-55);
  bullet = new Bullets[NO_OF_BULLETS];
  alienBullets = new AlienBullets[NO_OF_ALIENS*NO_OF_ALIEN_ROWS];
  theAlien = new Alien[NO_OF_ALIENS][NO_OF_ALIEN_ROWS];
  initPowerUps();
  initAliens();
  initBullets();
  initAlienBullets();
  spaceBG = loadImage("spaceBG.png");
  bulletSpeed = 5;
  piercingBullets = 0;
  aliensKilled = 0;
  setLives();
  //  sWave.patch(xx);
}

void draw() 
{
  drawBackground();
  if (gameStart)
  { 
    bulletActions(); 
    powerUpActions(); 
    alienBulletActions(theAlien);
    alienActions();
    thePlayer.draw(); 
    thePlayer.move(mouseX);
    displayStats();
    reset = checkReset(); 
    displayResetScreen();
    stopGamePlay();
  }
  if (!gameStart)
  {
    textFont(resetFont);
    fill(255, 50, 20); 
    text("Press Space to Play!", 250, 450);
    displayPowerUps();
  }
}

void mousePressed()
{
  if (gameStart)
  {
    if (mouseButton == LEFT) {
      for (int i = 0; i < bullet.length; i++)
      {
        if (bullet[i].getX() == OFFSCREEN && bullet[i].getY() == OFFSCREEN && !reset)
        {
          bullet[i].setX(thePlayer.getX() + thePlayer.playerImage.width/2 - 5); 
          bullet[i].setY(thePlayer.getY()); 
          bullet[i].shoot(); 
          break;
        }
      }
    }
  }
}

void keyPressed()
{
  if (keyCode == ' ')
  {
    if (reset)
    {
      if (playerLives == 0)
      {
        setLives();
      }
      reset = false; 
      NO_OF_ALIEN_ROWS++;
      setup();
    }
    if (!gameStart)
    {
      gameStart = true;
    }
  }
}

void initAliens() 
{
  for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
  {
    for (int i = 0; i < NO_OF_ALIENS; i++)
    {
      theAlien[i][j] = new Alien(10+(89*i), 20+(75*j), j);
    }
  }
}

void initBullets()
{
  for (int i = 0; i < bullet.length; i++)
  {
    bullet[i] = new Bullets(OFFSCREEN, OFFSCREEN, 1);
  }
}

void initAlienBullets()
{
  for (int i = 0; i < alienBullets.length; i++)
  {
    alienBullets[i] = new AlienBullets(OFFSCREEN, OFFSCREEN);
  }
}

void initPowerUps()
{
  for (int i = 0; i < powerUp.length; i++)
  {
    powerUp[i] = new PowerUps(OFFSCREEN, OFFSCREEN, i);
  }
}


void alienActions()
{
  for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
  {
    for (int i = 0; i < theAlien.length; i++)
    {
      theAlien[i][j].move();
      theAlien[i][j].draw();
      theAlien[i][j].attack(alienBullets, ((i+1)+(10*j)));
      theAlien[i][j].collide(thePlayer);
    }
  }
}

void bulletActions()
{
  for (int i = 0; i < bullet.length; i++)
  {
    bullet[i].move();
    bullet[i].draw();
    bullet[i].collide(theAlien);
    bullet[i].bulletExplode(bullet[i].collided, bullet[i].x, bullet[i].y, bullet[i].collisionFrame, bullet[i].bulletImage, i);
  }
}

void alienBulletActions(Alien[][] alien)
{
  if (alienBullets != null)
  {
    for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
    {
      for (int k = 0; k < NO_OF_ALIENS; k++)
      {
        for (int i = 0; i < alienBullets.length; i++)
        {

          alienBullets[i].move();
          alienBullets[i].draw(); 
          alienBullets[i].collide(thePlayer, alien, alienBullets);
        }
      }
    }
  }
}

void powerUpActions()
{
  for (int i = 0; i < powerUp.length; i++)
  {
    powerUp[i].move(); 
    powerUp[i].draw(); 
    powerUp[i].collide(thePlayer);
  }
}

void displayResetScreen()
{
  if (reset)
  {
    textFont(resetFont);
    fill(255, 50, 20); 
    if (NO_OF_ALIEN_ROWS == 0)
    {
      text("GAME OVER! Press Space to Restart!", 75, 450);
      displayPowerUps();
    } else if (NO_OF_ALIEN_ROWS == MAX_ROWS-1)
    {
      text("You win!", 370, 450);
    } else
    {
      text("Press Space to Continue to next Level!", 50, 450);
      displayPowerUps();
    }
  }
}

void displayStats()
{
  if (!reset)
  {
    fill(255, 255, 20);
    textFont(statsFont);
    text("Aliens defeated: " + aliensKilled + "/" + NO_OF_ALIENS*NO_OF_ALIEN_ROWS, 230, 15);
    text("No. of Bullets: " + bullet.length, 410, 15);
    text("LEVEL " + NO_OF_ALIEN_ROWS, 10, 15);
    text("No. of Piercing Bullets: " + piercingBullets + "/" + bullet.length, 550, 15);
    text("Bullet Speed: " + bulletSpeed, 755, 15);
    text("Player Lives: " + playerLives, 100, 15);
  }
}

boolean checkReset()
{
  for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
  {
    for (int i = 0; i < theAlien.length; i++)
    {
      if (!theAlien[i][j].exploded)
      {
        return false;
      }
    }
  }
  return true;
}

void explodeAll()
{
  for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
  {
    for (int i = 0; i< NO_OF_ALIENS; i++)
    {
      theAlien[i][j].exploded = true;
    }
  }
}

void stopGamePlay()
{
  if (reset)
  {
    for (int i = 0; i < powerUp.length; i++)
    {
      powerUp[i].x = -100;
      powerUp[i].dropped = false;
    }
    thePlayer.x = -100;
    for (int i = 0; i < alienBullets.length; i++)
    {
      alienBullets[i].x = alienBullets[i].y = OFFSCREEN;
    }

    for (int i = 0; i < bullet.length; i++)
    {
      bullet[i].x = bullet[i].y = OFFSCREEN;
      bullet[i].shoot = false;
    }
  }
}

void drawBackground()
{
  if (thePlayer.checkHit())
  {
    background(255, 20, 20);
    if (hitFrameCounter++ == 3)
    {
      thePlayer.hit();
      hitFrameCounter = 0;
    }
  } else if (thePlayer.checkLifeUp())
  {
    background(20, 255, 20);
    if (hitFrameCounter++ == 3)
    {
      thePlayer.lifeUp();
      hitFrameCounter = 0;
    }
  } else
  {
    background(spaceBG);
  }
}

void displayPowerUps()
{
  textFont(powerUpFont);
  image(powerUp[0].powerUpImg, 10, 700);
  fill(255, 100, 10);
  text("Extra Bullet Speed", 45, 725);
  image(powerUp[1].powerUpImg, 10, 750);
  fill(205, 10, 255);
  text("Piercing Bullet", 45, 775);
  image(powerUp[2].powerUpImg, 10, 800);
  fill(20, 150, 225);
  text("Extra Bullets", 45, 825);
  image(powerUp[3].powerUpImg, 10, 850);
  fill(35, 255, 20);
  text("Life Restore", 45, 875);
}

void setLives()
{
  if (NO_OF_ALIEN_ROWS == 1)
  {
    thePlayer.lives = MAX_LIVES;
  }
}
