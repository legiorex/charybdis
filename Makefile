USER = legiorex

KEYBOARDS = charybdis
PATH_charybdis = $(USER)/charybdis/4x6/v2/promicro

all: $(KEYBOARDS)

.PHONY: $(KEYBOARDS)
$(KEYBOARDS):
	# init submodule
	git submodule update --init --recursive

	# cleanup old symlinks
	for f in $(KEYBOARDS); do rm -rf qmk_firmware/keyboards/$(USER); done
	# for f in $(KEYBOARDS); do rm -rf qmk_firmware/keyboards/$(PATH_$@)/keymaps/$(USER); done
	# rm -rf qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/promicro

	# add new symlinks
	ln -s $(shell pwd)/legiorex qmk_firmware/keyboards/$(USER)
	# ln -s $(shell pwd)/charybdis/4x6/v2/promicro qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/promicro

	# run lint check
	cd qmk_firmware; qmk lint -km default -kb $(PATH_$@) --strict

	# run build
	# make BUILD_DIR=$(shell pwd) -j1 -C qmk_firmware $(PATH_$@):default
	cd qmk_firmware; qmk compile -km default -kb $(PATH_$@)

	# cleanup symlinks
	for f in $(KEYBOARDS); do rm -rf qmk_firmware/keyboards/$(USER); done
	# rm -rf qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/promicro

clean:
	rm -rf obj_*
	rm -f *.elf
	rm -f *.map
	rm -f *.hex
