GCCPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -fno-stack-protector
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = loader.o gtd.o kernel.o

%.o: %.cpp
		gcc $(GCCPARAMS) -c -o $@ $<

%.o: %.s
		as $(ASPARAMS) -o $@ $<

fos.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install: fos.bin #for use on ur person machine
		sudo cp $< /boot/mykernel.bin

#ISO!

fos.iso: fos.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp $< iso/boot
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "FOS"{' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/fos.bin' >> iso/boot/grub/grub.cfg
	echo '  boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso