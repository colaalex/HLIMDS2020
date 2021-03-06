/* MTI_DPI */

/*
 * Copyright 2002-2015 Mentor Graphics Corporation.
 *
 * Note:
 *   This file is automatically generated.
 *   Please do not edit this file - you will lose your edits.
 *
 * Settings when this file was generated:
 *   PLATFORM = 'win32'
 */
#ifndef INCLUDED_DPI_ARRAY_XOR
#define INCLUDED_DPI_ARRAY_XOR

#ifdef __cplusplus
#define DPI_LINK_DECL  extern "C" 
#else
#define DPI_LINK_DECL 
#endif

#include "svdpi.h"



DPI_LINK_DECL DPI_DLLESPEC
void
xor_2st_6416(
    svBitVecVal* z,
    const svBitVecVal* i);

DPI_LINK_DECL DPI_DLLESPEC
void
xor_2st_6416a(
    svBitVecVal* z,
    const svBitVecVal* i);

DPI_LINK_DECL DPI_DLLESPEC
void
xor_4st_6416(
    svLogicVecVal* z,
    const svLogicVecVal* i);

DPI_LINK_DECL DPI_DLLESPEC
void
xor_longint16(
    uint64_t* z,
    const uint64_t* i);

#endif 
