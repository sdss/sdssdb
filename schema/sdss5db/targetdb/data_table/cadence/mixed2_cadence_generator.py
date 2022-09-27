#! /usr/bin/env python

import numpy as np

#delta_sequence = ['3.0', '30.0', '60.0','300.0','3.0', '30.0', '60.0','300.0',
#                  '3.0', '30.0', '60.0','300.0','3.0', '30.0', '60.0','300.0',
#                  '3.0', '30.0', '60.0','300.0','3.0', '30.0', '60.0','300.0']

delta_sequence = ['30.0', '30.0', '3.00', '27.0', '30.0', '240.0',
                  '30.0', '30.0', '3.00', '27.0', '30.0', '240.0',
                  '30.0', '30.0', '3.00', '27.0', '30.0', '240.0']

label_version = '_v2'
    
with open('mixed2_single_cadences'+label_version+'.cfg','w') as f:
    for i in np.arange(3,100):
        label_root = f'mixed2_single_{i}x1'
        f.write('['+label_root+label_version+']\n')
        f.write(' label_root= ' + label_root + '\n')
        f.write(' label_version= ' + label_version + '\n')
        f.write(f' nepochs={i}\n')
#        f.write(' instrument=BOSS\n')

        f.write(' skybrightness= 0.35 0.35')
        f.write(' 1.0'*(i-2)+'\n') # This will write out 1.0 i-2 times
        
        f.write(' delta= 0.00 3.00 -1.0') # Not sure if I want -1 or 0 for first bright epoch
        
        if i <= 20:
            if i>3:
                for one_del in delta_sequence[0:i-3]:
                    f.write(' '+one_del)
            f.write('\n')
        
            f.write(' delta_min= 0.00' + ' 0.50 -1.0'+ ' 0.50'*(i-3)+ '\n')
            f.write(' delta_max= 0.00' + ' 1800 -1.0' + ' 1800'*(i-3)+ '\n')
            f.write(' nexp='+ ' 1'*i + '\n')
            f.write(' max_length= 0.20 0.20' + ' 0.20' * (i-2) + '\n')
            f.write(' obsmode_pk= dark_plane dark_plane' + ' bright_time'*(i-2) + '\n')
            f.write(' min_moon_sep =  35 35 ' + ' 15'*(i-2) + '\n')
            f.write(' min_deltav_ks91 = -1.5 -1.5 ' + ' -3'*(i-2) + '\n')
            f.write(' min_twilight_ang = 15 15 ' + ' 8'*(i-2) + '\n')
            f.write(' max_airmass = 1.6 1.6 ' + ' 2'*(i-2) + '\n')


        else:  #In this case, do up to 18 in the sequence then revert to unconstrainted
            for one_del in delta_sequence[0:17]:
                f.write(' '+one_del)
            f.write(' -1.0' * (i-20) + '\n')
       
            f.write(' delta_min= 0.00' + ' 0.50 0.0' + ' 0.50'*17+ ' 0.0'*(i-20) + '\n')
            f.write(' delta_max= 0.00' + ' 1800 -1.0' + ' 1800'*17+ ' -1.0'*(i-20) + '\n')
            f.write(' nexp='+ ' 1'*i + '\n')
            f.write(' max_length= 0.20 0.20' + ' 0.20'*18 + ' 10000.00'*(i-20) + '\n')
            f.write(' obsmode_pk= dark_plane dark_plane' + ' bright_time'*18 + ' bright_time'*(i-20) + '\n')
            f.write(' min_moon_sep =  35 35 ' + ' 15'*18 + ' 15'*(i-20) + '\n')
            f.write(' min_deltav_ks91 = -1.5 -1.5 ' + ' -3'*18 + ' -3'*(i-20) + '\n')
            f.write(' min_twilight_ang = 15 15 ' + ' 15'*18 + ' 8'*(i-20) + '\n')
            f.write(' max_airmass = 1.6 1.6 ' + ' 1.6'*18 + ' 2'*(i-20) + '\n')

       
        f.write('\n\n')
