#Computer Architecture Project

.data
arrayOfNumbers: .space 4008	#creates enough space for 10000 elements in the array
menuTitle: .asciiz "Menu of Options\n---------------" 	#menu title displayed to user before input
regularArrayChoice: .asciiz "1) User input array filled with integers that don't have to be unique" 	#menu option 1 that allows user to input nonunique integers
uniqueArrayChoice: .asciiz "2) User input array filled with integers that are unique"		#menu option 2 that allows user to input unique integers checked by program
randomArray: .asciiz "3) Generate random integers to fill the array" 		#menu option 3 that fills array with random numbers from 1-1000
userChoicePrompt: .asciiz "Enter the number of your choice: " 		#prompt given to user to enter choice
arrayNumber: .asciiz "Enter nonzero number " 		#prompt given to user to enter number x
wrongEntered: .asciiz "A wrong input was entered. Please input a value on the menu.\n" 	#prompt outputted when the user enters the wrong number
nonZero: .asciiz "A nonzero number was not entered. Please reenter number " 		#prompt outputted when user doesn't enter a nonzero number
uniqueNumber: .asciiz "A unique number was not entered. Please reenter number " 	#prompt given to user when option 2 is picked and a nonunique number is entered
enter: .asciiz ": " 	#format for entering number
format: .asciiz "\n" 	#format to output a new line
sorted: .asciiz "\nSorted: " 	#label for sorted array
unsorted: .asciiz "\nUnsorted: " 	#label for unsorted array
formatComma: .asciiz ", " 	#format to put commas between each number in the arrays outputted
beginningBraces: .asciiz "[" 	#placed before beginning of array
endingBraces: .asciiz "]" 	#placed after end of array
bubbletime: .asciiz "\nElapsed Time For Bubble Sort: " 	#prompt showing time for bubble sort 
selectionSortTime: .asciiz "\nElapsed Time For Selection Sort: " 	#prompt showing time for selection sort
timeSpecific: .asciiz " millisecond(s)" 	#label for time calculated
minimumPrompt: .asciiz "\n\nMinimum Value in List: " 	#label for minimum value outputted
maximumPrompt: .asciiz "\nMaximum Value in List: " 	#label for maximum value outputted
avgPrompt: .asciiz "\nAverage Value of List: " 	#label for average value outputted
sortPrompt: .asciiz "\nSorting Method\n--------------" 	#label for menu of sorting methods following
sortMenu: .asciiz "\n1)Bubble Sort\n2)Selection Sort\nEnter Number of Sort to Use: " 	#menu of sorting methods that can be used
ascendingDescendingPrompt: .asciiz "\nOrder of Sorting\n----------------\n1)Ascending\n2)Descending\nEnter Number of Order to Use: " 	#menu for if user wants ascending or descending sorted list
arraySize: .asciiz "Enter Array Size (2-1000): " 	#prompt for user to enter size 
arraySizeValidation: .asciiz "A value greater than 1 or less than 1001 was not entered. Reenter Array Size: " 	#prompt outputted when a value out of bounds is entered

.text
CheckInput:
	#prompt asking user to enter size
	li $v0, 4
	la $a0, arraySize
	syscall
	
	#user input size
	li $v0, 5
	syscall
	
	move $s7, $v0 #stores the size in a sperate register $s7 for later user
ReenterSize:
	bgt $s7, 1, UpperBound #if the size is greater than 0
	j ArraySizeValidation #jumps the validation if this is not true
UpperBound:
	ble $s7, 1000, ContCheckInput #if the size is less than or equal to 1000 and if it is skips to outputting menu
	
ArraySizeValidation:
	#outputs prompt telling user to reenter a size within range
	li $v0, 4
	la $a0, arraySizeValidation
	syscall
	
	#user input is accepted
	li $v0, 5
	syscall
	
	move $s7, $v0 #the user input is stored in $s7 for later use
	j ReenterSize # the process to check if the number is valid is restarted
