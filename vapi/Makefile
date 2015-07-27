METADATA = metadata
VAPIDIR = /usr/share/vala-0.28/vapi/
GIRDIR = /usr/share/gir-1.0

all: cogl-2.0.vapi cogl-pango-2.0.vapi doc

cogl-2.0.vapi:
	vapigen --library=cogl-2.0 --pkg glib-2.0 --pkg gobject-2.0 --metadatadir=$(METADATA) --directory=. /usr/share/gir-1.0/Cogl-2.0.gir
	uniq cogl-2.0.vapi | sponge cogl-2.0.vapi # this is really nasty hack

cogl-pango-2.0.vapi:
	vapigen --library=cogl-pango-2.0 --pkg pango --pkg pangocairo --pkg glib-2.0 --pkg gobject-2.0 --metadatadir=$(METADATA) --directory=. /usr/share/gir-1.0/CoglPango-2.0.gir

	valadoc -o doc --vapidir=$(VAPIDIR) --importdir=$(GIRDIR) --import=Cogl-2.0 --import=CoglPango-2.0 --pkg pango --pkg pangocairo cogl-2.0.vapi cogl-pango-2.0.vapi
doc:

clean:
	rm -rf cogl-2.0.vapi cogl-pango-2.0.vapi doc
