SRCS = cogl-crate.vala
PROGRAM = cogl-crate
VALAPKGS = --pkg cogl-2.0 --vapidir=../vapi
VALAOPTS =
CFLAGS = -X -DCOGL_ENABLE_EXPERIMENTAL_2_0_API -X $(shell pkg-config --libs --cflags cogl-2.0-experimental | sed 's/ -/ -X -/g')

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