ContCheckInput:
	#prints a new line for better visual affect
	li $v0, 4
	la $a0, format
	syscall
	
	#prints the menu title
Branch:	li $v0, 4
	la $a0, menuTitle
	syscall
	#formats the output by printing a new line
	li $v0, 4
	la $a0, format
	syscall
	#menu option 1 is ouputted
	li $v0, 4
	la $a0, regularArrayChoice
	syscall
	#new line is ouputted
	li $v0, 4
	la $a0, format
	syscall
	#menu option 2 is outputted
	li $v0, 4
	la $a0, uniqueArrayChoice
	syscall
	#new line is outputted
	li $v0, 4
	la $a0, format
	syscall
	#menu option 3 is outputted
	li $v0, 4
	la $a0, randomArray
	syscall
	#new line is outputted
	li $v0, 4
	la $a0, format
	syscall
	#prompt for user to enter choice is outputted
	li $v0, 4
	la $a0, userChoicePrompt
	syscall
	#user enters integer for corresponding menu choice
	li $v0, 5
	syscall
	
	move $t0, $v0 #the inputted value is stored in $t0 for use
	bge $t0, 4, Repeat #input validation for if the value is 4 or greater
	ble $t0, 0, Repeat #input validation for if the value is 0 or less
	j StartFill #if the range requirement is met, the repeat is skipped
	#wrong number prompt is outputted
Repeat: li $v0, 4
	la $a0, wrongEntered
	syscall
	#new line is ouputted
	li $v0, 4 
	la $a0, format
	syscall
	
	j Branch 
StartFill:	
	la $s1, arrayOfNumbers #loads the array with the proper size
	li $t2, 1 #iterator is initialized to 1 for output ease
	addi $t3, $s7, 1 #the iterator end is initialized using the size entered by user
	beq $t0, 3, RandomFillLoop #if menu option 3 was entered, skips to random filling
ArrayFillLoop: 
	beq $t2, $t3, PreSort #when the iterator reaches the end, branch
	#ouput new line
	li $v0, 4
	la $a0, arrayNumber
	syscall
	
NonZeroCheck:
	#prints the prompt asking for each user number
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, enter
	syscall
	#gets user input
	li $v0, 5
	syscall
	
	bne $v0, $zero, ContArrayFill #if the input is 0, the user will be forced to reenter
	#prompt for zero is outputted
	li $v0, 4
	la $a0, nonZero
	syscall
	
	j NonZeroCheck #rechecks the reentered value
ContArrayFill:
	beq $t0, 1, ContFill #if menu option 1 was entered, the unique checking is skipped
StartCheck:
	la $s1, arrayOfNumbers #reassigns the array of numbers to make sure every value is checked in the array for unique validation
UniqueCheck: 
	lw $s3, ($s1) #stores the array value in a seperate register
	li $s4, 0 #iterator is defined
	beq $s3, $zero, ContFill #if the end of the array is reached, then continue the program
	UniqueInput:	
		bne $s3, $v0, ContCheck # if the 2 values are not equal continue with the program
		
		addi $s4, $s4, 1 # the iterator is added
		#unique number prompt is outputted
		li $v0, 4
		la $a0, uniqueNumber
		syscall
	
	UniqueNonZero:
		#checks if the number entered when unique number prompt asks user for new number is 0 and makes user reenter
		li $v0, 1
		move $a0, $t2
		syscall
	
		li $v0, 4
		la $a0, enter
		syscall
	
		li $v0, 5
		syscall
		
		bne $v0, $zero, ExitCheck #if the value is not equal to zero, program continues
		#prompt asking for nonzero value is outputted
		li $v0, 4
		la $a0, nonZero
		syscall
		
		j UniqueNonZero
ExitCheck:	j UniqueInput
ContCheck:
	beq $s4, 0, Increment #if the sentenial equals 0, then increment is called
	j StartCheck
Increment:
	addi $s1, $s1, 4 #array is incremented 4 to go to next value
	j UniqueCheck
