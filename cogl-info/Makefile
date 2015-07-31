SRCS = cogl-info.vala
PROGRAM = cogl-info
VALAPKGS = --pkg cogl-2.0 --vapidir=../vapi
VALAOPTS =
CFLAGS = -X $(shell pkg-config --libs --cflags cogl-2.0-experimental | sed 's/ -/ -X -/g')

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
