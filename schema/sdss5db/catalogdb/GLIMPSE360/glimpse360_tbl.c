// Program glimpse360_tbl.c
// Aim: Read a GLIMPSE360 tbl data file and output a CSV file
//
// column names and types are from line 10 and line 11 of
// GLM360A_l108-169.tbl
//
// Use the below command to get the above .tbl file:
// wget
// https://irsa.ipac.caltech.edu/data/SPITZER/GLIMPSE/catalogs/GLIMPSE360/GLM360A_l108-169.tbl.gz
//
// See Table 8 page 26 for types of first and second columns:
// http://www.astro.wisc.edu/sirtf/glimpse360_dataprod_v1.2.pdf
// first column is char(26)
// second column is char(16)
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {

    const int NUM_HEADER_LINES = 13;

    // This is used in fgets()
    const int MAX_CHAR_HEADER_LINE = 1024;
    char header_line[MAX_CHAR_HEADER_LINE];

    // +1 for '\0'
    // +1 for the space between fields in the .tbl file
    char designation[26 + 1 + 1];
    char tmass_designation[16 + 1 + 1];
    int tmass_cntr;
    double l;
    double b;
    double dl;
    double db;
    double ra;
    double dec;
    double dra;
    double ddec;
    int csf;
    float mag_J;
    float dJ_m;
    float mag_H;
    float dH_m;
    float mag_Ks;
    float dKs_m;
    float mag3_6;
    float d3_6m;
    float mag4_5;
    float d4_5m;
    float mag5_8;
    float d5_8m;
    float mag8_0;
    float d8_0m;
    float f_J;
    float df_J;
    float f_H;
    float df_H;
    float f_Ks;
    float df_Ks;
    float f3_6;
    float df3_6;
    float f4_5;
    float df4_5;
    float f5_8;
    float df5_8;
    float f8_0;
    float df8_0;
    float rms_f3_6;
    float rms_f4_5;
    float rms_f5_8;
    float rms_f8_0;
    float sky_3_6;
    float sky_4_5;
    float sky_5_8;
    float sky_8_0;
    float sn_J;
    float sn_H;
    float sn_Ks;
    float sn_3_6;
    float sn_4_5;
    float sn_5_8;
    float sn_8_0;
    float dens_3_6;
    float dens_4_5;
    float dens_5_8;
    float dens_8_0;
    int m3_6;
    int m4_5;
    int m5_8;
    int m8_0;
    int n3_6;
    int n4_5;
    int n5_8;
    int n8_0;
    int sqf_J;
    int sqf_H;
    int sqf_Ks;
    int sqf_3_6;
    int sqf_4_5;
    int sqf_5_8;
    int sqf_8_0;
    int mf3_6;
    int mf4_5;
    int mf5_8;
    int mf8_0;

    FILE *fptr;
    FILE *fptr_try;
    FILE *fptr_out;
    int i;
    long long num_rows;
    char *fgets_ptr;
    int c1;

    if (argc != 3) {
        printf("usage: glimpse360_tbl input_file output_file\n");
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

    // skip header lines
    for (i = 1; i <= NUM_HEADER_LINES; i++) {
        fgets(header_line, MAX_CHAR_HEADER_LINE, fptr);
        printf("%d:%s\n", i, header_line);
    }

    num_rows = 0;
    // start loop to read lines
    while (1) {
        // +1 for '\0'
        // +1 for the space between fields in the .tbl file
        fgets_ptr = fgets(designation, 26 + 1 + 1, fptr);

        if (fgets_ptr == NULL) {
            break;
        }

        fgets(tmass_designation, 16 + 1 + 1, fptr);

        // The format string below does not have %26s for designation
        // and %16s for tmass_designation since we have the above two fgets()

        fscanf(fptr,
               "%d %le %le %le %le %le %le %le %le %d %e %e %e %e %e %e %e %e "
               "%e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e "
               "%e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %e %d %d %d "
               "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d",
               &tmass_cntr, &l, &b, &dl, &db, &ra, &dec, &dra, &ddec, &csf,
               &mag_J, &dJ_m, &mag_H, &dH_m, &mag_Ks, &dKs_m, &mag3_6, &d3_6m,
               &mag4_5, &d4_5m, &mag5_8, &d5_8m, &mag8_0, &d8_0m, &f_J, &df_J,
               &f_H, &df_H, &f_Ks, &df_Ks, &f3_6, &df3_6, &f4_5, &df4_5, &f5_8,
               &df5_8, &f8_0, &df8_0, &rms_f3_6, &rms_f4_5, &rms_f5_8,
               &rms_f8_0, &sky_3_6, &sky_4_5, &sky_5_8, &sky_8_0, &sn_J, &sn_H,
               &sn_Ks, &sn_3_6, &sn_4_5, &sn_5_8, &sn_8_0, &dens_3_6, &dens_4_5,
               &dens_5_8, &dens_8_0, &m3_6, &m4_5, &m5_8, &m8_0, &n3_6, &n4_5,
               &n5_8, &n8_0, &sqf_J, &sqf_H, &sqf_Ks, &sqf_3_6, &sqf_4_5,
               &sqf_5_8, &sqf_8_0, &mf3_6, &mf4_5, &mf5_8, &mf8_0);

        // read remaining characters in the current line
        // till we get to the next line
        c1 = 'a';
        while ((c1 != EOF) && (c1 != '\n')) {
            c1 = fgetc(fptr);
        }

        // completed row read so increment num_rows
        num_rows = num_rows + 1;

        // write CSV data

        fprintf(fptr_out,
                "%s,%s,%d,%.16e,%.16e,%.16e,%.16e,%.16e,%.16e,%.16e,%.16e,%d,"
                "%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,"
                "%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,"
                "%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,"
                "%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,%.8e,"
                "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
                designation, tmass_designation, tmass_cntr, l, b, dl, db, ra,
                dec, dra, ddec, csf, mag_J, dJ_m, mag_H, dH_m, mag_Ks, dKs_m,
                mag3_6, d3_6m, mag4_5, d4_5m, mag5_8, d5_8m, mag8_0, d8_0m, f_J,
                df_J, f_H, df_H, f_Ks, df_Ks, f3_6, df3_6, f4_5, df4_5, f5_8,
                df5_8, f8_0, df8_0, rms_f3_6, rms_f4_5, rms_f5_8, rms_f8_0,
                sky_3_6, sky_4_5, sky_5_8, sky_8_0, sn_J, sn_H, sn_Ks, sn_3_6,
                sn_4_5, sn_5_8, sn_8_0, dens_3_6, dens_4_5, dens_5_8, dens_8_0,
                m3_6, m4_5, m5_8, m8_0, n3_6, n4_5, n5_8, n8_0, sqf_J, sqf_H,
                sqf_Ks, sqf_3_6, sqf_4_5, sqf_5_8, sqf_8_0, mf3_6, mf4_5, mf5_8,
                mf8_0);

        fprintf(fptr_out, "\n");
    }
    // end loop to read lines

    fclose(fptr);
    fclose(fptr_out);
    return 0;
}
