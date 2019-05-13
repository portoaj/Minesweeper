class Tile{
  int x;
  int y;
  int size;
  boolean isBomb;
  int nearbyBombs;
  boolean isShowing;
  boolean bombMarker;
  Tile(int _x, int _y, int _size)
  {
    x = _x;
    y = _y;
    size = _size;
    isBomb = false;
    nearbyBombs = 0;
    bombMarker = false;
  }
  boolean revealedAsReal()
  {
    return (isShowing && !isBomb);
  }
  void showTile()
  { 
    if(bombMarker)
    {
      fill(40); 
      rect(x, y, size, size);
    }
    else
    {
      if(isShowing == false)
      {
       fill(150); 
       rect(x, y, size, size);
      }
      else
      {
        if(isBomb == false)
        {
          fill(200);
          rect(x, y, size, size);
        }
        else
        {
          fill(255, 0, 0);
          rect(x, y, size, size);
        }
        fill(100);
        if(nearbyBombs != 0 && !isBomb)
        {
          textSize(125);
          text(nearbyBombs,x,y + size);    
        }
      }
    }
  }
  public int getNearbyBombs()
  {
    return nearbyBombs;
  }
  PVector getPos()
  {
    return new PVector(x + size/2,y + size/2);
  }
  void setAsBomb()
  {
    isBomb = true;
  }
  void addNearbyBomb()
  {
    nearbyBombs++;
  }
  void toggleBombMarker()
  {
    if(!bombMarker)
    {
      bombMarker = true;
    }
    else
    {
      bombMarker = false;
    }
  }
  public boolean getIsShowing()
  {
    return isShowing;
  }
  void reveal()
  {
    isShowing = true;
  }
}
