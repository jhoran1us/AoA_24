with Ada.Text_IO;

procedure AOA_22_1 is
   type U64 is mod 2 ** 64;

   function Next (Num : in U64) return U64;
   -- Calculates the next number from Num

   function Next (Num : in U64) return U64 is
      Modulus : constant := 16777216;

      Result : U64 := ( (64 * Num) xor Num) mod Modulus;
   begin -- Next
      Result := ( (Result / 32) xor Result) mod Modulus;
      Result := ( (2048 * Result) xor Result) mod Modulus;

      return Result;
   end Next;

   Input : Ada.Text_IO.File_Type;
   Num   : U64;
   Sum   : U64 := 0;
begin -- AOA_22_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_22");

   All_Buyers : loop
      exit All_Buyers when Ada.Text_IO.End_Of_File (Input);

      Num := U64'Value (Ada.Text_IO.Get_Line (Input) );

      Generate : for I in 1 .. 2000 loop
         Num := Next (Num);
      end loop Generate;

      Sum := Sum + Num;
   end loop All_Buyers;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_22_1;
