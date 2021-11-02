class Alien {
  boolean goDown = false;
  boolean goRight = true;
  boolean goLeft = false;
  int lives;
  float x;
  float y;
  float yPos;
  boolean exploded = false;
  float speedUp = 1;
  float updateSpeed = 0.0005*NO_OF_ALIEN_ROWS/4;
  int frame = 0;
  int animation;
  int yOffset = 1;
  int counter = 0;
  int animationCounter = 0;
  PImage[] explosion = new PImage[10];
  PImage bulletImg;
  PImage aFrame1;
  PImage aFrame2;
  PImage pAFrame1;
  PImage pAFrame2;
  //boolean alienShoot = false;


  Alien(int xpos, int ypos, int row) {
    if (row%2==0)
    {
      goDown = false;
      goRight = true;
      goLeft = false;
    } else
    {
      goDown = false;
      goRight = false;
      goLeft = true;
    }
    yPos = 20+ypos;
    x = xpos;
    y = ypos;
    bulletImg = loadImage("AlienBulletImg.png");
    animation = (int)random(7);
    if (animation == 0)
    {
      aFrame1 = loadImage("AlienF1.png");
      aFrame2 = loadImage("AlienF2.png");
    } else
    {
      pAFrame1 = loadImage("PAlienF1.png");
      pAFrame2 = loadImage("PAlienF2.png");
    }
    if (animation == 0)
    {
      lives = 3;
    } else
    {
      lives = 1;
    }

    for (int i = 0; i < explosion.length; i++)
    {
      explosion[i] = loadImage("ExpF" + (i+1) + ".png");
    }
  }

  void move() {
    if (!exploded) {
      if (goRight)
      {
        x+= speedUp;
      }
      if (goLeft)
      {
        x-= speedUp;
      }

      if (x<=0)
      {
        x = 0;
        goLeft = false;
        goRight = false;
        goDown = true;
      }
      if (x+64>=SCREEN_X)
      {
        x = SCREEN_X-64;
        goRight = false;
        goLeft = false;
        goDown = true;
      }
      if (goDown && (x+64 >= SCREEN_X))
      {
        y+= speedUp;
        if (y>=(yPos+75*yOffset-20))
        {
          y = yPos+75*yOffset-20;
          goDown = false;
          goLeft = true;
          yOffset++;
        }
      }
      if (goDown && x<=0)
      {
        y+= speedUp;
        if (y>=(yPos+75*yOffset-20))
        {
          y = yPos+75*yOffset-20;
          goDown = false;
          goRight = true;
          yOffset++;
        }
      }
      if (!(speedUp>=10))
      {
        speedUp += updateSpeed;
      }
    }
  }

  void draw() 
  {
    if (!exploded) {
      if (animation==0)
      {
        alienAnimation1();
      } else if (animation>0)
      {
        alienAnimation2();
      }
    } else if (exploded && x!= OFFSCREEN)
    {
      explodeAnimation();
    }
  }

  void alienAnimation1()
  {
    if (frame<15)
    {
      image(aFrame1, x, y+10*sin(x/(50)));
    } else if (frame>=15)
    {
      image(aFrame2, x, y+10*sin(x/(50)));
    } 

    if (frame++>=30)
    {
      frame = 0;
    }
  }

  void alienAnimation2()
  {
    if (frame<15)
    {
      image(pAFrame1, x, y);
    } else if (frame>=15)
    {
      image(pAFrame2, x, y);
    } 

    if (frame++>=30)
    {
      frame = 0;
    }
  }

  void explodeAnimation() 
  {
    if (counter%3==0 && counter!=30 && counter!=0) {
      animationCounter++;
    }
    image(explosion[animationCounter], x, y);

    if (counter++>30) 
    {
      animationCounter = 0;
      counter = -1;
      x = OFFSCREEN;
      y = OFFSCREEN;
    }
  }

  void dropPowerUp()
  {
    int dropped;
    if (animation == 0)
    {
      dropped = (int)random(2);
    } else
    {
      dropped = (int)random(5);
    }

    if (dropped == 1)
    {
      int dropType = (int)random(4);
      if (powerUp[dropType].x == OFFSCREEN)
      {
        powerUp[dropType].x = x+32;
        powerUp[dropType].y = y+32;
        powerUp[dropType].dropped = true;
      }
    }
  }

  void attack(AlienBullets[] bullet, int i)
  {
    int temp;
    if (animation == 0)
    {
      temp = (int)random(200);
    } else
    {
      temp = (int)random(2000);
    }
    if (temp == 1 && !exploded && bullet[i-1].x == OFFSCREEN)
    {
      bullet[i-1].shoot = true;
      bullet[i-1].x = x+32;
      bullet[i-1].y = y+32;
    }
  }

  void collide(Player player)
  {
    if (y+64 >= player.y && x+64 > player.x && x < player.x + (player.playerImage.width))
    {
      reset = true;
      explodeAll();
      NO_OF_ALIEN_ROWS = 0;
    }
  }
}
