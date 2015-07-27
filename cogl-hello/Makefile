SRCS = cogl-hello.vala
PROGRAM = cogl-hello
VALAPKGS = --pkg cogl-2.0 --vapidir=../vapi
VALAOPTS =
CFLAGS = -X -DCOGL_ENABLE_EXPERIMENTAL_2_0_API -X -I/usr/include/cogl -X -lcogl -X -I/usr/include/drm

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
