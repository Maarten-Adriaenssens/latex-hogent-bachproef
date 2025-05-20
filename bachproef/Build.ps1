xelatex -interaction=nonstopmode ./AdriaenssensMaartenBP.tex
biber ./AdriaenssensMaartenBP.bcf
makeglossaries AdriaenssensMaartenBP
xelatex -interaction=nonstopmode ./AdriaenssensMaartenBP.tex
xelatex -interaction=nonstopmode ./AdriaenssensMaartenBP.tex
