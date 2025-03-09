#Requires AutoHotkey v2.0

; Random WASD Key Holder
; Press F1 to start, F2 to stop
; Randomly holds A, W, S, or D keys for X seconds, with X second pauses between

; Initialize variable to track if the script is running
isRunning := false
currentKey := ""

global HOLD_TIME_MIN_SECONDS := 1000
global HOLD_TIME_MAX_SECONDS := 3000

global RELEASE_WAIT_TIME_MIN_SECONDS := 500
global RELEASE_WAIT_TIME_MAX_SECONDS := 5000


ToolTip("AHK AWSD Fake Walker`n- F1 - Start`n- F2 - Stop")
SetTimer(RemoveToolTip, -1000)


; F1 to start the random key holding
F1::
{
    global isRunning
    isRunning := true
    ToolTip("[RUNNING SCRIPT] Press F2 to stop")
    SetTimer(RemoveToolTip, -3000)
    RandomKeyHold()
    return
}

; F2 to stop the random key holding
F2::
{
    global isRunning, currentKey
    isRunning := false
    
    ; Release any currently held key
    if (currentKey != "")
        Send("{" currentKey " up}")
    
    currentKey := ""
    ToolTip("[STOPPED SCRIPT] Press F1 to start")
    SetTimer(RemoveToolTip, -3000)
    return
}

; Function to remove tooltips
RemoveToolTip()
{
    ToolTip()
}

; Function to handle random key holding
RandomKeyHold()
{
    global isRunning, currentKey
    if (!isRunning)
        return
    
    ; Array of keys to hold
    keys := ["a", "w", "s", "d"]
    
    ; Select a random key
    randomKey := keys[Random(1, keys.Length)]
    currentKey := randomKey
    
    ; Hold down the random key
    Send("{" randomKey " down}")
    
    ; Generate random hold duration
    holdDuration := Random(HOLD_TIME_MIN_SECONDS, HOLD_TIME_MAX_SECONDS)
    ToolTip("[HOLDING: " randomKey "] " Round(holdDuration/1000, 1) " seconds")
    
    ; Set timer to release the key
    SetTimer(ReleaseKey, -holdDuration)
    return
}

; Function to release the key and schedule the next hold
ReleaseKey()
{
    global isRunning, currentKey
    if (!isRunning)
        return
    
    ; Release the currently held key
    if (currentKey != "")
        Send("{" currentKey " up}")
    
    currentKey := ""
    
    ; Generate random pause
    pauseDuration := Random(RELEASE_WAIT_TIME_MIN_SECONDS, RELEASE_WAIT_TIME_MAX_SECONDS)
    ToolTip("[RELEASE] " Round(pauseDuration/1000, 1) " seconds")
    
    ; Schedule the next key hold after the pause
    SetTimer(RandomKeyHold, -pauseDuration)
}