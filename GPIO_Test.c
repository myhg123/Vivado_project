typedef struct{
	volatile unsigned int 	MODER;
	volatile unsigned int	ODR;
	volatile unsigned int	IDR;
}GPIO_TypeDef;

typedef struct 
{
	volatile unsigned int 	 SR;
	volatile unsigned int	 RDR;
	volatile unsigned int	 TDR;
	volatile unsigned int	 BRR;
	volatile unsigned int	 CR;

}UART_TypeDef;


#define GPIO_BASE		(0x00001000)
#define GPIOA_BASE		(GPIO_BASE + 0x000)
#define GPIOB_BASE		(GPIO_BASE + 0x200)
#define GPIOC_BASE		(GPIO_BASE + 0x400)
#define GPIOD_BASE		(GPIO_BASE + 0x600)
#define GPIOE_BASE		(GPIO_BASE + 0x800)
#define GPIOF_BASE		(GPIO_BASE + 0xa00)

#define GPIOA_MODER		(int *)(GPIOA_BASE+0x00)
#define GPIOA_ODR		(int *)(GPIOA_BASE+0x04)
#define GPIOA_IDR		(int *)(GPIOA_BASE+0x08)


#define GPIOB_MODER		(int *)(GPIOB_BASE+0x00)
#define GPIOB_ODR		(int *)(GPIOB_BASE+0x04)
#define GPIOB_IDR		(int *)(GPIOB_BASE+0x08)

#define GPIOC_MODER		(int *)(GPIOC_BASE+0x00)
#define GPIOC_ODR		(int *)(GPIOC_BASE+0x04)
#define GPIOC_IDR		(int *)(GPIOC_BASE+0x08)

#define GPIOD_MODER		(int *)(GPIOD_BASE+0x00)
#define GPIOD_ODR		(int *)(GPIOD_BASE+0x04)
#define GPIOD_IDR		(int *)(GPIOD_BASE+0x08)

#define GPIOE_MODER		(int *)(GPIOE_BASE+0x00)
#define GPIOE_ODR		(int *)(GPIOE_BASE+0x04)
#define GPIOE_IDR		(int *)(GPIOE_BASE+0x08)

#define GPIOH_MODER		(int *)(GPIOH_BASE+0x00)
#define GPIOH_ODR		(int *)(GPIOH_BASE+0x04)
#define GPIOH_IDR		(int *)(GPIOH_BASE+0x08)

#define GPIOA			((GPIO_TypeDef *)GPIOA_BASE)
#define GPIOB			((GPIO_TypeDef *)GPIOB_BASE)
#define GPIOC			((GPIO_TypeDef *)GPIOC_BASE)
#define GPIOD			((GPIO_TypeDef *)GPIOD_BASE)
#define GPIOE			((GPIO_TypeDef *)GPIOE_BASE)
#define GPIOH			((GPIO_TypeDef *)GPIOH_BASE)

#define UART_BASE		(0x00002400)
#define UART1_BASE		(UART_BASE+0x000)
#define UART2_BASE		(UART_BASE+0x200)

#define UART1			((UART_TypeDef *)UART1_BASE)
#define UART2			((UART_TypeDef *)UART2_BASE)

int main(){
	GPIOA->MODER |= 0xffff;
	GPIOC->MODER &= 0x0000;
	UART1->CR	 |= 0b111;
	UART1->BRR	 |= 0b1;
	int a=0;
	while(1){
		int SR;
		a++;
		GPIOA->ODR = GPIOC->IDR;
		
		SR = UART1->SR;
		SR = SR>>1;
		
		UART1->TDR = UART1->RDR;
		
	}
}

