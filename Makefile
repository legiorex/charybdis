USER = default

KEYBOARDS = charybdis
PATH_charybdis = bastardkb/charybdis/4x6/v2/promicro

# bastardkb/charybdis/4x6/v2/promicro
all: $(KEYBOARDS)

.PHONY: $(KEYBOARDS)
$(KEYBOARDS):
	# init submodule
	git submodule update --init --recursive

	# cleanup old symlinks
	for f in $(KEYBOARDS); do rm -rf qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/keymaps/$(USER)/keymap; done
	# for f in $(KEYBOARDS); do rm -rf qmk_firmware/keyboards/$(PATH_$@)/keymaps/$(USER); done
	rm -rf qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/promicro

	# add new symlinks
	ln -s $(shell pwd)/4x6/v2/keymaps/$(USER)/keymap.c test
	ln -s $(shell pwd)/4x6/v2/promicro/info.json /qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/promicro/info.json

	# run lint check
	cd qmk_firmware; qmk lint -km $(USER) -kb $(PATH_$@) --strict

	# run build
	make BUILD_DIR=$(shell pwd) -j1 -C qmk_firmware $(PATH_$@):$(USER)

	# cleanup symlinks
	for f in $(KEYBOARDS); do rm -rf qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/keymaps/$(USER); done
	rm -rf qmk_firmware/keyboards/bastardkb/charybdis/4x6/v2/promicro

clean:
	rm -rf obj_*
	rm -f *.elf
	rm -f *.map
	rm -f *.hex
