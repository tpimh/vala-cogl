SRCS = cogl-crate.vala
PROGRAM = cogl-crate
VALAPKGS = --pkg cogl-2.0 --pkg cogl-pango-2.0 --pkg pango --pkg cairo --pkg pangocairo --pkg posix --vapidir=../vapi
VALAOPTS =
CFLAGS = -X -DCOGL_ENABLE_EXPERIMENTAL_2_0_API -X $(shell pkg-config --libs --cflags cogl-2.0-experimental cogl-pango-2.0-experimental pango cairo pangocairo | sed -e 's/ -/ -X -/g' -e 's/coglpango/cogl-pango/g')

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
