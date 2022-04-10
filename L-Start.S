/*
 * 1.text 是ARM GUN中的伪指令，意思是以下是代码段 
 *  .global 以为定义一个全局符号,
 */

.text
.global _start

_start:

	/* 关闭看门狗 */.
  //ldr 从右向左读  str 从左向右写
  
	ldr r0, =0x53000000   //此处的ldr是伪指令，意味将0x53000000装载入r0寄存器，下同
	ldr r1, =0
	str r1, [r0]          //将r1中的0 存入 r1寄存器中所表示地址上

	/* 设置内存: sp 栈 */
	/* 分辨是nor/nand启动
	 * 写0到0地址, 再读出来
	 * 如果得到0, 表示0地址上的内容被修改了, 它对应ram, 这就是nand启动
	 * 否则就是nor启动
	 */
	 //Nand flash 可以理解成片内内存
	 //Nor flash 可以理解成硬盘， 对应nor flash地址，可以像片内内存一样读，但是必须以特殊格式写
	 
	mov r1, #0   //把0写入R1寄存器
	ldr r0, [r1] //把0地址的数据读入地址为R0处
	str r1, [r1] //把0写入地址为R1处
	ldr r2, [r1] //把0地址的数据读到R2中

	cmp r1, r2   //比较R1R2相等说明能成功写入，是nand启动，CMP只修改标志位不修改寄存器
	ldr sp, =0x40000000+4096 //预先设置为nor启动，将sp置于nor启动位置

	moveq sp, #4096  //只有CMP成立的时会运行，将sp至于nand启动位置
	streq r0, [r1]   //只有CMP成立时运行，说明是nand启动，需要恢复[0]数据
	
	bl main          //这里就是说明 为什么main函数是main函数的原因

halt:
	b halt  
