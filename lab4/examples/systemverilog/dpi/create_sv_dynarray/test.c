#include <stdlib.h>
#include "svdpi.h"
#include"dpiheader.h"

// this is the user define struct type to wrap up
// all the relelvant C data required for creating
// the SV dynamic array.

typedef struct {
   int  count;
   int* data;
} cdata_t;

static cdata_t*
create_aranged(int count)
{
    int i;
    cdata_t* cdata;

    cdata = (cdata_t*) malloc(sizeof(cdata_t));
    cdata->count =  count;
    cdata->data  =  (int*) malloc(count * sizeof(int));

    // initialize cdata to some known values, i.e. array indices themselves
    for (i = 0; i < count; ++i) {
        cdata->data[i] = i;
    }
    return cdata;
}

static void
cleanup_C_data(
    cdata_t* cdata)
{
    // cleanup
    if (cdata) {
        free(cdata->data);
    }
    free(cdata);
}

void create_sv_dynarray()
{
    cdata_t* cdata;
    int i;
    cdata = create_aranged(10);

    alloc_sv_dynarray(cdata->count * 2, (void*) cdata);
}

void fetch_sv_dynarray_data_from_C(void* cdata, const svOpenArrayHandle hout)
{
    cdata_t* s = (cdata_t*) cdata;

    int *out = (int *)svGetArrayPtr(hout);

    // transfer the existing C data to the new dynamic array

    memcpy(out, s->data, sizeof(int) * s->count);

    // assign some known values to the 3 new elements.
    int i, count;
    count = s->count;
    for (i = 0; i < count; i++) {
        out[count+i] = out[count-i-1];
    }

    cleanup_C_data(cdata);
}

// void add_data(int newdata, const svOpenArrayHandle hinout)
// {
//     cdata_t* cdata;
//     int i;

//     int *inout = (int *)svGetArrayPtr(hinout);
//     int size = svSize(hinout, 1);

//     int count = size+1;
//     cdata = (cdata_t*) malloc(sizeof(cdata_t));
//     cdata->count =  count;
//     cdata->data  =  (int*) malloc(count * sizeof(int));
//     for (i = 0; i < count-1; ++i) {
//         cdata->data[i] = inout[i];
//     }
//     cdata->data[count-1] = newdata;
    
//     // inout = (int*) malloc(count * sizeof(int));

//     inout = (int*) _expand(inout, count*4);

//     memcpy(inout, cdata->data, sizeof(int) * count);
// }