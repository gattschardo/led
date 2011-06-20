WEAVE := noweave
TANGLE := notangle
PDFLATEX := pdflatex
ERLC := erlc

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
	$(TANGLE) -R'[[$@]]' $< > $@

$(script): $(base).nw
	$(TANGLE) -R'[[$@]]' $< > $@

%.tex: %.nw
	$(WEAVE)  -delay -index $< > $@

%.pdf: %.tex
	$(PDFLATEX) $< #> /dev/null # run twice for indexing
	#$(PDFLATEX) $<

%.erl: $(base).nw
	$(TANGLE) -R'[[$@]]' $< > $@

%.beam: %.erl
	$(ERLC) -W $<
