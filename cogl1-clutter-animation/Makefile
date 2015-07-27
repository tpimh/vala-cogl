SRCS = cogl1-clutter-animation.vala
PROGRAM = cogl1-clutter-animation
VALAPKGS = --pkg clutter-1.0
VALAOPTS =
CFLAGS =

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
