class Bullets 
{
  private float x;
  private float y;
  float tmpX;
  float tmpY;
  PImage bulletImage;
  private boolean shoot = false;
  private boolean pierce = false;
  int collisionFrame = 0;
  boolean collided = false;
  boolean initCollision = true;

  Bullets(float xpos, float ypos, int bulletType)
  {
    if (bulletType == 1)
    {
      bulletImage = loadImage("BulletImg.gif");
    } else if (bulletType == 2)
    {
      bulletImage = loadImage("AlienBulletImg.png");
    }
    x = xpos;
    y = ypos;
  }

  void draw()
  {
    image(bulletImage, x, y);
  }

  void move()
  {
    if (shoot)
    {
      y -= bulletSpeed;
    }
  }

  //void move(Alien alien)
  //{
  //  if (x!=-100)
  //  {
  //    alien.alienShoot = false;
  //    y += (1/((float)NO_OF_ALIEN_ROWS*2));
  //  }
  //}


  void collide(Alien[][] alien)
  {
    for (int j = 0; j < NO_OF_ALIEN_ROWS; j++)
    {
      for (int i = 0; i < alien.length; i++)
      {
        if (x >= alien[i][j].x && x<= (alien[i][j].x + 64) && y <= (alien[i][j].y+64) && !alien[i][j].exploded && !(y+bulletImage.height < alien[i][j].y))
        {
          collided = true;
          if (pierce)
          {
            alien[i][j].lives = 0;
          } else
          {
            if(alien[i][j].lives > 1)
            {
              alienDeath.play(6, 0.1);
            }
            alien[i][j].lives--;
          }
          if (alien[i][j].lives == 0)
          {
            alienDeath.play(3, 0.3);
            alien[i][j].exploded = true;
            aliensKilled++; 
            alien[i][j].dropPowerUp();
          }
          if (!pierce)
          {
            x = -100;
            y = -100;
            shoot = false;
          }
        } else if (y <= 0 && y!= OFFSCREEN)
        {
          x = OFFSCREEN;
          y = OFFSCREEN;
          shoot = false;
        }
      }
    }
  }

  void shoot()
  {
    shoot = !shoot;
  }
  
  void setX(float xpos)
  {
    x = xpos;
  }
  
  void setY(float ypos)
  {
    y = ypos;
  }
  
  float getX()
  {
    return x;
  }
  
  float getY()
  {
    return y;
  }
  
  void bulletExplode(boolean collided, float x, float y, int frame, PImage bulletImage, int index)
{
  if(bullet[index].initCollision)
  {
    tmpX = x;
    tmpY = y;
    bullet[index].initCollision = false;
  }
  if(collided)
  {
    image(bulletExplosion, tmpX-bulletImage.width/2, tmpY-bulletImage.height/2);
    frame++;
  }
  
  if(frame >= 5)
  {
    collided = false;
    frame = 0;
    bullet[index].initCollision = true;
    tmpX = tmpY = OFFSCREEN;
  }
}

  
}
