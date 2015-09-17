#!/usr/bin/python2
"""
Render doc files from markdown, place in an html page template with styling
"""

from subprocess import check_output
from os import listdir
from markdown2 import markdown


markdown_docs = [file for file in listdir('.') if file.endswith('.md')]
INDEX_FILE = 'index.md'
OUTPUT_DIR = "site/"
with open('head.html', 'rb') as f:
    HEAD = f.read()
with open('page_template.html', 'rb') as f:
    PAGE_TEMPLATE = f.read()
with open('index_template.html', 'rb') as f:
    INDEX_TEMPLATE = f.read()
formatting = {
    'head': HEAD,
}

for doc in markdown_docs:
    with open(doc, 'r') as f:
        page_content = check_output(['markdown', doc])
    formatting['content'] = page_content

    if doc == INDEX_FILE:
        entire_page = INDEX_TEMPLATE % formatting
    else:
        entire_page = PAGE_TEMPLATE % formatting

    output_file = OUTPUT_DIR + doc.rstrip('md') + ('html')
    # TODO: Also have this write to the right location within the app package, to use as a local copy
    with open(output_file, 'wb') as f:
        f.write(entire_page)
