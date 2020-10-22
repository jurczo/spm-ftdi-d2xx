
lib_ftdi := $(wildcard libftd2xx*.dylib)
lib_fixed := "libftd2xx.dylib"
test:
	@echo "Adjusting the '$(lib_ftdi)' to be used inside a framework"
	@ditto $(lib_ftdi) "./$(lib_fixed)"
	@install_name_tool -id "@rpath/../Frameworks/$(lib_fixed)" $(lib_fixed)

.PHONY: clean
clean:
	rm -rf $(lib_fixed)

