/// Turns auto-batching on or off
/// 
/// @param state  Whether to turn on auto-batching

function CbBatchAutoSet(_state)
{
    __CB_GLOBAL_BUILD
    
    _global.__batch.__auto = _state;
}