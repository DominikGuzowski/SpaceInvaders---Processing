class Player
{
  private float x = mouseX;
  private float y;
  PImage playerImage;
  private boolean hit = false;
  private boolean lifeUp = false;
  private int lives;

  Player(int ypos)
  {
    y = ypos;
    playerImage = loadImage("Spaceship.gif");
  }

  void move(float xpos)
  {
    if (!reset)
    {
      if (xpos + playerImage.width/2 < SCREEN_X && xpos - playerImage.width/2 + 5 > 0)
      {
        x = xpos-playerImage.width/2+5;
      }
    }
  }

  void move()
  {
    if (keyPressed && keyCode == RIGHT)
    {
      x += 3;
    } else if (keyPressed && keyCode == LEFT)
    {
      x -= 3;
    }
  }

  void draw()
  {
    image(playerImage, x, y);
  }

  void restoreLives(int maxLives)
  {
    lives = maxLives;
  }

  int getLives()
  {
    return lives;
  }

  void decrementLives()
  {
    lives--;
  }

  void incrementLives()
  {
    lives++;
  }

  void lifeUp()
  {
    lifeUp = !lifeUp;
  }

  void hit()
  {
    hit = !hit;
  }
  boolean checkLifeUp()
  {
    return lifeUp;
  }

  boolean checkHit()
  {
    return hit;
  }

  float getX()
  {
    return x;
  }

  float getY()
  {
    return y;
  }

}
