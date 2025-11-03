PROGRAM MorningRoutine
VAR
    // Time tracking
    delay : TIME := T#0S;
    
    // Alarm and sleep variables
    alarmSet : BOOL := FALSE;
    snoozeCount : INT := 0;
    stillTired : BOOL := TRUE;
    
    // Breakfast and lunch variables
    isHungry : BOOL := TRUE;
    needLunch : BOOL := FALSE;
    toppingCount : INT := 0;
    
    // Available toppings
    speculoosAvailable : BOOL := TRUE;
    chickenFiletAvailable : BOOL := TRUE;
    peanutButterAvailable : BOOL := TRUE;
    
    // Transport conditions
    trafficLightRed : BOOL := FALSE;
    bridgeOpen : BOOL := FALSE;
    
    // State machine variables
    currentState : INT := 0;
    nextState : INT := 0;
    toiletNeeded : BOOL := FALSE;
    
    // Program flow control
    programActive : BOOL := TRUE;
END_VAR

// State machine implementation
CASE currentState OF
    0: // Initialize
        delay := T#0S;
        currentState := 10;
    
    10: // Sleeping and Alarm Check
        IF alarmSet THEN
            IF snoozeCount < 2 AND stillTired THEN
                delay := delay + T#5M;
                snoozeCount := snoozeCount + 1;
            ELSE
                currentState := 20;  // Wake up
            END_IF
        ELSE
            IF NOT stillTired THEN
                currentState := 20;  // Natural wake up
            END_IF
        END_IF;
    
    20: // First Toilet Check
        IF toiletNeeded THEN
            delay := delay + T#2M;
        END_IF;
        currentState := 30;
    
    30: // Breakfast Loop
        IF isHungry THEN
            // Simulate eating breakfast
            isHungry := FALSE;
        ELSE
            currentState := 40;
        END_IF;
    
    40: // Lunch Preparation
        IF needLunch THEN
            WHILE toppingCount < 4 DO
                // Speculoos check
                IF speculoosAvailable THEN
                    toppingCount := toppingCount + 1;
                END_IF;
                
                // Chicken filet check
                IF chickenFiletAvailable THEN
                    toppingCount := toppingCount + 1;
                END_IF;
                
                // Peanut butter check
                IF peanutButterAvailable THEN
                    toppingCount := toppingCount + 1;
                END_IF;
            END_WHILE;
        END_IF;
        currentState := 50;
    
    50: // Second Toilet Check
        IF toiletNeeded THEN
            delay := delay + T#2M;
        END_IF;
        currentState := 60;
    
    60: // Transport and Traffic
        // Traffic light check
        IF trafficLightRed THEN
            delay := delay + T#2M;
        END_IF;
        
        // Bridge check
        IF bridgeOpen THEN
            delay := delay + T#5M;
        END_IF;
        
        currentState := 70;
    
    70: // Train Check
        IF delay > T#10M THEN
            // Missed train, wait for next one
            delay := delay + T#30M;
        END_IF;
        currentState := 80;
    
    80: // Arrived at School
        programActive := FALSE;
END_CASE;

END_PROGRAM

CONFIGURATION Config1
    TASK Main(Interval := T#100MS, Priority := 1);
    PROGRAM Inst1 WITH Main: MorningRoutine;
END_CONFIGURATION