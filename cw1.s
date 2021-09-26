/*
FILENAME :      cw1.s
DESCRIPTION :
        Encryptes and decrytpes a message using 2 private keys
AUTHORS :
        Andrew Murray   studentID: 100214063

The c code we used:

#include <stdio.h>

char toLower(char character)
{
    if(character >= 65 && character <= 90)
    {
        character+= 32;
    }
    return character;
}

int checkValidChar(char character)
{
    if((character < 97) || character > 122)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

int countInvalidChars(char input[], int inputLength)
{
    int invalidChars = 0;
    for(int i = 0; i < inputLength; i++)
    {
        input[i] = toLower(input[i]);
        if(!checkValidChar(input[i]))
        {
            invalidChars++;
        }
    }
    return invalidChars;
}

char encode(char messageChar, char pass1Char,char pass2Char)
{
    pass1Char -= 98;
    pass2Char -= 98;
    messageChar -= pass1Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }

    messageChar -= pass2Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }
    return messageChar;
}
char decode(unsigned char messageChar, char pass1Char, char pass2Char)
{
    pass1Char -= 98;
    pass2Char -= 98;
    messageChar += pass1Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }

    messageChar += pass2Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }

    return messageChar;
}

int getLength(char pass[])
{
    int length = 1, length2 = 1;
    int i = 0, strend = 0;
    while(strend == 0)
    {
        i++;
        if(pass[i] == '\0')
        {
            strend = 1;
        }
        else
        {
            length++;
        }
    }
int coprime(int length1, int length2)
{
    while(length1 != length2)
    {
        if(length1 > length2)
        {
            length1 -= length2;
        }
        else
        {
            length2 -= length1;
        }
    }
    //printf("%i",length1);
    if(length1 == 1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
int main(int argc, char *argv[]) {
    char input[] = "AbC  De f 56784 g++- -= h i J j K L mnopqrs t &&&u v wxy 21270496350z";
    int inputLength = getLength(input);
    int invalidChars = 0;
    int messageLength = inputLength - countInvalidChars(input, inputLength);
    char message[messageLength];
    char pass1[] = "lock";
    int pass1Length = getLength(pass1);
    char pass2[] = "key";
    int pass2Length = getLength(pass2);
    int isCoprime = coprime(pass1Length, pass2Length);

    if(!isCoprime)
    {
        printf("keys used are not co-prime");
        return 0;
    }

    for(int i = 0, j = 0; i < inputLength; i++)
    {
        if(checkValidChar(input[i]))
        {
            message[j] = input[i];
            j++;
        }
    }

    char encodedMessage[messageLength];
    char decodedMessage[messageLength];

    for (int i = 0; i < messageLength; i++) {
        char temp = encode(message[i], pass1[i % pass1Length], pass2[i % pass2Length]);
        if (temp != ' ') {
            encodedMessage[i] = temp;
            printf("%c", encodedMessage[i]);
        }
    }

    printf("\n");

    for (int i = 0; i < messageLength; i++) {
        char temp = decode(encodedMessage[i], pass2[i % pass2Length], pass1[i % pass1Len$
        if (temp != ' ') {
            decodedMessage[i] = temp;
            printf("%c", decodedMessage[i]);
        }
    }

    return 1;
}

*/
.data
char:
    .asciz "%c"                         @ format for printing a char using printf
newline:
    .asciz "\n"                         @ format for printing a new lineusing printf
.text
    .global main                        @ set global function to main

errmessage: .asciz "keys not coprime\n" @error message when keys aren't coprime
result: .asciz "keys are coprime\n" @message used for testing it works

@//////////////////////////////////////////////////////////////////////
@//////////////////////////////////////////////////////////////////
@registers:
@ r4 - encrypt/decrypy choice
@ r5 - private key
@ r6 - copy of r5 for key resets
@ r7 - second private key
@//////////////////////////////////////////////////////////////////
@/////////////////////////////////////////////////////////////////

