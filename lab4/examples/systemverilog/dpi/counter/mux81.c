/*
 * Copyright 1991-2015 Mentor Graphics Corporation
 *
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 * Simple SystemVerilog DPI Example - C model 8-to-1 multiplexer
 */
#include "mux81.h"

int counter25 (
    int curr
)
{
    if (curr < 24) {
        return curr+1;
    }
    else{
        return 0;
    }
}