// Program supercosmos_binary.c
// Aim: Read a SuperCOSMOS binary data file and output a CSV file
//
// Python struct module format from readSSABinary.py:
// '<6q f 7d 5f b 12f 5b 4f 8i 8f'
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {

    long long x6q[6];
    float xf[1];
    double x7d[7];
    float x5f[5];
    signed char xb[1];
    float x12f[12];
    signed char x5b[5];
    float x4f[4];
    int x8i[8];
    float x8f[8];

    int nx6q;
    int nxf;
    int nx7d;
    int nx5f;
    int nxb;
    int nx12f;
    int nx5b;
    int nx4f;
    int nx8i;
    int nx8f;

    FILE *fptr;
    FILE *fptr_try;
    FILE *fptr_out;
    int i;
    long long num_rows;

    if (argc != 3) {
        printf("usage: supercosmos_binary input_file output_file\n");
        exit(1);
    }

    fptr = fopen(argv[1], "rb");
    if (fptr == NULL) {
        printf("error: could not open input file %s\n", argv[1]);
        exit(1);
    }

    printf("info:input_file=%s\n", argv[1]);

    fptr_try = fopen(argv[2], "r");
    if (fptr_try != NULL) {
        printf("error: output file exists %s\n", argv[2]);
        fclose(fptr_try);
        exit(1);
    }

    fptr_out = fopen(argv[2], "w");
    if (fptr_out == NULL) {
        printf("error: could not open output file %s\n", argv[2]);
        exit(1);
    }

    printf("info:output_file=%s\n", argv[2]);

    num_rows = 0;
    // start loop to read rows
    while (1) {

        // read binary data
        nx6q = fread(x6q, sizeof(long long), 6, fptr);
        nxf = fread(xf, sizeof(float), 1, fptr);
        nx7d = fread(x7d, sizeof(double), 7, fptr);
        nx5f = fread(x5f, sizeof(float), 5, fptr);
        nxb = fread(xb, sizeof(signed char), 1, fptr);
        nx12f = fread(x12f, sizeof(float), 12, fptr);
        nx5b = fread(x5b, sizeof(signed char), 5, fptr);
        nx4f = fread(x4f, sizeof(float), 4, fptr);
        nx8i = fread(x8i, sizeof(int), 8, fptr);
        nx8f = fread(x8f, sizeof(float), 8, fptr);

        // Reached EOF so break out of loop
        if (nx6q == 0) {
            printf("info:converted %lld rows to CSV.\n", num_rows);
            break;
        }

        // if incomplete row then exit
        if (nx6q != 6) {
            printf("error:incomplete row:expected nx6q=6:got nx6q=%d\n", nx6q);
            exit(1);
        }
        if (nxf != 1) {
            printf("error:incomplete row:expected nxf=1:got nxf=%d\n", nxf);
            exit(1);
        }
        if (nx7d != 7) {
            printf("error:incomplete row:expected nx7d=7:got nx7d=%d\n", nx7d);
            exit(1);
        }
        if (nx5f != 5) {
            printf("error:incomplete row:expected nx5f=5:got nx5f=%d\n", nx5f);
            exit(1);
        }
        if (nxb != 1) {
            printf("error:incomplete row:expected nxb=1:got nxb=%d\n", nxb);
            exit(1);
        }
        if (nx12f != 12) {
            printf("error:incomplete row:expected nx12f=12:got nx12f=%d\n",
                   nx12f);
            exit(1);
        }
        if (nx5b != 5) {
            printf("error:incomplete row:expected nx5b=5:got nx5b=%d\n", nx5b);
            exit(1);
        }
        if (nx4f != 4) {
            printf("error:incomplete row:expected nx4f=4:got nx4f=%d\n", nx4f);
            exit(1);
        }
        if (nx8i != 8) {
            printf("error:incomplete row:expected nx8i=8:got nx8i=%d\n", nx8i);
            exit(1);
        }
        if (nx8f != 8) {
            printf("error:incomplete row:expected nx8f=8:got nx8f=%d\n", nx8f);
            exit(1);
        }

        // complete row read so increment num_rows
        num_rows = num_rows + 1;

        // write CSV data
        for (i = 0; i < 6; i++) {
            fprintf(fptr_out, "%lld,", x6q[i]);
        }

        fprintf(fptr_out, "%.8e,", xf[0]);

        for (i = 0; i < 7; i++) {
            fprintf(fptr_out, "%.16e,", x7d[i]);
        }

        for (i = 0; i < 5; i++) {
            fprintf(fptr_out, "%.8e,", x5f[i]);
        }

        fprintf(fptr_out, "%hhd,", xb[0]);

        for (i = 0; i < 12; i++) {
            fprintf(fptr_out, "%.8e,", x12f[i]);
        }

        for (i = 0; i < 5; i++) {
            fprintf(fptr_out, "%hhd,", x5b[i]);
        }

        for (i = 0; i < 4; i++) {
            fprintf(fptr_out, "%.8e,", x4f[i]);
        }

        for (i = 0; i < 8; i++) {
            fprintf(fptr_out, "%d,", x8i[i]);
        }

        for (i = 0; i < 8; i++) {
            if (i < 7) {
                fprintf(fptr_out, "%.8e,", x8f[i]);
            } else {
                fprintf(fptr_out, "%.8e", x8f[i]);
            }
        }

        fprintf(fptr_out, "\n");
    }
    // end loop to read data

    fclose(fptr);
    fclose(fptr_out);
    return 0;
}
