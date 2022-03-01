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

	.globl _median_sse
	.globl median_sse

	# void median_sse(float *x, float *y, uint64_t len);
	# On entry:
	#     rdi = x
	#     rsi = y
	#     rdx = len

	.text

_median_sse:
median_sse:

	push rbx

	xor ebx, ebx
	mov rcx, rdx   # mov rcx, len

	# rdi and rsi already point to x and y the inputs and outputs
	# mov rdi, inPtr
	# mov rsi, outPtr

	movaps xmm0, [rdi]
loop_start:
	movaps xmm4, [rdi+16]
	movaps xmm2, [rdi]
	movaps xmm1, [rdi]
	movaps xmm3, [rdi]
	add rdi, 16
	add rbx, 4
	shufps xmm2, xmm4, 0x4e
	shufps xmm1, xmm2, 0x99
	minps xmm3, xmm1
	maxps xmm0, xmm1
	minps xmm0, xmm2
	maxps xmm0, xmm3
	movaps [rsi], xmm0
	movaps xmm0, xmm4
	add rsi, 16
	cmp rbx, rcx
	jl loop_start

	pop rbx
	ret

#if defined(__linux__) && defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