ContFill:
	sw $v0, ($s1) #user input value stored in array
	addi $s1, $s1, 4 #array is incremented 4 to go to next value when increment is not called
	addi $t2, $t2, 1 #iterator is incremented
	j ArrayFillLoop
RandomFillLoop:
	beq $t2, $t3, PreSort #if iterator equals size + 1, then branch
	# random number generator gets a value
	li $v0, 42
	la $a1, 1000
	syscall
	#the value is sotred in the array
	sw $a0, ($s1)
	addi $s1, $s1, 4 #array is incremented by 4
	addi $t2, $t2, 1 #iterator incremented by 1
	
	j RandomFillLoop
PreSort:
	#menu for sorts is ouputted
	li $v0, 4
	la $a0, sortPrompt
	syscall

	li $v0, 4
	la $a0, sortMenu
	syscall
	#user is asked to enter corresponding menu value
	li $v0, 5
	syscall
	
	move $t8, $v0 #Saves number entered by user showing what sort to use
	bge $t8, 3, Repeat2 #input validation for if the input is greater than 2
	ble $t8, 0, Repeat2 #input validation for if the input is less than 1
	j SortingDirection
	
	#user is asked to reenter a value on the menu until a right value is inputted
Repeat2: li $v0, 4
	la $a0, wrongEntered
	syscall
	
	j PreSort
	
SortingDirection:
	#prompt for ascending or descending sorted list is outputted
	li $v0, 4
	la $a0, ascendingDescendingPrompt
	syscall
	#user inputs a value
	li $v0, 5
	syscall
	
	move $a2, $v0 #stores user option for ascending or descending in a parameter register for use in sorting methods
	bge $a2, 3, Repeat3 #input validation for if the value inputted is greater than 2
	ble $a2, 0, Repeat3 #input validation for if the value inputted is less than 1
	j DisplayUnsorted
	
	#the user is forced to reenter a valid value 
Repeat3: li $v0, 4
	la $a0, wrongEntered
	syscall
	
	j SortingDirection
DisplayUnsorted:
	#the unsorted label is printed
	li $v0, 4
	la $a0, unsorted
	syscall
	#the beginning braces showing output of array is printed
	li $v0, 4
	la $a0, beginningBraces
	syscall
	#array of numbers is reassigned
	la $s5,arrayOfNumbers                        
	li $s6,0    #iterator is assigned value of 0

	subi $t1, $s7, 1 #size - 1 is calculated
PrintUnsorted:
	#each value in the array is printed
	li $v0,1
	lw $a0,($s5)                       
	syscall

	beq $s6, $t1, FormatAfter #if the value is the last one, a comma is not outputted
	#comma seperated each value in the array
	li $v0, 4
	la $a0, formatComma
	syscall

FormatAfter:
	addi $s5,$s5,4     #array is incremented                 
	addi $s6,$s6,1     #iterator is incremented                  
	beq $s6,$s7,PrintCont	#if the iterator equals the size, program continues   
	j PrintUnsorted

PrintCont:
	#ending braces for array is printed
	li $v0, 4
	la $a0, endingBraces
	syscall
	
	li $t7, 4 #t7 is assigned the value 4 for multiplication
	mult $s7, $t7 #size x 4 calculates space is stack needed
	mflo $s2 #this value is stored in $s2
CreateStack: 
	la $t6, arrayOfNumbers #array storing numbers is redefined
	li $t2, 0	#the iterator is given base definition of 0
	sub $sp, $sp, $s2	#space need calculated above is created in stack for use
StackStore:	
	beq $t2, $s7, StopStore		#when the iterator equals the size, the stack is no longer filled
	mult $t2, $t7	#the iterator is multiplied by 4
	mflo $t3	#calculated value stored in $t3
	add $t4, $t3, $sp	#space for stack value calculated
	lw $t5, ($t6)	#the element is loaded from the array
	sw $t5, ($t4)	#the element is stored in the stack
						
	addi $t2, $t2, 1	#iterator is incremented
	addi $t6, $t6, 4	#array is incremented
	j StackStore   

