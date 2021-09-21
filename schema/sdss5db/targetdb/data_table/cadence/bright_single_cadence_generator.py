#! /usr/bin/env python

import numpy as np

#delta_sequence = ['3.0', '30.0', '60.0','300.0','3.0', '30.0', '60.0','300.0',
#                  '3.0', '30.0', '60.0','300.0','3.0', '30.0', '60.0','300.0',
#                  '3.0', '30.0', '60.0','300.0','3.0', '30.0', '60.0','300.0']
delta_sequence = ['30.0', '30.0', '3.00', '27.0', '30.0', '240.0',
                  '30.0', '30.0', '3.00', '27.0', '30.0', '240.0',
                  '30.0', '30.0', '3.00', '27.0', '30.0', '240.0']

label_version = '_v1'
    
with open('bright_single_cadences'+label_version+'.cfg','w') as f:
    for i in np.arange(3,100):
        label_root = f'bright_single_{i}x1'
        f.write('['+label_root+label_version+']\n')
        f.write(' label_root= ' + label_root + '\n')
        f.write(' label_version= ' + label_version + '\n')
        f.write(f' nepochs={i}\n')
#        f.write(' instrument=BOSS\n')

        f.write(' skybrightness= ')
        f.write(' 1.0'*(i)+'\n') # This will write out 1.0 i-2 times
        
        f.write(' delta= 0.00 ') # Not sure if I want -1 or 0 for first bright epoch
        
        if i <= 18:
            if i>1:
                for one_del in delta_sequence[0:i-1]:
                    f.write(' '+one_del)
            f.write('\n')
        
            f.write(' delta_min= 0.00'+ ' 0.50'*(i-1)+ '\n')
            f.write(' delta_max= 0.00' + ' 1800'*(i-1)+ '\n')
            f.write(' nexp='+ ' 1'*i + '\n')
            f.write(' max_length= ' + ' 0.00' * (i) + '\n')
            f.write(' obsmode_pk= ' + ' bright_time'*i + '\n')
        
        else:  #In this case, do up to 18 in the sequence then revert to unconstrainted
            for one_del in delta_sequence[0:17]:
                f.write(' '+one_del)
            f.write(' 0.0' * (i-18) + '\n')
       
            f.write(' delta_min= 0.00' + ' 0.50'*17+ ' 0.0'*(i-18) + '\n')
            f.write(' delta_max= 0.00' + ' 1800'*17+ ' -1.0'*(i-18) + '\n')
            f.write(' nexp='+ ' 1'*i + '\n')
            f.write(' max_length= ' + ' 0.00'*18 + ' 10000.00'*(i-18) + '\n')
            f.write(' obsmode_pk= ' + ' bright_time'*18 + ' bright_time'*(i-18) + '\n')
       
        f.write('\n\n')
