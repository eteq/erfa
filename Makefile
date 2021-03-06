CFLAGS = -Wall -O
LDFLAGS = -fPIC 

SRCDIR = src
BUILDDIR = build
LIBNAME = liberfa

OBJECTS = $(patsubst %.c,%.o,$(filter-out $(SRCDIR)/t_erfa_c.c,$(wildcard $(SRCDIR)/*.c)))
HEADERS = $(SRCDIR)/*.h 

UNAME := $(shell uname)

buildstatic : buildobj cpheaders
	ar rcs $(BUILDDIR)/$(LIBNAME).a $(OBJECTS)

buildshared : buildobj cpheaders
ifeq ($(UNAME), Darwin)
	$(CC) $(CFLAGS) $(LDFLAGS) -shared -o $(BUILDDIR)/$(LIBNAME).dylib $(OBJECTS)
else
	$(CC) $(CFLAGS) $(LDFLAGS) -shared -o $(BUILDDIR)/$(LIBNAME).so $(OBJECTS)
endif

buildobj : $(OBJECTS) mkbuild

cpheaders : mkbuild
	cp $(HEADERS) $(BUILDDIR)

buildtest : buildstatic
	$(CC) $(CFLAGS) $(LDFLAGS) -L$(BUILDDIR) $(SRCDIR)/t_erfa_c.c -lerfa -lm -o $(BUILDDIR)/test_erfa

test : buildtest
	$(BUILDDIR)/test_erfa --verbose

mkbuild : 
	mkdir -p $(BUILDDIR) 

clean :
	rm $(SRCDIR)/*.o
	rm -rf $(BUILDDIR)
