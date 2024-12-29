with Ada.Text_IO;

procedure AOA_17_1 is
   type U32 is mod 2 ** 32;
   type Word is mod 2 ** 3;
   subtype Combo is Word range 0 .. 6;

   type Program_List is array (U32 range <>) of Word;

   Program : constant Program_List := (2, 4, 1, 2, 7, 5, 4, 5, 0, 3, 1, 7, 5, 5, 3, 0);

   A : U32 := 22817223;
   B : U32 :=        0;
   C : U32 :=        0;

   function Value (Operand : Combo) return U32 is
      (case Operand is
       when 0 .. 3 => U32 (Operand),
       when 4      => A,
       when 5      => B,
       when 6      => C);

   PC    : U32 := 0;
   Old   : U32;
   Val   : U32;
   Comma : Boolean := False;
begin -- AOA_17_1
   All_Instructions : loop
      exit All_Instructions when PC not in Program'Range;

      Old := PC;

      case Program (PC) is
      when 0 =>
         Val := Value (Program (PC + 1) );
         A := A / 2 ** Integer (Val);
      when 1 =>
         B := B xor U32 (Program (PC + 1) );
      when 2 =>
         Val := Value (Program (PC + 1) );
         B := Val rem 8;
      when 3 =>
         if A /= 0 then
            PC := U32 (Program (PC + 1) );
         end if;
      when 4 =>
         B := B xor C;
      when 5 =>
         Val := Value (Program (PC + 1) );
         Ada.Text_IO.Put (Item => (if Comma then "," else "") & U32'Image (Val rem 8) (2) );
         Comma := True;
      when 6 =>
         raise Program_Error with "bdv (6) not implemented";
      when 7 =>
         Val := Value (Program (PC + 1) );
         C := A / 2 ** Integer (Val);
      end case;

      if PC = Old then
         PC := PC + 2;
      end if;
   end loop All_Instructions;

   Ada.Text_IO.New_Line;
end AOA_17_1;