main:
        PUSH {r4,r5,r6,r7,r8,lr}
        @get encrypt/decrypt choice
        LDR r3, [r1, #4]
        @load choice into r4
        LDRB r4, [r3], #4
        @private key becomes r5
        LDR r5, [r1, #8]
        @moved key into r6 for resets
        MOV r6, r5

/*
        for co-prime
        MOV r0,#5
        MOV r1,#5
        BL coprime      @calls coprime function
        BX lr

function to return if 1 if values are coprime else return 0

/*
int coprime(int length1, int length2)
{
    while(length1 != length2)
    {
        if(length1 > length2)
        {
            length1 -= length2;
        }
        else
        {
            length2 -= length1;
        }
    }
    //printf("%i",length1);
    if(length1 == 1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
*/

coprime:
        CMP r0, r1              @compare inputs
        SUBGT r0, r0, r1        @if (r0 > r1){r0 -= r1}
        BGT coprime             @continue loop
        SUBLT r1, r1, r0        @if(r0 < r1){r1 -= r0}
        BLT coprime             @continue loop
        CMP r0, #1
        MOV r0, #0              @if(r0 == 1){r0 = 1}
        BEQ true                @function calls to the print functions
        B notcoprime

@function to return print message that values are coprime, can delete
true:
        LDR r0,=result
        PUSH {lr}
        BL printf
        POP {lr}
        BX lr
@function to print error message when keys aren't coprime
notcoprime:
        LDR r0,=errmessage
        PUSH {lr}
        BL printf
        POP {lr}
        BX lr

*/
@////////////////////////////////////////////////////////////////////////
@function: getchar   (charToLower/checkIsValid)
@desc:gets the next character and checks if its in the alphabet and lowercase
@return: lowercase char

/*
char toLower(char character)
{
    if(character >= 65 && character <= 90)
    {
        character+= 32;
    }
    return character;
}

int checkValidChar(char character)
{
    if((character < 97) || character > 122)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}
*/

getnewchar:
        BL getchar
        @check if there is another character
        CMP r0, #-1
        @Branch to end program if it is
        BEQ end
        @check if its an alphabet
        CMP r0, #65
        @if its less than skip (not alphabet)
        BLT getnewchar
        @making uppercase lowercase
        CMP r0, #90
        ADDLE r0, #32
        @once lowercase go to mode
        BLE loop

@////////////////////////////////////////////////////////////////////////
@function: loop   (charToLower/checkIsValid)
@desc:load private key and encrypt/decrypt mode
@return: send char to decrypt/encrypt

/*
for(int i = 0, j = 0; i < inputLength; i++)
    {
        if(checkValidChar(input[i]))
        {
            message[j] = input[i];
            j++;
        }
    }
*/

loop:
        @putting private keys into r2 and increment of each character
        LDRB r2,[r5], #1
        CMP r2, #0
        @if null it resets keys for encrypt/decrypt
        MOVEQ r5, r6
        BEQ loop
        @char and keys between 1 -26
        SUB r0, #96
        SUB r2, #96
        @if not 0 then put in decrypt mode
        CMP r4, #48
        BNE decrypt
@////////////////////////////////////////////////////////////////////////
@function: encrypt   (encode)
@desc:encrypt char using two keys
@return: encrypt char

/*
char encode(char messageChar, char pass1Char,char pass2Char)
{
    pass1Char -= 98;
    pass2Char -= 98;
    messageChar -= pass1Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }

    messageChar -= pass2Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }
    return messageChar;
}
*/

encrypt:
        @Letter - Key -> if <1 add 26, if >26 -26 -> +98
        SUB r0, r2
        CMP r0, #0
        ADDLE r0, #26
        @add 96 to make a-z and +2
        ADD r1,r0,#98
        LDR r0, =char
        @print encryptd character
        BL printf
        B getnewchar
@////////////////////////////////////////////////////////////////////////
@function: decrypt   (decode)
@desc:decrypt char using two keys
@return: decrypted char

/*
char decode(unsigned char messageChar, char pass1Char, char pass2Char)
{
    pass1Char -= 98;
    pass2Char -= 98;
    messageChar += pass1Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }

    messageChar += pass2Char;
    if(messageChar < 97)
    {
        messageChar += 26;
    }
    else if (messageChar > 122)
    {
        messageChar -= 26;
    }

    return messageChar;
}
*/

decrypt:
        @reverse
        ADD r0, r2
        CMP r0, #26
        SUBGT r0, #26
        ADD r1,r0, #98
        LDR r0, =char
        BL printf
        B getnewchar

@////////////////////////////////////////////////////////////////////////
@function: end   (decode)
@desc:end function
@return: newline and exit

end:
        @output format
        LDR r0, =newline
        @print
        BL printf
        POP {r4,r5,r6,r7,r8,lr}
        BX lr




















