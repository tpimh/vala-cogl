SRCS = cogl1-clutter-animation.vala
PROGRAM = cogl1-clutter-animation
VALAPKGS = --pkg clutter-1.0
VALAOPTS =
CFLAGS = -X $(shell pkg-config --libs --cflags cogl-1.0 clutter-1.0 | sed 's/ -/ -X -/g')

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
