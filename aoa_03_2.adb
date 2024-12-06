with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Matching.Character_Regular_Expression;

procedure AOA_03_2 is
   type Command_ID is (Doing, Dont, Mul);
   type Command_Info is record
      Kind   : Command_ID;
      Start  : Positive;
      Length : Natural;
   end record;

   package Command_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Command_Info);

   function "<" (Left : in Command_Info; Right : in Command_Info) return Boolean is
      (Left.Start < Right.Start);

   package Sorting is new Command_Lists.Generic_Sorting;

   function File_As_String (File : in Ada.Text_IO.File_Type) return String with
      Pre => Ada.Text_IO.Is_Open (File) and then Ada.Text_IO.Mode (File) in Ada.Text_IO.In_File;
   -- Concatenates all the lines in File into a single String

   function File_As_String (File : in Ada.Text_IO.File_Type) return String is
      -- Empty
   begin --File_As_String
      if Ada.Text_IO.End_Of_File (File) then
         return "";
      end if;

      One_Line : declare
         Line : constant String := Ada.Text_IO.Get_Line (File);
      begin -- One_Line
         return Line & File_As_String (File);
      end One_Line;
   end File_As_String;

   Input   : Ada.Text_IO.File_Type;
   Pat     : PragmARC.Matching.Character_Regular_Expression.Processed_Pattern;
   Loc     : PragmARC.Matching.Character_Regular_Expression.Result;
   Start   : Natural;
   List    : Command_Lists.Vector;
   Stop    : Positive;
   Comma   : Natural;
   Command : Command_Info;
   Enabled : Boolean := True;
   Sum     : Natural := 0;

   package ASF renames Ada.Strings.Fixed;
begin -- AOA_03_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_03");
   PragmARC.Matching.Character_Regular_Expression.Process (Pattern => "mul([0-9]*[0-9],[0-9]*[0-9])", Processed => Pat);

   One_Line : declare
      Line : constant String := File_As_String (Input);
   begin -- One_Line
      Ada.Text_IO.Close (File => Input);
      Start := Line'First;

      All_Do : loop
         Start := ASF.Index (Line, "do()", Start);

         exit All_Do when Start = 0;

         List.Append (New_Item => (Kind => Doing, Start => Start, Length => 4) );
         Start := Start + 4;
      end loop All_Do;

      Start := Line'First;

      All_Dont : loop
         Start := ASF.Index (Line, "don't()", Start);

         exit All_Dont when Start = 0;

         List.Append (New_Item => (Kind => Dont, Start => Start, Length => 7) );
         Start := Start + 7;
      end loop All_Dont;

      Start := Line'First;

      All_Muls : loop
         exit All_Muls when Start > Line'Last;

         Loc := PragmARC.Matching.Character_Regular_Expression.Location (Pat, Line (Start .. Line'Last) );

         exit All_Muls when not Loc.Found;

         List.Append (New_Item => (Kind => Mul, Start => Loc.Start, Length => Loc.Length) );
         Start := Loc.Start + Loc.Length;
      end loop All_Muls;

      Sorting.Sort (Container => List);

      All_Commands : for I in 1 .. List.Last_Index loop
         Command := List.Element (I);

         case Command.Kind is
         when Doing =>
            Enabled := True;
         when Dont =>
            Enabled := False;
         when Mul =>
            Start := Command.Start + 4;
            Stop  := Command.Start + Command.Length - 2;
            Comma := ASF.Index (Line (Start .. Stop), ",");

            if Comma /= 0 and Enabled then
               Sum := Sum + (Integer'Value (Line (Start .. Comma - 1) ) * Integer'Value (Line (Comma + 1 .. Stop) ) );
            end if;
         end case;
      end loop All_Commands;
   end One_Line;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_03_2;
