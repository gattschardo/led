WEAVE := noweave
TANGLE := notangle
TANGLEFLAGS := #-L'%%file %L "%F"%N'
PDFLATEX := pdflatex
ERLC := erlc
tan := $(TANGLE) $(TANGLEFLAGS)

base := led
script := $(base).sh

all: doc program

doc: $(base).pdf

program: src
	chmod +x $(script)

src: ed_parser.beam ed_main.beam ed_scanner.beam ed_buffer.erl $(script)

clean:
	$(RM) $(base).{pdf,log,aux,tex,toc} *.{erl,yrl,beam} $(script)

ed_parser.erl: ed_parser.yrl
	$(ERLC) -W $<

ed_parser.yrl: $(base).nw
	$(tan) -R'[[$@]]' $< | cpif $@

$(script): $(base).nw
	$(tan) -R'[[$@]]' $< | cpif $@

%.tex: %.nw
	$(WEAVE) -delay $< | cpif $@

%.pdf: %.tex
	$(PDFLATEX) $< #> /dev/null # run twice for indexing
	#$(PDFLATEX) $<

%.erl: $(base).nw
	$(tan) -R'[[$@]]' $< | cpif $@

%.beam: %.erl
	$(ERLC) -W $<
