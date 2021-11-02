class AlienBullets {
  private float x, y;
  PImage alienBulletImage;
  private boolean shoot = false;

  AlienBullets(float xpos, float ypos)
  {
    x = xpos;
    y = ypos;
    alienBulletImage = loadImage("AlienBulletImg.png");
  }

  void draw()
  {
    image(alienBulletImage, x, y);
  }

  void move()
  {
    if (x != OFFSCREEN)
    {
      shoot = false;
      y += (1/((float)NO_OF_ALIEN_ROWS*2));
    }
  }

  void collide(Player player, Alien[][] alien, AlienBullets[] bullet)
  {
    for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
    {
      for (int i = 0; i < alien.length; i++)
      {
        if (y+bullet[i+10*j].alienBulletImage.height >= player.y && x+bullet[i+10*j].alienBulletImage.width > player.x && x < player.x + (player.playerImage.width))
        {
          x = -100;
          y = -100;
          //alien[i][j].alienShoot = false;
        //  playerHit.play(1.2, 0.8);
          alienDeath.play(1, 0.5);
          shoot = false;
          playerLives--;
          player.hit();
          if (playerLives == 0)
          {
            explodeAll();
            NO_OF_ALIEN_ROWS = 0;
            reset = true;
            playerLives = MAX_LIVES;
          }
        } 
        else 
        {
          offScreen();
        }
      }
    }
  }

  void offScreen()
  {
    if (y >= SCREEN_Y && y!= OFFSCREEN)
    {
      x = OFFSCREEN;
      y = OFFSCREEN;
    } 
  }
}
