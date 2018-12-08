MIX = mix

TARGET = priv/libsecp256k1_nif.so
SOURCE = src/libsecp256k1_nif.c
ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifeq ($(wildcard deps/libsecp256k1_source),)
	LIB_PATH = ../libsecp256k1_source
else
	LIB_PATH = deps/libsecp256k1_source
endif

CFLAGS += -I$(LIB_PATH) -I$(LIB_PATH)/src -I$(LIB_PATH)/include

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

LDFLAGS += $(LIB_PATH)/.libs/libsecp256k1.a -lgmp

.PHONY: clean

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -shared -o $@ $< $(LDFLAGS)

clean:
	$(MIX) clean
	$(MAKE) -C $(LIB_PATH) clean
	$(RM) $(TARGET)
