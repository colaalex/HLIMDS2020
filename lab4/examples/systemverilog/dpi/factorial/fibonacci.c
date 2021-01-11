/*
 * Copyright 1991-2015 Mentor Graphics Corporation
 *
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 * Simple SystemVerilog DPI Example - C function to compute fibonacci seq.
 */
#include "fibonacci.h"
#include <stdio.h>

int factorial(int N, unsigned int sign)
{
    int mult;

    if (sign == 1)
        mult = -1;
    else
        mult = 1;

    // printf("sign: %d \n", sign);
    // printf("mult: %d \n", mult);
    // printf("mult*1: %d \n", mult*1);

    if (N == 0)
        return 1;
    else if (N == 1)
        return mult * 1;
    else
    {
        return mult * N * factorial(N-1, sign);
    }
    
}

// unsigned int fibonacci(unsigned int N)
// {
//     unsigned int a, b;
//     unsigned int c;

//     a = fibonacci(N-2);
//     b = fibonacci(N-1);

//     if (N < 3)
//         return 1;
//     else
//     {
//         a = fibonacci(N-2);
//         b = fibonacci(N-1);
//         return a+b;
//     }
    
// }
