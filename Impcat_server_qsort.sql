/*********************************************************************************************/
// FUNCTION qsort 
// Implementation of quicksort using a stack as IPL is not good at recursion :) 
/*********************************************************************************************/ 

Function qsort(Array) {
    Hi = Length(Array)-1;
    if (Hi < 1) { exit();} // Nothing to do on single element or empty array 
    stack = {0,Hi}; // Stack initial Lo, Hi
    top = 1; 
    while (top > 0) { 
        Hi = stack[top];   // Pop the top for next
        Lo = stack[top-1]; // Lo and Hi values
        top = top - 2;     // and move the stack pointer
        _Partition(Array, Lo, Hi, P); // Move pivot element to correct position (P returned)
 
        if ( (P-1) > 1 ) { // Elements to the left to sort
            stack[top+1] = 0;  
            stack[top+2] = P-1;
            top = top + 2;
        }
        if ( (P+1) < Hi ) { // Elements to the right to sort
            if (top+1 >= Length(stack)) {stack = stack + {0,0};} // Extend the stack 
            stack[top+1] = P+1;
            stack[top+2] = Hi;
            top = top + 2; 
        }
    }
}

Function _Partition(Array, Lo, Hi, P) { 
    Pivot = Array[Hi];
    i = Lo;
    j = Lo-1;
    while (j < Hi-1) {
        j = j + 1;
        if (Array[j] < Pivot) {
            if (i != j) {
                Temp     = Array[i];
                Array[i] = Array[j];
                Array[j] = Temp;
            }  
            i = i + 1; 
        } 
    }
    Temp      = Array[i];
    Array[i]  = Array[Hi];
    Array[Hi] = Temp;
    P = i; 
} 
