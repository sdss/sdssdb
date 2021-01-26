import math

# sed 's/,/|/g'  2QZ_6QZ_pubcat.txt > 2QZ_6QZ_pubcat.txt.nocomma 
fin = open('2QZ_6QZ_pubcat.txt.nocomma', 'r')

fout = open('2QZ_6QZ_pubcat.csv', 'w') 

for line in fin:
    tag = line.split()

    name = tag[0]
    ra_j2000 = tag[1] + ":" + tag[2] + ":" + tag[3]
    dec_j2000 = tag[4] + ":" + tag[5] + ":" + tag[6]
    catalogue_number = tag[7]
    catalogue_name = tag[8]
    sector = tag[9]
    ra_b1950 = tag[10] + ":" + tag[11] + ":" + tag[12]
    dec_b1950 = tag[13] + ":" + tag[14] + ":" + tag[15]
    ukst_field = tag[16]
    xapm = tag[17]
    yapm = tag[18]
    ra_rad = tag[19]
    dec_rad = tag[20]
    bj = tag[21]
    u_bj = tag[22]
    bj_r = tag[23]
    nobs = tag[24]
    z1 = tag[25]
    q1 = tag[26]
    id1 = tag[27]
    date1 = tag[28]
    fld1 = tag[29]
    fibre1 = tag[30]
    s_n1 = tag[31]
    z2 = tag[32]
    q2 = tag[33]
    id2 = tag[34]
    date2 = tag[35]
    fld2 = tag[36]
    fibre2 = tag[37]
    s_n2 = tag[38]
    zprev = tag[39]
    radio = tag[40]
    x_ray = tag[41]
    dust = tag[42]
    comments1 = tag[43]
    comments2 = tag[44]
    ra_degree = float(ra_rad) * 180.0 / math.pi
    dec_degree = float(dec_rad) * 180.0 / math.pi

    print(name,
          ra_j2000,
          dec_j2000,
          catalogue_number,
          catalogue_name,
          sector,
          ra_b1950,
          dec_b1950,
          ukst_field,
          xapm,
          yapm,
          ra_rad,
          dec_rad,
          bj,
          u_bj,
          bj_r,
          nobs,
          z1,
          q1,
          id1,
          date1,
          fld1,
          fibre1,
          s_n1,
          z2,
          q2,
          id2,
          date2,
          fld2,
          fibre2,
          s_n2,
          zprev,
          radio,
          x_ray,
          dust,
          comments1,
          comments2,
          ra_degree,
          dec_degree,
          sep=',',file=fout)

fin.close()
fout.close()

