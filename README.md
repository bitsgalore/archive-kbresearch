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

This results in 153 MB of data. Index and individual blog posts load correctly without a network connection, but there are some issues:

### *Archive* dropdown menu doesn't work

This happens because the *value* attribute of the *option* tag for each month refers to the live site:


    <option value='http://blog.kbresearch.nl/2017/02/'> February 2017 </option>
    <option value='http://blog.kbresearch.nl/2017/01/'> January 2017 </option>
    <option value='http://blog.kbresearch.nl/2016/12/'> December 2016 </option>
    <option value='http://blog.kbresearch.nl/2016/11/'> November 2016 </option>
    <option value='http://blog.kbresearch.nl/2016/10/'> October 2016 </option>
    <option value='http://blog.kbresearch.nl/2016/09/'> September 2016 </option>

Possible solutions:

* Rewrite links (but: relative links probably won't work here because they are specific to the page from which they are accessed)
* Host archived blog on *http://blog.kbresearch.nl* domain, in which case the links should work again

### *Older posts* link at bottom of index pages doesn't work

E.g. from home page:

    <div class="nav-previous"><a href="page/2/index.html" ><span class="meta-nav">&larr;</span> Older posts</a></div>

Mousing over the link in Firefox's "View Source" view resolves to:

<file:///home/johan/ownCloud/blogkbresearch/posts-all/blog.kbresearch.nl/page/2/index.html>

Which is the correct link, but for some reason nothing happens when clicking on the button.

### Some images don't render

E.g. images in this blog don't work:

<file:///home/johan/ownCloud/blogkbresearch/posts-all/blog.kbresearch.nl/2017/02/04/whitts-cure-for-preservationists-despair/index.html>

Example image link:

    <img class="size-medium wp-image-2080 alignleft" src="../../../../../researchkb.files.wordpress.com/2017/02/alice_par_john_tenniel_04.jpg%3Fw=211&amp;h=300" alt="alice_par_john_tenniel_04" width="211" height="300" srcset="https://researchkb.files.wordpress.com/2017/02/alice_par_john_tenniel_04.jpg?w=211&amp;h=300 211w, https://researchkb.files.wordpress.com/2017/02/alice_par_john_tenniel_04.jpg?w=422&amp;h=600 422w, https://researchkb.files.wordpress.com/2017/02/alice_par_john_tenniel_04.jpg?w=105&amp;h=150 105w" sizes="(max-width: 211px) 100vw, 211px" />

The *src* attribute refers to an image file under *researchkb.files.wordpress.com/2017/02/* (which also exists), but apparently the browser gives priority to the images defined in the *srcset* attribute (which were not downloaded locally by *wget*)! Tested with Firefox and Chromium.

In this blog all images are rendered correctly:

<file:///home/johan/ownCloud/blogkbresearch/posts-all/blog.kbresearch.nl/2015/07/07/why-pdfa-validation-matters-even-if-you-dont-have-pdfa/index.html>

Example image link:

    <img src="../../../../../researchkb.files.wordpress.com/2015/07/openpassword.png%3Fw=676" />


Solution:

Use more recent version of Wget; parsing of `<img srcset>` was added in Wget 1.18 (used 1.17.1 here!).

### Search form doesn't work

Solution: no idea!


### URL encoding error

For the following blog post, the URL contains a special character that results in an encoding error:

</home/johan/ownCloud/blogkbresearch/posts-all/blog.kbresearch.nl/2014/02/27>

Title: `what-if-we-do-in-fact-know-best-a-response-to-the-oclc-report-on-dh-and-research-libraries-�%86%90-dh-lib (invalid encoding)`.

* On Linux fs, the files in the directory (incl. index.html0 cannot be opened
* Also gives synchronisation error with ownCloud (which seems to stop synchronization altogether afterwards?!)

### i1.wp.com, i2.wp.com

Contains subdir `researchkb.files.wordpress.com` with images from one blog post (which for some reason aren't directly under `researchkb.files.wordpress.com`; maybe merge manually and adjust links).


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