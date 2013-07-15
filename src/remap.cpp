#include <iostream>
#include <stdio.h>

#include <Magick++.h> 
#include <dtex.h>

using namespace std;

using namespace Magick; 


int main(int argc, char **argv) {

    DtexCache *inCache;
    DtexImage *inImage;
    DtexFile *inFile;
    DtexPixel *inPixel;
    Image outImage;
    int width, height, channels;
    float *inData, *outData;

    if (argc < 3) {
        cerr << "Must supply input and output paths." << endl;
        return 1;
    }

    InitializeMagick(argv[0]);

    inCache = DtexCreateCache(256, NULL);

    if (DtexOpenFile(argv[1], "rb", inCache, &inFile) != DTEX_NOERR) {
        fprintf(stderr, "Unable to open input file %s, skipping it.\n", argv[1]);
        return 2;
    }
    if (DtexGetImageByIndex(inFile, 0, &inImage) != DTEX_NOERR) {
        fprintf(stderr, "Unable to access image zero in input file %s, skipping.\n", argv[1]);
        DtexClose(inFile);
        return 3;
    }

    width = DtexWidth(inImage);
    height = DtexHeight(inImage);
    channels = DtexNumChan(inImage);

    outImage.size(Geometry(width, height));
    outImage.magick("K");

    // Invariants.
    inData = (float*) malloc(channels * 2 * sizeof(float));
    outData = (float*) malloc(width * height * 3 * 2 * sizeof(float));
    inPixel = DtexMakePixel(channels);

    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {

            DtexClearPixel(inPixel, channels);
            if (DtexGetPixel(inImage, x, y, inPixel) != DTEX_NOERR) {
                fprintf(stderr, "Unable to get input pixel at %d %d from %s.\n", x, y, argv[1]);
                continue;
            }

            int nPoints = DtexPixelGetNumPoints(inPixel);
            float value = 0;
            for (int i = 0; i < nPoints; i++) {
                float z;
                DtexPixelGetPoint(inPixel, i, &z, inData);
                value += inData[0];
            }
            outData[3 * (x + y * width) + 0] = value;
            outData[3 * (x + y * width) + 1] = value;
            outData[3 * (x + y * width) + 2] = value;
        }
    }

    outImage.read(width, height, "RGB", FloatPixel, outData);
    outImage.write(argv[2]);

    return 0;
}
