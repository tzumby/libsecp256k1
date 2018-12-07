MIX = mix

TARGET = priv/libsecp256k1_nif.so
SOURCE = src/libsecp256k1_nif.c
ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifeq ($(wildcard deps/libsecp256k1),)
	LIBSECP256K1_PATH = ../libsecp256k1
else
	LIBSECP256K1_PATH = deps/libsecp256k1
endif

CFLAGS += -I$(LIBSECP256K1_PATH) -I$(LIBSECP256K1_PATH)/src -I$(LIBSECP256K1_PATH)/include

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

LDFLAGS += deps/libsecp256k1/.libs/libsecp256k1.a -lgmp

.PHONY: clean

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -shared -o $@ $< $(LDFLAGS)

clean:
	$(MIX) clean
	$(MAKE) -C $(LIB_PATH) clean
	$(RM) $(TARGET)
