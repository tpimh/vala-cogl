SRCS = cogl-hello.vala
PROGRAM = cogl-hello
VALAPKGS = --pkg cogl-2.0 --vapidir=../vapi
VALAOPTS =
CFLAGS = -X -DCOGL_ENABLE_EXPERIMENTAL_2_0_API -X -I/usr/include/cogl -X -lcogl -X -I/usr/include/drm

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
