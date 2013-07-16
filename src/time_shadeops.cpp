#include <stdlib.h>
#include <time.h>
#include "RslPlugin.h"

extern "C" {

RSLEXPORT int time_getTime(RslContext* rslContext,
                             int argc, const RslArg* argv[])
{
    RslFloatIter result(argv[0]);
    *result = (float)clock() / CLOCKS_PER_SEC;
    return 0;
}


RSLEXPORT int first_sample(RslContext* rslContext,
                             int argc, const RslArg* argv[])
{
    RslFloatIter result(argv[0]);
    *result = 1.0;

    int numVals = argv[0]->NumValues();
    for (int i = 1; i < numVals; ++i) {
        *result = 0.0;
    }
    
    return 0;
}


static RslFunction time_functions[] =
{
    {"uniform float time()", time_getTime,  NULL, NULL, NULL, NULL},
    {"varying float first_sample()", first_sample,  NULL, NULL, NULL, NULL},
    {NULL}
};
RSLEXPORT RslFunctionTable RslPublicFunctions = time_functions;

}; /* extern "C" */