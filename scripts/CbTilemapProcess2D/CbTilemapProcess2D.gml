/// @param ruleset
/// @param tilemapBelow
/// @param tilemap
/// @param tilemapAbove
/// @param xOffset
/// @param yOffset
/// @param zOffset
/// @param xSize
/// @param ySize
/// @param zSize

function CbTilemapProcess2D(_ruleset, _tilemapBelow, _tilemap, _tilemapAbove, _xOffset, _yOffset, _zOffset, _xSize, _ySize, _zSize)
{
    if (is_string(_tilemapBelow)) _tilemapBelow = layer_tilemap_get_id(layer_get_id(_tilemapBelow));
    if (is_string(_tilemap     )) _tilemap      = layer_tilemap_get_id(layer_get_id(_tilemap));
    if (is_string(_tilemapAbove)) _tilemapAbove = layer_tilemap_get_id(layer_get_id(_tilemapAbove));
    
    var _oldDoubleSided = CbSystemDoubleSidedGet();
    CbSystemDoubleSidedSet(false);
    
    var _tilemapWidth  = tilemap_get_width(  _tilemap);
    var _tilemapHeight = tilemap_get_height( _tilemap);
    var _tilemapDepth  = 1;
    
    var _tileset      = tilemap_get_tileset(_tilemap);
    var _tilesetData  = __CbGetTileset(_tileset);
    var _tilesetWidth = _tilesetData.__tilesetWidth;
    
    var _tilesetRuleset = _ruleset.__tilesetDict[$ _tileset];
    if (is_struct(_tilesetRuleset))
    {
        var _tileDict  = _tilesetRuleset.__dictionary;
        var _hasBottom = not _tilesetRuleset.__bottomless;
        var _hasBack   = not _tilesetRuleset.__backless;
        var _hasSides  = not _tilesetRuleset.__sideless;
    }
    else
    {
        var _tileDict  = {};
        var _hasBottom = true;
        var _hasBack   = true;
        var _hasSides  = true;
    }
    
    var _zMap   = 0;
    var _zWorld = _zOffset + _zSize;
    
    var _yWorld = _yOffset;
    var _yMap = 0;
    repeat(_tilemapHeight)
    {
        var _xWorld = _xOffset;
        var _xMap = 0;
        repeat(_tilemapWidth)
        {
            var _tileIndex = tilemap_get(_tilemap, _xMap, _yMap);
            if (_tileIndex != 0)
            {
                if (_hasSides && ((_xMap <= 0) || (tilemap_get(_tilemap, _xMap-1, _yMap) <= 0)))
                {
                    var _indexArray = _tileDict[$ _tileIndex];
                    if (is_array(_indexArray))
                    {
                        var _xTile = _indexArray[0];
                        var _yTile = _indexArray[1];
                    }
                    else
                    {
                        var _xTile = _tileIndex mod _tilesetWidth;
                        var _yTile = _tileIndex div _tilesetWidth;
                    }
                    
                    //Left
                    CbTileQuad(_tileset, _xTile, _yTile,
                               _xWorld, _yWorld,          _zWorld,
                               _xWorld, _yWorld + _ySize, _zWorld,
                               _xWorld, _yWorld,          _zWorld - _zSize,
                               _xWorld, _yWorld + _ySize, _zWorld - _zSize,
                               c_white, 1);
                }
                
                if (_hasSides && ((_xMap >= _tilemapHeight-1) || (tilemap_get(_tilemap, _xMap+1, _yMap) <= 0)))
                {
                    var _indexArray = _tileDict[$ _tileIndex];
                    if (is_array(_indexArray))
                    {
                        var _xTile = _indexArray[2];
                        var _yTile = _indexArray[3];
                    }
                    else
                    {
                        var _xTile = _tileIndex mod _tilesetWidth;
                        var _yTile = _tileIndex div _tilesetWidth;
                    }
                    
                    //Right
                    CbTileQuad(_tileset, _xTile, _yTile,
                               _xWorld + _xSize, _yWorld + _ySize, _zWorld,
                               _xWorld + _xSize, _yWorld,          _zWorld,
                               _xWorld + _xSize, _yWorld + _ySize, _zWorld - _zSize,
                               _xWorld + _xSize, _yWorld,          _zWorld - _zSize,
                               c_white, 1);
                }
                
                if (_hasBack && ((_yMap <= 0) || (tilemap_get(_tilemap, _xMap, _yMap-1) <= 0)))
                {
                    var _indexArray = _tileDict[$ _tileIndex];
                    if (is_array(_indexArray))
                    {
                        var _xTile = _indexArray[4];
                        var _yTile = _indexArray[5];
                    }
                    else
                    {
                        var _xTile = _tileIndex mod _tilesetWidth;
                        var _yTile = _tileIndex div _tilesetWidth;
                    }
                    
                    //Up
                    CbTileQuad(_tileset, _xTile, _yTile,
                               _xWorld + _xSize, _yWorld, _zWorld,
                               _xWorld,          _yWorld, _zWorld,
                               _xWorld + _xSize, _yWorld, _zWorld - _zSize,
                               _xWorld,          _yWorld, _zWorld - _zSize,
                               c_white, 1);
                }
                
                if ((_yMap >= _tilemapWidth-1) || (tilemap_get(_tilemap, _xMap, _yMap+1) <= 0))
                {
                    var _indexArray = _tileDict[$ _tileIndex];
                    if (is_array(_indexArray))
                    {
                        var _xTile = _indexArray[6];
                        var _yTile = _indexArray[7];
                    }
                    else
                    {
                        var _xTile = _tileIndex mod _tilesetWidth;
                        var _yTile = _tileIndex div _tilesetWidth;
                    }
                    
                    //Down
                    CbTileQuad(_tileset, _xTile, _yTile,
                               _xWorld,          _yWorld + _ySize, _zWorld,
                               _xWorld + _xSize, _yWorld + _ySize, _zWorld,
                               _xWorld,          _yWorld + _ySize, _zWorld - _zSize,
                               _xWorld + _xSize, _yWorld + _ySize, _zWorld - _zSize,
                               c_white, 1);
                }
                
                if (_hasBottom && ((_zMap <= 0) || (_tilemapBelow == undefined) || (tilemap_get(_tilemapBelow, _xMap, _yMap) <= 0)))
                {
                    var _indexArray = _tileDict[$ _tileIndex];
                    if (is_array(_indexArray))
                    {
                        var _xTile = _indexArray[8];
                        var _yTile = _indexArray[9];
                    }
                    else
                    {
                        var _xTile = _tileIndex mod _tilesetWidth;
                        var _yTile = _tileIndex div _tilesetWidth;
                    }
                    
                    //Bottom
                    CbTileQuad(_tileset, _xTile, _yTile,
                               _xWorld,          _yWorld,          _zWorld - _zSize,
                               _xWorld,          _yWorld + _ySize, _zWorld - _zSize,
                               _xWorld + _xSize, _yWorld,          _zWorld - _zSize,
                               _xWorld + _xSize, _yWorld + _ySize, _zWorld - _zSize,
                               c_white, 1);
                }
                
                if ((_zMap >= _tilemapDepth-1) || (_tilemapAbove == undefined) || (tilemap_get(_tilemapAbove, _xMap, _yMap) <= 0))
                {
                    var _indexArray = _tileDict[$ _tileIndex];
                    if (is_array(_indexArray))
                    {
                        var _xTile = _indexArray[10];
                        var _yTile = _indexArray[11];
                    }
                    else
                    {
                        var _xTile = _tileIndex mod _tilesetWidth;
                        var _yTile = _tileIndex div _tilesetWidth;
                    }
                    
                    //Above
                    CbTileQuad(_tileset, _xTile, _yTile,
                               _xWorld,          _yWorld,          _zWorld,
                               _xWorld + _xSize, _yWorld,          _zWorld,
                               _xWorld,          _yWorld + _ySize, _zWorld,
                               _xWorld + _xSize, _yWorld + _ySize, _zWorld,
                               c_white, 1);
                }
            }
            
            _xWorld += _xSize;
            ++_xMap;
        }
        
        _yWorld += _ySize;
        ++_yMap;
    }
    
    CbSystemDoubleSidedSet(_oldDoubleSided);
}