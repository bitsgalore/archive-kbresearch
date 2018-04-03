# Contents of this repo

Various resources and documentation on the creation of a static archived version of the KB Research blog, to be hosted at the location of the current 'live' blog.


# Documentation

## Step 1: scrape one blog post + all resources

    wget --page-requisites --span-hosts --convert-links --adjust-extension -w 5 --random-wait http://blog.kbresearch.nl/2015/07/07/why-pdfa-validation-matters-even-if-you-dont-have-pdfa/ >>$logFile 2>&1

Result: Blog post + CSS + images + comments render OK with network disabled! Download directory contains following domain-specific subdirectories:

    0.gravatar.com
    1.gravatar.com
    blog.kbresearch.nl
    fonts.googleapis.com
    fonts.gstatic.com
    pixel.wp.com
    platform.twitter.com
    researchkb.files.wordpress.com
    r-login.wordpress.com
    s0.wp.com
    s1.wp.com
    s2.wp.com
    stats.wp.com
    widgets.wp.com


## Step 2: scrape the whole blog

Use the `--domains` option, and set its value to the list of domains we got from the previous step. Exceptions:

- ignore domain *gravatar.com* (including it results in scraping of over 60 subdomains, and it is not that important)
- ignore domain *twitter.com*

So we get the following shell script:

    url=http://blog.kbresearch.nl
    domains=blog.kbresearch.nl,wp.com,researchkb.files.wordpress.com,googleapis.com,gstatic.com
    logFile=wget.log
    wget --mirror --page-requisites --span-hosts --convert-links --adjust-extension -w 5 --random-wait --domains=$domains $url >>$logFile 2>&1

This results in 153 MB of data. Index and individual blog posts load correctly without a network connection, but there are some [issues](https://github.com/bitsgalore/archive-kbresearch/issues).


<!-- Old stuff

Command:

    wget -m -k -K -E -l 7 -t 6 -w 5 http://blog.kbresearch.nl

(<https://mattgadient.com/2012/11/07/scraping-your-own-website-with-wget/>


BUT this doesn't include CSS resources!

This looks better:

<http://www.stevenmaude.co.uk/posts/archiving-a-wordpress-site-with-wget-and-hosting-for-free>


    wget --page-requisites --convert-links --adjust-extension --mirror --span-hosts --domains=blog.scraperwiki.com,scraperwiki.com --exclude-domains beta.scraperwiki.com,classic.scraperwiki.com,media.scraperwiki.com,mot.scraperwiki.com,newsreader.scraperwiki.com,premium.scraperwiki.com,status.scraperwiki.com,x.scraperwiki.com scraperwiki.com

    wget --page-requisites --convert-links --adjust-extension --mirror --span-hosts --domains=blog.kbresearch.nl,wordpress.com,wp.com http://blog.kbresearch.nl

Still missing images, CSS!


<http://www.gohthere.com/tech/wordpress-export-static-html-site/>

    wget --no-host-directories --recursive --page-requisites --no-parent --timestamping http://blog.kbresearch.nl


also:

<https://stackoverflow.com/a/13327040>

BUT includes outbound links (e.g. Twitter, Facebook).

Possible solutions:

<https://unix.stackexchange.com/questions/94488/ignore-other-domains-when-downloading-with-wget>


and (redirects!):

<http://floatleft.com/notebook/archiving-an-old-wordpress-site/>

Also:

<https://askubuntu.com/questions/373047/i-used-wget-to-download-html-files-where-are-the-images-in-the-file-stored>

    wget -E -H -k -p http://textbook.s-anand.net/ncert/class-xii/chemistry/hello-this-first-chapter

THIS WORKS FOR ONE PAGE!!!

* -E = --adjust-extension
* -H =--span-hosts (go to foreign hosts when recursive)
* -k = --convert-links
* -p = --page-requisites


For example:

    wget --page-requisites --span-hosts --convert-links --adjust-extension -w 5 --random-wait http://blog.kbresearch.nl/2015/11/13/preserving-optical-media-from-the-command-line/ >>$logFile 2>&1


Blog post + CSS renders OK with network disabled!

    wget --page-requisites --span-hosts --convert-links --adjust-extension -w 5 --random-wait http://blog.kbresearch.nl/2015/07/07/why-pdfa-validation-matters-even-if-you-dont-have-pdfa/ >>$logFile 2>&1

Blog post + CSS + images + comments render OK with network disabled!

Now try to grab all 2017 posts (adding `--mirror` switch):


    wget --mirror --page-requisites --span-hosts --convert-links --adjust-extension -w 5 --random-wait http://blog.kbresearch.nl/2017/

Result: wget also scrapes all external href links (e.g. www.eark-project.com, digitalcommons.law.scu.edu, etc.)!

So let's look at the domains used for individual page resources:

domains=domains=blog.kbresearch.nl,wp.com,researchkb.files.wordpress.com,r-login.wordpress.com,gravatar.com,googleapis.com,gstatic.com,platform.twitter.com

    wget --mirror --page-requisites --span-hosts --convert-links --adjust-extension -w 5 --random-wait --domains=$domains $url

BUT:

- gravatar.com: scraping 58 subdomains ==> leave this out!

next try:

    domains=blog.kbresearch.nl,wp.com,researchkb.files.wordpress.com,googleapis.com,gstatic.com

More:

<https://gist.github.com/dannguyen/03a10e850656577cfb57>

<http://www.linuxjournal.com/content/downloading-entire-web-site-wget>

-->