FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-lang-european \
    texlive-bibtex-extra \
    biber \
    git \
    texlive-xetex \
    python3-pip \
    latexmk \
    && pip install pygments \
    && rm -rf /var/lib/apt/lists/*
COPY fonts/ /usr/share/fonts/opentype
# #new
# # Copy the source file into the container
# COPY docker/latexmk.txt /tmp/latexmk.txt

# # Append the content of source.txt to target.txt
# RUN cat /tmp/latexmk.txt >> ~/.latexmkrc
#end new
RUN fc-cache -f -v