StopStore:	
	#system time is found and stored in a seperate register for later use
	li $v0, 30
	syscall
	move $s5, $a0
	
	beq $t8, 2, SelectionSortStart	#if selection sort was picked in the menu, the program skips to code for selection sort
BubbleSortStart:
	la $a0,arrayOfNumbers    #loads array of numbers in parameter register $a0                   
	move $a1, $s7	#moves the size to parameter register $a1
	jal BubbleSortFunc	#jumps to bubble sort function
	move $s3, $v1	# the last number of the array returned by the function moved to $s3
	#gets system time after function finishes and stores it in a seperate register
	li $v0, 30
	syscall
	move $s6, $a0 
	
	j AfterSort    
SelectionSortStart:
	move $a0,$sp	#move the stack pointer to parameter register $a0    
	move $a1, $s7	#move the size of the array to parameter register $a1
	jal SelectionSort      #jumps to selection sort function
	
	subi $s4, $s7, 1	# calculates size - 1
	#gets system time after function finishes and shores it in a seperate register
	li $v0, 30
	syscall
	move $s6, $a0
	
	li $s1, 0	#loads base case 0 into iterator
	la $a0, arrayOfNumbers	#reloads array of numbers into register for use
	LoadToArray:
		#calculates the iterator*4 and adds it to $t1 to get right stack position
		li $t0, 4
		mult $s1, $t0
		mflo $t0
		add $t1, $t0, $sp
				
		lw $t9, ($t1)	#loads each element from the stack into $t9 
		bne $s4, $s1, ContLoadToArray
		move $s3, $t9	#stores last element in array
	ContLoadToArray:
		sw $t9, ($a0)	#stores each word from stack into array again
		addi $s1, $s1, 1	#increments iterator
		addi $a0, $a0, 4	#increments stack
		beq $s1,$s7,AfterSort	#when the iterator equals the array size, branch
		j LoadToArray
	
AfterSort:
	add $sp, $sp, $s2	#deletes stack
	#prints out sorted prompt
	li $v0,4
	la $a0,sorted 
	syscall
	#outputs braces for beginning of array
	li $v0, 4
	la $a0, beginningBraces
	syscall
	
	la $t0,arrayOfNumbers      #loads array of numbers                  
	li $t1,0	#defines iterator                             

	subi $t3, $s7, 1	#calculates size - 1 and puts it in a register
PrintSorted:
	#prints out each element in the array
	li $v0,1
	lw $a0,($t0)                       
	syscall
	
	beq $t1, $t3, AfterFormat	#if the iterator = size - 1, branch / doesn't output comma for last element
	#ouputs commas between each element
	li $v0, 4
	la $a0, formatComma
	syscall

AfterFormat:
	addi $t0,$t0,4      #increments array                
	addi $t1,$t1,1      #increments iterator                     
	beq $t1,$s7,ContPrint                 
	j PrintSorted
	
ContPrint:
	#prints ending braces of array
	li $v0, 4
	la $a0, endingBraces
	syscall

Exit:	
beq $t8, 2, SelectionRunTime	#if selection sort was picked, branch to selection run time prompt
BubbleRunTime:
	#prints bubble runtime prompt
	li $v0, 4
	la $a0, bubbletime
	syscall
	j ContExit
SelectionRunTime:
	#prints selection runtime prompt
	li $v0, 4
	la $a0, selectionSortTime
	syscall
ContExit:
	sub $s5, $s6, $s5	#calculates runtime for function by subtracting two values before and after sort is called
	#prints the runtime
	li $v0, 1
	move $a0, $s5
	syscall
	#prints the units for runtime
	li $v0, 4
	la $a0, timeSpecific
	syscall
	
	la $t0, arrayOfNumbers	#redefines array of numbers
