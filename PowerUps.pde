class PowerUps 
{
  PImage powerUpImg;
  float y;
  float x;
  int power;
  boolean dropped = false;

  PowerUps(int xpos, int ypos, int powerUp)
  {
    x = xpos;
    y = ypos;
    power = powerUp;
    if (powerUp == 0)
    {
      powerUpImg = loadImage("bulletSpeedUpPowerUp.png");
    } else if (powerUp == 1)
    {
      powerUpImg = loadImage("piercingBulletPowerUp.png");
    } else if (powerUp == 2)
    {
      powerUpImg = loadImage("extraBulletPowerUp.png");
    } else if (powerUp == 3)
    {
      powerUpImg = loadImage("extraLifePowerUp.png");
    }
  }

  void draw()
  {
    if (dropped)
    {
      image(powerUpImg, x, y);
    }
  }

  void move()
  {
    if (dropped)
    {
      y += 5;
    }
  }

  void collide(Player thePlayer)
  {
    if (y+powerUpImg.height >= thePlayer.getY() && x+ powerUpImg.width > thePlayer.getX() && x < thePlayer.getX() + (thePlayer.playerImage.width) && !(y > thePlayer.getY()+thePlayer.playerImage.height))
    {
      dropped = false;
      x = OFFSCREEN;
      y = OFFSCREEN;

      if (power == 0)
      {
      itemAcquired.play(1.5, 0.5);
        bulletSpeed += 1;
      } else if (power == 1)
      {
        for (int i = 0; i < bullet.length; i++)
        {
          if (!(bullet[i].pierce))
          {
            itemAcquired.play(1.5, 0.5);
            bullet[i].pierce = true;
            bullet[i].bulletImage = loadImage("PiercingBulletImg.png");
            piercingBullets++;
            break;
          }
        }
      } else if (power == 2)
      {
        itemAcquired.play(1.5, 0.5);
        addBullet();
      } else if (power == 3)
      {
        if (playerLives < MAX_LIVES)
        {
       itemAcquired.play(1.5, 0.5);
          thePlayer.lifeUp();
          playerLives++;
        }
      } else if (y+powerUpImg.height/2 > SCREEN_Y)
      {
        dropped = false;
        x = OFFSCREEN;
        y = OFFSCREEN;
      }
    }
  }

  void addBullet()
  {
    Bullets[] array = new Bullets[bullet.length+1];
    for (int i = 0; i < bullet.length; i++)
    {
      array[i] = bullet[i];
    }
    array[bullet.length] = new Bullets(OFFSCREEN, OFFSCREEN, 1);
    bullet = array;
  }
}
