WEAVE := noweave
TANGLE := notangle
PDFLATEX := pdflatex

target_base := led

all: doc

doc: $(target_base).pdf

%.tex: %.nw
	$(WEAVE)  -delay -index $< > $@

%.pdf: %.tex
	$(PDFLATEX) $< # run twice for indexing
	#$(PDFLATEX) $<

%: %.nw
	$(TANGLE) -R$@ $< > $@

clean:
	$(RM) $(target_base).{pdf,log,aux,tex}
