 cat file-with-list-of-urls.txt | parallel curl -L {} -o {/}

 cat nytimes_test.txt | parallel curl -sIL {} -o {/}

# curl -sIL $line | grep ^Location | tail -n1;


 cat nytimes_test.txt | xargs -n 1 parallel curl -sIL {} -o {/}

| xargs -n 1 curl -LO