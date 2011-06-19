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

src: ed_parser.erl ed_main.erl ed_scanner.erl ed_buffer.erl $(script)

clean:
	$(RM) $(base).{pdf,log,aux,tex}

ed_parser.yrl: $(base).nw
	$(TANGLE) -R'[[$@]]' $< > $@

$(script): $(base).nw
	$(TANGLE) -R'[[$@]]' $< > $@

%.tex: %.nw
	$(WEAVE)  -delay -index $< > $@

%.pdf: %.tex
	$(PDFLATEX) $< # run twice for indexing
	#$(PDFLATEX) $<

%.erl: $(base).nw
	$(TANGLE) -R'[[$@]]' $< > $@

%.erl: %.yrl
	$(ERLC) -W $<
