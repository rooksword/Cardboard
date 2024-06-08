function CbCamera() constructor
{
    __xFrom = 0;
    __yFrom = 128;
    __zFrom = 128;
    
    __xTo = 0;
    __yTo = 128;
    __zTo = 128;
    
    __xUp = 0;
    __yUp = 0;
    __zUp = 1;
    
    __orthographic = true;
    __axonometric  = true;
    __zTilt        = true;
    
    __fieldOfView  = 90;
    __near         = -1024;
    __far          =  1024;
    
    __width  = surface_get_width( application_surface);
    __height = surface_get_height(application_surface);
    
    __billboardYawSetFunc = CbBillboardYawSet;
    
    static SetFrom = function(_x, _y, _z)
    {
        __xFrom = _x;
        __yFrom = _y;
        __zFrom = _z;
        
        if (__billboardYawSetFunc != undefined)
        {
            __billboardYawSetFunc(__xFrom, __yFrom, __xTo, __yTo);
        }
    }
    
    static GetFrom = function()
    {
        static _result = {};
        _result.x = __xFrom;
        _result.y = __yFrom;
        _result.z = __zFrom;
        return _result;
    }
    
    static SetTo = function(_x, _y, _z)
    {
        __xTo = _x;
        __yTo = _y;
        __zTo = _z;
        
        if (__billboardYawSetFunc != undefined)
        {
            __billboardYawSetFunc(__xFrom, __yFrom, __xTo, __yTo);
        }
    }
    
    static GetTo = function()
    {
        static _result = {};
        _result.x = __xTo;
        _result.y = __yTo;
        _result.z = __zTo;
        return _result;
    }
    
    static SetUp = function(_x, _y, _z)
    {
        __xUp = _x;
        __yUp = _y;
        __zUp = _z;
    }
    
    static GetUp = function()
    {
        static _result = {};
        _result.x = __xUp;
        _result.y = __yUp;
        _result.z = __zUp;
        return _result;
    }
    
    static SetSize = function(_width, _height)
    {
        __width  = _width;
        __height = _height;
    }
    
    static GetSize = function()
    {
        static _result = {};
        _result.width  = __width;
        _result.height = __height;
        return _result;
    }
    
    static SetOrthographic = function(_near = undefined, _far = undefined)
    {
        __orthographic = true;
        
        if (_near != undefined) __near = _near;
        if (_far  != undefined) __far  = _far;
    }
    
    static SetPerspective = function(_fieldOfView = undefined, _near = undefined, _far = undefined)
    {
        __orthographic = false;
        
        if (_fieldOfView != undefined) __fieldOfView = _fieldOfView;
        if (_near        != undefined) __near        = _near;
        if (_far         != undefined) __far         = _far;
    }
    
    static GetProjection = function()
    {
        static _result = {};
        _result.orthographic = __orthographic;
        _result.fieldOfView  = __fieldOfView;
        _result.near         = __near;
        _result.far          = __far;
        return _result;
    }
    
    static SetZTilt = function(_state)
    {
        __zTilt = _state;
    }
    
    static GetZTilt = function()
    {
        return __zTilt;
    }
    
    static SetAxonometric = function(_state)
    {
        __axonometric = _state;
    }
    
    static GetAxonometric = function()
    {
        return __axonometric;
    }
    
    static GetViewMatrix = function()
    {
        var _coeff = __CB_ON_OPENGL? -1 : 1;
        
        if (__CB_ON_OPENGL && __orthographic) _coeff = 1;
        
        if (__zTilt)
        {
            return CbCameraBuildZTiltViewMatrix(__xFrom, __yFrom, __zFrom, __xTo, __yTo, __zTo, __axonometric, _coeff*__xUp, _coeff*__yUp, _coeff*__zUp);
        }
        else
        {
            return matrix_build_lookat(__xFrom, __yFrom, __zFrom, __xTo, __yTo, __zTo, _coeff*__xUp, _coeff*__yUp, _coeff*__zUp);
        }
    }
    
    static GetProjectionMatrix = function()
    {
        var _coeff = __CB_ON_OPENGL? -1 : 1;
        
        if (__orthographic)
        {
            return matrix_build_projection_ortho(__width, _coeff*__height, __near, __far);
        }
        else
        {
            return matrix_build_projection_perspective_fov(__fieldOfView, _coeff*__width/__height, __near, __far);
        }
    }
    
    static ApplyViewMatrix = function()
    {
        matrix_set(matrix_view, GetViewMatrix());
    }
    
    static ApplyProjectionMatrix = function()
    {
        matrix_set(matrix_projection, GetProjectionMatrix());
    }
    
    static GetFrustrumCoords = function()
    {
        return CbCameraGetFrustrumCoords(GetViewMatrix(), GetProjectionMatrix());
    }
}