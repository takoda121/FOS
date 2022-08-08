#include "types.h"
#include "gtd.h"

void print(char* in)
{
    static uint16_t* VideoMemory = (uint16_t*)0xb8000;

    for(int i = 0; in[i] != '\0'; ++i)
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | in[i];
}

typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;
extern "C" void callConstructors()
{
    for(constructor* i = &start_ctors; i != &end_ctors; i++)
        (*i)();
}
extern "C" void FOSKernel(void* multiboot_stucture,uint32_t magicnumber)
{
    print("Hello world from FOS(F Operating System)");
    GlobalDescriptorTable gdt;
    while(1);
}