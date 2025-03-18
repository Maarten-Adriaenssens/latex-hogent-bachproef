FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-lang-european \
    texlive-bibtex-extra \
    biber \
    perl \
    git \
    python3-pip \
    latexmk \
    && pip install pygments \
    && rm -rf /var/lib/apt/lists/*
COPY fonts/ /usr/share/fonts/opentype
COPY docker/.latexmkrc /root/.latexmkrc
RUN fc-cache -f -v
