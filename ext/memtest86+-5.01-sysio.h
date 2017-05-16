#ifndef	_SYS_IO_H
#define	_SYS_IO_H
#ifdef __cplusplus
extern "C" {
#endif

#include <features.h>

#include <bits/io.h>

int iopl(int);
int ioperm(unsigned long, unsigned long, int);

/* Copied from uClibc */
static __inline unsigned char
inb_p (unsigned short int port)
{
  unsigned char _v;

  __asm__ __volatile__ ("inb %w1,%0\noutb %%al,$0x80":"=a" (_v):"Nd" (port));
  return _v;
}

static __inline void
outb_p (unsigned char value, unsigned short int port)
{
  __asm__ __volatile__ ("outb %b0,%w1\noutb %%al,$0x80": :"a" (value),
			"Nd" (port));
}

#ifdef __cplusplus
}
#endif
#endif
