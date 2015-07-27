SRCS = cogl-info.vala
PROGRAM = cogl-info
VALAPKGS = --pkg cogl-2.0 --vapidir=../vapi
VALAOPTS =
CFLAGS = -X -I/usr/include/cogl -X -lcogl

all: $(PROGRAM)

$(PROGRAM): $(SRCS)
	valac $(VALAOPTS) $(VALAPKGS) $(CFLAGS) -o $(PROGRAM) $(SRCS)

clean:
	rm -f $(PROGRAM)
