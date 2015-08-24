METADATA = metadata
VAPIDIR = $(shell pkg-config libvala-`valac --api-version` --variable vapidir)
GIRDIR = $(shell pkg-config gobject-introspection-1.0 --variable girdir)

all: cogl-2.0.vapi cogl-pango-2.0.vapi cogl-gst-2.0.vapi

cogl-2.0.vapi:
	vapigen --library=cogl-2.0 --pkg glib-2.0 --pkg gobject-2.0 \
        --metadatadir=$(METADATA) --directory=. $(GIRDIR)/Cogl-2.0.gir $(METADATA)/cogl-2.0-custom.vala
	uniq cogl-2.0.vapi | sponge cogl-2.0.vapi # this is really nasty hack

cogl-pango-2.0.vapi:
	vapigen --library=cogl-pango-2.0 --pkg pango --pkg pangocairo --pkg glib-2.0 --pkg gobject-2.0 \
        --metadatadir=$(METADATA) --directory=. $(GIRDIR)/CoglPango-2.0.gir

cogl-gst-2.0.vapi:
	vapigen --library=cogl-gst-2.0 --pkg gstreamer-1.0 --pkg glib-2.0 --pkg gobject-2.0 \
        --metadatadir=$(METADATA) --directory=. $(GIRDIR)/CoglGst-2.0.gir

doc: cogl-2.0.vapi cogl-pango-2.0.vapi
	valadoc -o doc --vapidir=$(VAPIDIR) --importdir=$(GIRDIR) --import=Cogl-2.0 --import=CoglPango-2.0 \
        --pkg pango --pkg pangocairo cogl-2.0.vapi cogl-pango-2.0.vapi

clean:
	rm -rf cogl-2.0.vapi cogl-pango-2.0.vapi cogl-gst-2.0.vapi doc
