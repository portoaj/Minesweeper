int size = 100;
Tile [][] tiles;
int realTiles = 0;
boolean gameOn = true;
Input input;
int framesHeld = 0;
boolean cf = false;
boolean onef = false;
boolean twof = false;
boolean threef = false;
boolean resetVar2 = false;
boolean resetVar = true;
int resetFrames = 0;
void setup()
{
  input = new Input();
  textSize(size);
  tiles = new Tile[width/size][height/size];
  for(int i = 0; i < tiles.length; i++)
  {
    for(int j = 0; j < tiles[i].length; j++)
    {
      tiles[i][j] = new Tile(i * size, j * size, size);
    }
  }
  for(int i = 0; i < tiles.length; i++)
  {
    for(int j = 0; j < tiles[i].length; j++)
    {
      if(floor(random(8)) == 0)
      {
        tiles[i][j].setAsBomb();
        //Check first column for nearby tiles
        if(withinBounds(i - 1, j - 1))
        {
          tiles[i - 1][j - 1].addNearbyBomb();
        }
        if(withinBounds(i - 1, j))
        {
          tiles[i - 1][j].addNearbyBomb();
        }
        if(withinBounds(i - 1, j + 1))
        {
          tiles[i - 1][j + 1].addNearbyBomb();
        }
        //Check second column for nearby tiles
        if(withinBounds(i, j - 1))
        {
          tiles[i][j - 1].addNearbyBomb();
        }
        if(withinBounds(i, j + 1))
        {
          tiles[i][j + 1].addNearbyBomb();
        }
        //Check third column for nearby tiles
        if(withinBounds(i + 1, j - 1))
        {
          tiles[i + 1][j - 1].addNearbyBomb();
        }
        if(withinBounds(i + 1, j))
        {
          tiles[i + 1][j].addNearbyBomb();
        }
        if(withinBounds(i + 1, j + 1))
        {
          tiles[i + 1][j + 1].addNearbyBomb();
        }
      }
      else
      realTiles++;
    }
  }
  frameRate(10);
}
void checkWin()
{
  int tilesRevealed = 0;
  for(int i = 0; i < tiles.length; i++)
  {
    for(int j = 0; j < tiles[i].length; j++)
    {
      if(tiles[i][j].revealedAsReal())
      {
        tilesRevealed++;
      }
    }
  }
  if(tilesRevealed == realTiles)
  {
    gameOn = false;
    textSize(300);
    text("You Win!",0, height);
  }
}
boolean withinBounds(int _i, int _j)
{
  if(_i < 0)
  return false;
  if(_i > width/size - 1)
  return false;
  if(_j < 0)
  return false;
  if(_j > height/size - 1)
  return false;
  
  return true;
}
void draw()
{
  background(0);
  /*for(int i = 0; i < tiles.length; i++)
  {
    for(int j = 0; j < tiles[i].length; j++)
    {
      text(i + ", " + j, tiles[i][j].getLocalPos().x, tiles[i][j].getLocalPos().y);
    }
  }*/
  if(!gameOn)
  {
    println("waiting to restart");
    resetFrames++;
    if(resetFrames >= 40)
    {
      resetFrames = 0;
      gameOn = true;
      println("restarted");
      setup();

    }
  }
  cf = mousePressed;
  println(cf + " " + resetVar + " " + gameOn);
  if(onef && (!(cf || twof)) && resetVar)
  {
    input.setTap(true);
    input.setLongTap(false);
    resetVar = false;
    resetVar2 = false;
  }
  else if(threef && twof && onef && resetVar)
  {
    input.setTap(false);
    input.setLongTap(true);
    resetVar = false;
    resetVar2 = false;
  }
  else
  {
    input.setTap(false);
    input.setLongTap(false);
    resetVar2 = true;
  }
  threef = twof;
  twof = onef;
  onef = cf;
  resetVar = resetVar2;
  
    for(int i = 0; i < tiles.length; i++)
    {
      for(int j = 0; j < tiles[i].length; j++)
      {
        tiles[i][j].showTile();
      }
    }
    if(!gameOn)
    {
      textSize(300);
      text("You Lose :(",0, height);
    }
  if (input.getLongTap() && gameOn)
  {
    PVector mousePos = new PVector(mouseX, mouseY);
    PVector closestTile = new PVector(0,0);
    float closestDist = PVector.dist(tiles[0][0].getPos(), mousePos);
    for(int i = 0; i < tiles.length; i++)
    {
      for(int j = 0; j < tiles[i].length; j++)
      {
        float currentDist = PVector.dist(tiles[i][j].getPos(), mousePos);
        if(currentDist < closestDist)
        {
          closestTile = new PVector(i,j);
          closestDist = currentDist;
        }
      }
    }
    if(!tiles[(int)closestTile.x][(int)closestTile.y].getIsShowing())
    tiles[(int)closestTile.x][(int)closestTile.y].toggleBombMarker();
  }
  else if(gameOn && input.getTap())//
  {
    PVector mousePos = new PVector(mouseX, mouseY);
    PVector closestTile = new PVector(0,0);
    float closestDist = PVector.dist(tiles[0][0].getPos(), mousePos);
    for(int i = 0; i < tiles.length; i++)
    {
      for(int j = 0; j < tiles[i].length; j++)
      {
        float currentDist = PVector.dist(tiles[i][j].getPos(), mousePos);
        if(currentDist < closestDist)
        {
          closestTile = new PVector(i,j);
          closestDist = currentDist;
        }
      }
    }
    checkWin();
    reveal((int)closestTile.x, (int)closestTile.y, (tiles[(int)closestTile.x][(int)closestTile.y].getNearbyBombs() == 0));
  }
  
}
void gameEnd()
{
   for(int i = 0; i < tiles.length; i++)
    {
      for(int j = 0; j < tiles[i].length; j++)
      {
        tiles[i][j].reveal();
      }
    }
}