Minimum:
	#prints the prompt for minimum
	li $v0, 4
	la $a0, minimumPrompt
	syscall
	
	beq $a2, 2, MinDescending	#branches to descending if the user chose descending order
	MinAscending:
		lw $s5, 0($t0)	#prints the first value of the array which is also the smallest value in the array
		j ContinueMinimum
	MinDescending:
		move $s5, $s3 #prints the value returned in the functions which is also the last value in the descending array
	ContinueMinimum:
	#prints minimum number
	li $v0, 1
	move $a0, $s5
	syscall
Maximum:
	#prints maximum prompt
	li $v0, 4
	la $a0, maximumPrompt
	syscall
	
	beq $a2, 2, MaxDescending #branches if the user chose descending sort direction
	MaxAscending:
		move $s5, $s3	#uses the number returned by the functions which gets the last value in the array
		j ContinueMaximum
	MaxDescending:
		lw $s5, 0($t0)	#prints the first number of the array which is the biggest in a sorted descending array
	ContinueMaximum:
	#prints the maximum value
	li $v0, 1
	move $a0, $s5
	syscall
Average:
	li $s5, 0 #average
	li $s6, 0 #loop iterator
	li $s1, 0 #loads the number from the array
	AvgLoop:
		beq $s6, $s7,AvgLoopEnd		#if the iterator = size, branch
		lw $s1, ($t0)	#loads each word to $s1
		add $s5, $s5, $s1 #the value is added to the average total
		addi $t0, $t0, 4	#the array is incremented
		addi $s6, $s6, 1	#the iterator is incremented
		j AvgLoop
AvgLoopEnd:
	mtc1.d $s7, $f2 #stores the size in a float register
	cvt.d.w $f2, $f2 #the word is converted to a float
	mtc1.d $s5, $f4 #stores the total in a float register 
	cvt.d.w $f4, $f4 #the word is converted to a float
	div.d $f12, $f4, $f2 #divides the total by the size of the array and puts the quotient in another float register
	#prints the average prompt
	li $v0, 4
	la $a0, avgPrompt
	syscall
	#displays the average
	li $v0, 3
	syscall
ProgramEnd:
	#the program ends
	li $v0, 10
	syscall

BubbleSortFunc:
li $s1,0       #defines the outer loop iterator
	OuterLoop:
		addi $s1,$s1,1	#increments the first iterator              
		bgt $s1,$a1,BubbleSortEnd      #if the iterator is bigger than the size, then the function ends            
		move $s2, $a1      #stores the size in a seperate register
		InnerLoop:
			beq $s1,$s2,OuterLoop	#if the iterator equals the size, branch
			subi $s2,$s2,1	#subtract the copied size by 1                 
   			#(inner loop iterator * 4) - 4
			li $t9, 4    
			mult $s2, $t9
			mflo $t3      
			subi $s4, $t3, 4                    
			add $t3,$t3,$a0  #add the array with the calculated value                                     
			lw $t5,($t3)	#load the value into a register
			add $s4,$s4,$a0   #add the array with the calculated value minus 4
			lw $s6,($s4)	#load the value into a register

			beq $a2, 2, descending	#if the user picked descending order of sort branch to descending
			ascending:
				#swaps the 2 values and stores them in the opposite positions if the value infront is smaller
				bgt $t5,$s6,InnerLoop                   
				sw $t5,($s4)                       
				sw $s6,($t3)
				j InnerLoop
			descending:
				#swaps the 2 values and stores them in the opposite positions if the value infront is bigger
				blt $t5, $s6, InnerLoop
				sw $t5,($s4)                       
				sw $s6,($t3)
				j InnerLoop
BubbleSortEnd:
lw $s3, ($t3)	#loads the last value in the array for use in minimum/maximum
move $v1, $s3	#moves the value to a return register
jr $ra


