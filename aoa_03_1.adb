with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Matching.Character_Regular_Expression;

procedure AOA_03_1 is
   Input : Ada.Text_IO.File_Type;
   Pat   : PragmARC.Matching.Character_Regular_Expression.Processed_Pattern;
   Loc   : PragmARC.Matching.Character_Regular_Expression.Result;
   Start : Positive;
   Stop  : Positive;
   Comma : Natural;
   Sum   : Natural := 0;
begin -- AOA_03_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_03");
   PragmARC.Matching.Character_Regular_Expression.Process (Pattern => "mul([0-9]*[0-9],[0-9]*[0-9])", Processed => Pat);

   Read : loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Line : constant String := Ada.Text_IO.Get_Line (Input);
      begin -- One_Line
         Start := Line'First;

         All_Muls : loop
            Loc := PragmARC.Matching.Character_Regular_Expression.Location (Pat, Line (Start .. Line'Last) );

            exit All_Muls when not Loc.Found;

            Start := Loc.Start + 4;              -- Index of 1st digit
            Stop  := Loc.Start + Loc.Length - 2; -- Index of last digit

            Comma := Ada.Strings.Fixed.Index (Line (Start .. Stop), ",");

            if Comma /= 0 then
               Sum := Sum + (Integer'Value (Line (Start .. Comma - 1) ) * Integer'Value (Line (Comma + 1 .. Stop) ) );
            end if;

            Start := Loc.Start + Loc.Length;
         end loop All_Muls;
      end One_Line;
   end loop Read;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_03_1;
