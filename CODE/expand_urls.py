import sys
import re
import cPickle as pickle
from utils import timeit
import glob
import ntpath 
import pymongo
from urlunshort import resolve
import csv
import ast
from utils import timeout, TimeoutError, timeit, unshorten_url
import requests

"""
expand each url
see that it has domain in orgs
What tweets have domain name in [orgs]?
make sure to cache links that have been seens

In electome db:
 reuters
 huffingtonpost
 mcclatchy
 buzzfeed
 politico
 propublica
 wsj
 nytimes
 npr
 cnn
 ap [ap.org]
 foxnews
 latimes
 washingtonpost

"""

def check_substr(substring_list, string):
    return any(substring in string for substring in substring_list)

@timeout(2)
def expand(url):
    r = requests.head(url)
    if r.status_code / 100 == 3:
        expanded_url = r.headers['Location']
    else:
        expanded_url = r.url
    return expanded_url

def unshort_and_check(list_of_urls):
    DOMAINS = ['reuters', 'huffingtonpost', 'mcclatchy',
                'buzzfeed','politico', 'propublica',
                'wsj', 'nytimes', 'npr', 'cnn', 'ap.org',
                'foxnews', 'latimes', 'washingtonpost']

    urls = ast.literal_eval(list_of_urls)
    ls = []
    for url in urls:
        url_prev = ""

        while url_prev != url:
            
            #print 'PREV', url_prev
            #print 'THIS', url

            url_prev = url
            try:
                url = expand(url)
            except TimeoutError: 
                url = url_prev
            except:
                print "OTHER ERROR: ", url
                break

                 
        if check_substr(DOMAINS, url):
            ls.append(url)

    return ls



@timeit
def expand_urls(inpath, outpath):
    """ In path is csv of _id, [urls]
    """
     
    with open(inpath, 'rb') as f:
        reader = csv.reader(f)

        with open(outpath, 'w') as out:
            writer = csv.writer(out)
            for row in reader:
                urls = unshort_and_check(row[1])
                if urls:
                    writer.writerow([row[0], urls]) 
                



def main(in_dir, out_dir):
    # split in half for Catbook and Shannon
    files = ['../DATA/LINKS_2016_ONLY/url_tweets_17_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_18_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_19_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_1_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_20_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_21_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_22_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_23_links.csv',
            '../DATA/LINKS_2016_ONLY/url_tweets_24_links.csv']
    #for p in glob.glob(in_dir + '/*'):
    for p in files:
        print p
        #get_links_and_pickle(p, out_dir + ntpath.basename(p).split('.')[0] + '_links.pkl')
        expand_urls(p, out_dir + ntpath.basename(p).split('.')[0] + '_newslinks.csv')

     #glob.glob('/Users/Cat/thesis-extend/DATA/PICKLES/*')

# Usage: python expand_urls.py ../DATA/LINKS_2016_ONLY/ ../DATA/NEWS_ONLY_LINKS/ 
if __name__ == "__main__": main(sys.argv[1], sys.argv[2])









