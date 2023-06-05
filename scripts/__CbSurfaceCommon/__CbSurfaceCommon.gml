#macro __CB_SURFACE_COMMON_TEXTURE ;\
var _texture = surface_get_texture(_surface);\
;\
;\//Break the batch if we've swapped texture
if (_texture != _global.__batch.__texturePointer)\
{\
    __CbBatchComplete();\
    _global.__batch.__texturePointer = _texture;\
    _global.__batch.__textureIndex   = undefined;\
}