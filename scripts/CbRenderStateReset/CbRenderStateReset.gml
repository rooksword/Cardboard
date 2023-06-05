/// Resets the GPU render state for the given pass
/// This will set matrices, z-testing, and the current shader

function CbRenderStateReset()
{
    __CB_GLOBAL
    
    CbRenderShaderReset();
    
    //Reset GPU state
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    gpu_set_cullmode(cull_noculling);
    gpu_set_alphatestenable(false);
    
    with(_global.__oldRenderState)
    {
        //Restore the old matrices we've been using
        __set = false;
        matrix_set(matrix_world,      __worldMatrix);
        matrix_set(matrix_view,       __viewMatrix);
        matrix_set(matrix_projection, __projectionMatrix);
    }
}