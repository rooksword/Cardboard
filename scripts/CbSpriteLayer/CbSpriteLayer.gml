/// @param layer
/// @param xOffset
/// @param yOffset
/// @param zOffset
/// @param zAngle

function CbSpriteLayer(_layer, _xOffset, _yOffset, _zOffset, _zAngle)
{
    var _array = layer_get_all_elements(_layer);
    var _i = 0;
    repeat(array_length(_array))
    {
        var _asset = _array[_i];
        
        CbSpriteExt(layer_sprite_get_sprite(_asset), layer_sprite_get_index(_asset),
                    layer_sprite_get_x(_asset) + _xOffset, layer_sprite_get_y(_asset) + _yOffset, _zOffset,
                    layer_sprite_get_xscale(_asset), layer_sprite_get_yscale(_asset),
                    layer_sprite_get_angle(_asset), _zAngle,
                    layer_sprite_get_blend(_asset), layer_sprite_get_alpha(_asset),
                    false);
        
        ++_i;
    }
}