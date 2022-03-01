#
# Copyright (C) 2021 by Intel Corporation
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

	.intel_syntax noprefix

	.globl _mce_scalar
	.globl mce_scalar

	# void mce_scalar(uint32_t *out, const uint32_t *in, uint64_t width)
	# On entry:
	#     rdi = out
	#     rsi = in
	#     rdx = width (must be > 0)

	.text

_mce_scalar:
mce_scalar:

	push rbx

	                    # mov rsi, pImage
	                    # mov rdi, pOutImage
	mov rbx, rdx	    # mov rbx, len
	xor rax, rax
	
mainloop:
	mov r8d, dword ptr [rsi+rax*4]
	mov r9d, r8d
	cmp r8d, 0
	jle label1
	and r9d, 0x3
	cmp r9d, 3
	jne label1
	add r8d, 5
label1:
	mov dword ptr [rdi+rax*4], r8d
	add rax, 1
	cmp rax, rbx
	jne mainloop

	pop rbx
	ret

#if defined(__linux__) && defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