SelectionSort:	
	#creates extra space for variables
	addi $sp, $sp, -20	#space for 4 variables created	
	sw $ra, 0($sp)
	sw $t2, 4($sp)	#holds array address
	sw $t3, 8($sp)	
	sw $t4, 12($sp)
	sw $t5, 16($sp)
	move $t2, $a0	
	subi $t4, $a1, 1	#size - 1 is stored in a register	
	li $t3, 0	#iterator base set as 0	
	SelectionSortLoop:	
		beq $t3, $t4, SelectionSortStop		#if the iterator is bigger than the size - 1, branch
		move $a0, $t2	#the address of the array given from $t2 to be used in finding minimum index
		move $a3, $t4	#the iterator is moved to $a3 to be used in finding minimum index
		move $a1, $t3	#size - 1 is moved to $a1 to be used in finding minimum index
	MinJump:
		jal MinIndexLoc	# jump to minimum index function
		move $a3, $v1	#the minimum index stored back in $a3
		move $a0, $t2	#the address of array is stored back in $a0
		move $a1, $t3	#the iterator is stored back in $a1
	SwapJump:
		jal Swap	#jumps to swap function
		addi $t3, $t3, 1	#the iterator is incremented by 1	
		
		j SelectionSortLoop		
SelectionSortStop:	
	#everything in the stack is put back in registers
	lw $ra, 0($sp)		
	lw $t2, 4($sp)
	lw $t3, 8($sp)
	lw $t4, 12($sp)
	lw $t5, 16($sp)
	addi $sp, $sp, 20	#stack space is erased by adding back space allocated for variables	
	jr $ra			


# swap routine
Swap:
	#calculates the iterator multiplied by 4
	li $t6, 4
	mult $a1, $t6
	mflo $t6
	add $t6, $t6, $a0	#array base address added by iterator to find needed number	
		
	#calculates the other iterator multiplied by 4
	li $t1, 4
	mult $a3, $t1
	mflo $t1
	add $t1, $t1, $a0	#array base address added by iterator to find needed number

Change:	lw $t9, ($t6)	#loads the base array + the first iterator to $t9 register
	lw $s0, ($t1)	#loads the base array + the second iterator to $s0 register
	sw $s0, ($t6)	#stores the second value in the position of the first value
	sw $t9, ($t1)	#stores the first value in the position of the second value
SwapFinish:
	jr $ra

MinIndexLoc:	
GetInfo:
	move $t1, $a3	#size is loaded into register $t1
	move $t9, $a0	#array is loaded into register $t9
	move $t6, $a1	#iterator is loaded into register $t6	
	#calculates the index by multiplying the iterator by 4 and adding it to the array base
	li $s0, 4
	mult $t6, $s0	
	mflo $s0
	add $s0, $s0, $t9			
	lw $s6, ($s0)	#loads the value calculated into $s6 register
	addi $s2, $t6, 1	#next iterator value loaded into $s2 register for looping	
	MinIndexLoop:	
		bgt $s2, $t1, MinIndexEnd	#if the iterator becomes larger than the size, branch
		#calculates the index by multiplying the iterator by 4 and adding it to the array base
		li $t0, 4
		mult $s2, $t0
		mflo $t0
		add $t0, $t0, $t9			
		lw $s3, ($t0)	#loads the value calculated into the $s3 register
		
		beq $a2, 2, Descend	#if the user chose descending order, branch to descend
		Ascend:
			# if the second value loaded is greater than or equal to the first value loaded, loop again
			bge $s3, $s6, MinIndexExitCase	
			j ContSelectionSort
		Descend:
			#if the second value is less than the first value loaded, loop again
			blt $s3, $s6, MinIndexExitCase
ContSelectionSort:
	move $t6, $s2	#store the index in register $t6
	move $s6, $s3	#store the value at the index in register $s6
MinIndexExitCase:
	addi $s2, $s2, 1	#increment iterator by 1		
	j MinIndexLoop

MinIndexEnd:	
	move $v1, $t6	#move the index of the smallest or largest value so far to the return register
	jr $ra

