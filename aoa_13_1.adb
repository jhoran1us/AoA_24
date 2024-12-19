with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AOA_13_1 is
   package Natural_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Natural);
   package Sorting is new Natural_Lists.Generic_Sorting;

   Input : Ada.Text_IO.File_Type;
   Token : Natural_Lists.Vector;
   Ax    : Natural; -- A button X increment
   Ay    : Natural; -- A button Y increment
   Bx    : Natural; -- B button X increment
   By    : Natural; -- B button Y increment
   Px    : Natural; -- Prize X coordinate
   Py    : Natural; -- Prize Y coordinate
   Sum   : Natural := 0;
begin -- AOA_13_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_13");

   All_Games : loop
      exit All_Games when Ada.Text_IO.End_Of_File (Input);

      A_Info : declare
         Line : constant String := Ada.Text_IO.Get_Line (Input);

         Plus  : Natural := Ada.Strings.Fixed.Index (Line, "+");
         Comma : Natural := Ada.Strings.Fixed.Index (Line, ",", Plus + 1);
      begin -- A_Info
         Ax := Integer'Value (Line (Plus + 1 .. Comma - 1) );
         Plus := Ada.Strings.Fixed.Index (Line, "+", Comma + 1);
         Ay := Integer'Value (Line (Plus + 1 .. Line'Last) );
      end A_Info;

      B_Info : declare
         Line : constant String := Ada.Text_IO.Get_Line (Input);

         Plus  : Natural := Ada.Strings.Fixed.Index (Line, "+");
         Comma : Natural := Ada.Strings.Fixed.Index (Line, ",", Plus + 1);
      begin -- B_Info
         Bx := Integer'Value (Line (Plus + 1 .. Comma - 1) );
         Plus := Ada.Strings.Fixed.Index (Line, "+", Comma + 1);
         By := Integer'Value (Line (Plus + 1 .. Line'Last) );
      end B_Info;

      Prize : declare
         Line : constant String := Ada.Text_IO.Get_Line (Input);

         Eq    : Natural := Ada.Strings.Fixed.Index (Line, "=");
         Comma : Natural := Ada.Strings.Fixed.Index (Line, ",", Eq + 1);
      begin -- Prize
         Px := Integer'Value (Line (Eq + 1 .. Comma - 1) );
         Eq := Ada.Strings.Fixed.Index (Line, "=", Comma + 1);
         Py := Integer'Value (Line (Eq + 1 .. Line'Last) );
      end Prize;

      if not Ada.Text_IO.End_Of_File (Input) then
         Ada.Text_IO.Skip_Line (File => Input);
      end if;

      Token.Clear;

      All_A : for A in 0 .. 100 loop
         exit All_A when A * Ax > Px or A * Ay > Py;

         if A * Ax = Px and A * Ay = Py then
            Token.Append (New_Item => A * 3);

            exit All_A;
         end if;

         All_B : for B in 0 .. 100 loop
            exit All_B when A * Ax + B * Bx > Px or A * Ay + B * By > Py;

            if A * Ax + B * Bx = Px and A * Ay + B * By = Py then
               Token.Append (New_Item => A * 3 + B);
            end if;
         end loop All_B;
      end loop All_A;

      if not Token.Is_Empty then
         Sorting.Sort (Container => Token);

         Sum := Sum + Token.Element (1);
      end if;
   end loop All_Games;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_13_1;
