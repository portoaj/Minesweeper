int size = 100;
Tile [][] tiles;
int realTiles = 0;
boolean gameOn = true;
void setup()
{
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
      if(floor(random(6)) == 0)
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
        println("k");
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
void mouseClicked()
{
  if(mouseButton == LEFT  && gameOn)
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
  else if (mouseButton == RIGHT && gameOn)
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
        }else if(withinBounds(i, j + 1) && !tiles[i][j+1].isShowing)
        {
          reveal(i, j +1, false);
        }
        //Check third column for nearby tiles
        if(withinBounds(i + 1, j - 1) && tiles[i+1][j-1].getNearbyBombs() == 0 && !tiles[i+1][j-1].isShowing)
        {
          reveal(i+1, j -1, true);
        }else if(withinBounds(i+1, j - 1) && !tiles[i+1][j-1].isShowing)
        {
          reveal(i+1, j -1, false);
        }
        if(withinBounds(i + 1, j) && tiles[i+1][j].getNearbyBombs() == 0 && !tiles[i+1][j].isShowing)
        {
          reveal(i+1, j, true);
        }else if(withinBounds(i+1, j) && !tiles[i+1][j].isShowing)
        {
          reveal(i+1, j , false);
        }
        if(withinBounds(i + 1, j + 1) && tiles[i+1][j+1].getNearbyBombs() == 0 && !tiles[i+1][j+1].isShowing)
        {
          reveal(i+1, j+1, true);
        }else if(withinBounds(i+1, j +1) && !tiles[i+1][j+1].isShowing)
        {
          reveal(i+1, j +1, false);
        }
  }
}
public void settings()
{
  size(1600,1600);
}
