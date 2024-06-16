#macro __CB_BUILD_VERSION  "3.0.0"
#macro __CB_BUILD_DATE     "2024-06-16"

#macro __CB_MAX_IMAGES  1024



__CbBuildInitialize();

function __CbBuildInitialize()
{
    static _initialized = false;
    if (_initialized) return;
    _initialized = true;
    
    __CbBuildTrace("Welcome to Cardboard Build by Juju Adams! This is version " + __CB_BUILD_VERSION + ", " + __CB_BUILD_DATE);
    
    __CB_GLOBAL_BUILD
    
    //Set up vertex formats
    with(_global.__batch)
    {
        if (CB_WRITE_NORMALS)
        {
            vertex_format_begin();
            vertex_format_add_position_3d(); //12 bytes
            vertex_format_add_normal();      //12 bytes
            vertex_format_add_color();       // 4 bytes
            vertex_format_add_texcoord();    // 8 bytes
            __vertexFormat = vertex_format_end();
        }
        else
        {
            vertex_format_begin();
            vertex_format_add_position_3d(); //12 bytes
            vertex_format_add_color();       // 4 bytes
            vertex_format_add_texcoord();    // 8 bytes
            __vertexFormat = vertex_format_end();
        }
        
        vertex_begin(__vertexBuffer, __vertexFormat);
    }
    
    //Cache texture page index information for every image of every sprite
    var _texturePageIndexMap = _global.__texturePageIndexMap;
    var _sprite = 0;
    while(sprite_exists(_sprite))
    {
        var _framesArray = sprite_get_info(_sprite).frames;
        
        var _number = sprite_get_number(_sprite);
        if (_number > __CB_MAX_IMAGES) __CbBuildError("Image number cannot exceed ", __CB_MAX_IMAGES, " (", sprite_get_name(_sprite), ")");
        
        var _image = 0;
        repeat(_number)
        {
            var _uvs = sprite_get_uvs(_sprite, _image);
            
            var _left   = -sprite_get_xoffset(_sprite) + _uvs[4];
            var _top    = -sprite_get_yoffset(_sprite) + _uvs[5];
            var _right  = _left + _uvs[6]*sprite_get_width(_sprite);
            var _bottom = _top + _uvs[7]*sprite_get_height(_sprite);
            
            _texturePageIndexMap[? __CB_MAX_IMAGES*real(_sprite) + _image] = {
                texturePointer: sprite_get_texture(_sprite, _image),
                textureIndex:   _framesArray[_image].texture,
                
                left:   _left,
                top:    _top,
                right:  _right,
                bottom: _bottom,
                
                u0: _uvs[0],
                v0: _uvs[1],
                u1: _uvs[2],
                v1: _uvs[3],
            };
            
            ++_image;
        }
        
        ++_sprite;
    }
}