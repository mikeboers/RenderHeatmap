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


static RslFunction time_functions[] =
{
    {"uniform float time()", time_getTime,  NULL, NULL, NULL, NULL},
    // {"uniform float time_sleep(float)", pxMaxGridFloat,  NULL, NULL, NULL, NULL},
    {NULL}
};
RSLEXPORT RslFunctionTable RslPublicFunctions = time_functions;

}; /* extern "C" */