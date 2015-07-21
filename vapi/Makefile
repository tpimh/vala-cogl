METADATA = metadata

all: cogl-2.0.vapi cogl-pango-2.0.vapi

cogl-2.0.vapi:
	vapigen --library=cogl-2.0 --pkg glib-2.0 --pkg gobject-2.0 --metadatadir=$(METADATA) --directory=. /usr/share/gir-1.0/Cogl-2.0.gir

cogl-pango-2.0.vapi:
	vapigen --library=cogl-pango-2.0 --pkg pango --pkg pangocairo --pkg glib-2.0 --pkg gobject-2.0 --metadatadir=$(METADATA) --directory=. /usr/share/gir-1.0/CoglPango-2.0.gir

clean:
	rm -f cogl-2.0.vapi cogl-pango-2.0.vapi
