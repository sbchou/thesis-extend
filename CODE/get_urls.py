import sys
import re
import cPickle as pickle
from utils import timeit
import glob
import ntpath 
import pymongo

"""
Take pickled tweets, extract urls, save to pickles.
""" 

# def get_links(path_to_pickle):
#     """
#     Opens the pickled dictionary of tweets 
#     Input: 
#         Pickle of nested dictionary of tweets
#         * keys: _id (an int like 713487787698339840L)
#         * keys: _id, author, sentiment, time, tweet
#     Returns:
#         list of tuples [(_id, extracted_url)] 
#     """ 
#     tweets = pickle.load(open(path_to_pickle,'rb'))
#     #links = [(t['_id'] if '_id' in t.keys() else t['tweet']['_id'], extract for t in test2]
#     links = [(t['_id'], extract_url(t['tweet'])) for t in tweets.itervalues()]
#     return links

@timeit
def get_links_and_pickle(in_pickle_path, out_pickle_path):
    """
    Opens the pickled dictionary of tweets 
    Input: 
        Pickle of nested dictionary of tweets
        * keys: _id (an int like 713487787698339840L)
        * keys: _id, author, sentiment, time, tweet
    Returns:
        list of tuples [(_id, [urls])] 

    Takes about 120-200 secs for pickle of ~ 1 M & 1 tweets.
    For 35 pickles ~ 3 * 35 = 105 min.

    """ 
   
    links = []
    tweets = pickle.load(open(in_pickle_path,'rb')) 

    for t in tweets.itervalues():
        if '_id' in t.keys():
            links.append((t['_id'], extract_url(t['tweet'])))
        elif 'tweet' in t.keys():
            links.append((t['tweet']['_id'], extract_url(t['tweet']['tweet'])))

    #links = [(t['_id'], extract_url(t['tweet'])) for t in tweets.itervalues()]
    pickle.dump(links, open(out_pickle_path,'wb'))


def extract_url(tweet):
    #url = re.search("(?P<url>https?://[^\s]+)", tweet).group("url")
    urls = re.findall('http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', tweet)

    if urls == None:
        print tweet

    return urls
 

def main(in_dir, out_dir):

    for p in glob.glob(in_dir + '/*'):
        print p
        get_links_and_pickle(p, out_dir + ntpath.basename(p).split('.')[0] + '_links.pkl')


     #glob.glob('/Users/Cat/thesis-extend/DATA/PICKLES/*')

# Usage: python get_urls.py ../DATA/PICKLES/ ../DATA/LINKS/ 
if __name__ == "__main__": main(sys.argv[1], sys.argv[2])

