SRCS = src/vala-cogl.vala
PROGRAM = vala-cogl
VALAPKGS = --pkg clutter-1.0
VALAOPTS =
CFLAGS = -X -lm

ifndef VALA_COLORS
	VALA_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
	export VALA_COLORS
endif

ifndef GCC_COLORS
	GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
	export GCC_COLORS
endif

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
