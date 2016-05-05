import glob
import cPickle as cPickle
import csv
import ntpath 
"""
just a script
"""

pickles = glob.glob('../DATA/LINKS/*')
for p in pickles:
    print p
    ls = pickle.load(open(p, 'rb'))
    with open('../DATA/LINKS_AS_CSV/' + ntpath.basename(p).split('.')[0] + '.csv', 'w') as out: 

        csv_out=csv.writer(out)
        csv_out.writerow(['_id','links'])
        for row in ls:
            csv_out.writerow(row)