/// Sets up a simple orthographic rendering state with alpha testing
/// 
/// This function is purely optional and provided as a helpful quick start function for developers new to 3D graphics
/// This function additionally enables use of CardboardSpriteBillboard*()
/// 
/// @param width               Width of the orthographic projection
/// @param height              Height of the orthographic projection
/// @param fromX               x-coordinate of the camera
/// @param fromY               y-coordinate of the camera
/// @param fromZ               z-coordinate of the camera
/// @param toX                 x-coordinate of the camera's focal point
/// @param toY                 y-coordinate of the camera's focal point
/// @param toZ                 z-coordinate of the camera's focal point
/// @param [axonometric=true]  Optional, defaults to <true>; whether to use axonometric projection. This ensures sprites are never "squashed" regardless of the camera pitch angle
/// @param [alphaTestRef=128]  Optional, defaults to 128; the alpha test threshold. Pixels with alpha values below this threshold will be discarded

function CardboardRenderStateSet(_width, _height, _fromX, _fromY, _fromZ, _toX, _toY, _toZ, _axonometric = undefined, _alphaTestRef = 128)
{
    __CARDBOARD_GLOBAL
    
    //Track matrices that are being used
    _global.__oldRenderStateMatrixWorld      = matrix_get(matrix_world); 
    _global.__oldRenderStateMatrixView       = matrix_get(matrix_view); 
    _global.__oldRenderStateMatrixProjection = matrix_get(matrix_projection);
    
    //Store the alpha test value for use in other shaders
    _global.__alphaTestRef = _alphaTestRef;
    
    //Set up GPU state
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    gpu_set_cullmode((CARDBOARD_WRITE_NORMALS && _global.__doubleSided)? cull_clockwise : cull_noculling);
    gpu_set_alphatestenable(true);
    gpu_set_alphatestref(_alphaTestRef);
    
    CardboardViewMatrixSet(_fromX, _fromY, _fromZ, _toX, _toY, _toZ, _axonometric);
    matrix_set(matrix_projection, matrix_build_projection_ortho(_width, _height, -3000, 3000));
}