SRCS = cogl1-clutter-3d.vala
PROGRAM = cogl1-clutter-3d
VALAPKGS = --pkg clutter-1.0
VALAOPTS =
CFLAGS = -X -lm

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
