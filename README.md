<h2>Tutorial :</h2>
<h3>How to compile and execute the assembly files:</h3>
<p>All the source code is located at ./arinjoy/ASSIGN1 for Assignment 1 and ./arinjoy/ASSIGN2 for Assignment 2 <br> To compile the code in dosbox environment use <b>ML.exe</b></p>
<p><b>Sample code compilation and execution:</b><br>Firstly mount the folder as C drive using 'mount c ./System-Programming-Lab' and 'c:'
<br><i>ML.EXE ./ARINJOY/ASSIGN1/1.ASM </i>: This will compile the asm file and create an executable '1.EXE' in the same folder as 'ML.EXE'.<br>
 Now to run the executable: <i>1.EXE</i><br>If no errors were thrown then the following output should be shown on the screen : <i>Display Your Name by Arinjoy Pramanik</i>
</p>
<p><b>Basic Syntax of all assembly programs in this repository:</b><br>
.model small<br>.stack 100h<br>.data<br>.code<br>main proc<br><b>...</b><br>mov ah, 4ch<br>int 21h<br>main endp<br><i>other procedures</i><br>end main<br>
</p>
<p><i><b>Tips:</b> The codebase might be overwhelming at the begining, start with the basic codes to get familiar with the commonly used procedures such as readnum and writenum, why different segments such as data, code, 
extra segments are used.<br>Use </i>Tabs<i> in dosbox for autocomplete.<br>You can ssh into the server using GNOME Files by using other network locations and the address as ssh://server-ip-address@S_Roll_Number
<br>If using command line for SSH use special care to use capital X in the command 'ssh -X server-ip-address@S_Roll_Number</p>