void reveal(int i, int j, boolean revealAdjacent)
{
  if(tiles[i][j].isBomb)
  {
    
    tiles[i][j].isShowing = true;
    gameOn = false;
    gameEnd();
    println("nick is big stupe");
  }
  if(!withinBounds(i, j))
  {
    return;
  }
  tiles[i][j].reveal();
  if(tiles[i][j].getNearbyBombs() == 0 && revealAdjacent)
  {
            //Check first column for nearby tiles
        if(withinBounds(i - 1, j - 1) && tiles[i-1][j-1].getNearbyBombs() == 0 && !tiles[i-1][j-1].isShowing)
        {
          reveal(i-1, j -1, true);
        }else if(withinBounds(i-1, j - 1) && !tiles[i-1][j-1].isShowing)
        {
          reveal(i-1, j -1, false);
        }
        if(withinBounds(i - 1, j) && tiles[i-1][j].getNearbyBombs() == 0&& !tiles[i-1][j].isShowing)
        {
          reveal(i-1, j, true);
        }else if(withinBounds(i-1, j) && !tiles[i-1][j].isShowing)
        {
          reveal(i-1, j, false);
        }
        if(withinBounds(i - 1, j + 1) && tiles[i-1][j+1].getNearbyBombs() == 0 && !tiles[i-1][j+1].isShowing)
        {
          reveal(i-1, j +1, true);
        }
        else if(withinBounds(i -1 , j + 1) && !tiles[i-1][j+1].isShowing)
        {
          reveal(i - 1, j + 1, false);
        }
        //Check second column for nearby tiles
        if(withinBounds(i, j - 1) && tiles[i][j-1].getNearbyBombs() == 0 && !tiles[i][j-1].isShowing)
        {
          reveal(i, j -1, true);
        }
        else if(withinBounds(i, j - 1) && !tiles[i][j-1].isShowing)
        {
          reveal(i, j -1, false);
        }
        if(withinBounds(i, j + 1) && tiles[i][j+1].getNearbyBombs() == 0 && !tiles[i][j+1].isShowing)
        {
          reveal(i, j +1, true);
        }
        else if(withinBounds(i, j + 1) && !tiles[i][j+1].isShowing)
        {
          reveal(i, j +1, false);
        }
        //Check third column for nearby tiles
        if(withinBounds(i + 1, j - 1) && tiles[i+1][j-1].getNearbyBombs() == 0 && !tiles[i+1][j-1].isShowing)
        {
          reveal(i+1, j -1, true);
        }
        else if(withinBounds(i+1, j - 1) && !tiles[i+1][j-1].isShowing)
        {
          reveal(i+1, j -1, false);
        }
        if(withinBounds(i + 1, j) && tiles[i+1][j].getNearbyBombs() == 0 && !tiles[i+1][j].isShowing)
        {
          reveal(i+1, j, true);
        }
        else if(withinBounds(i+1, j) && !tiles[i+1][j].isShowing)
        {
          reveal(i+1, j , false);
        }
        if(withinBounds(i + 1, j + 1) && tiles[i+1][j+1].getNearbyBombs() == 0 && !tiles[i+1][j+1].isShowing)
        {
          reveal(i+1, j+1, true);
        }
        else if(withinBounds(i+1, j +1) && !tiles[i+1][j+1].isShowing)
        {
          reveal(i+1, j +1, false);
        }
  }
}
public void settings()
{
  fullScreen();
}
