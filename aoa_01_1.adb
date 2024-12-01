with Ada.Containers.Vectors;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AOA_01_1 is
   package Natural_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Natural);
   package Sorting is new Natural_Lists.Generic_Sorting;

   Input : Ada.Text_IO.File_Type;
   Left  : Natural_Lists.Vector;
   Right : Natural_Lists.Vector;
   Sum   : Natural := 0;

   use PragmARC.Conversions.Unbounded_Strings;
begin -- AOA_01_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_01");

   Read : loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Field : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );
      begin -- One_Line
         Left.Append  (New_Item => Integer'Value (+Field.Element (1) ) );
         Right.Append (New_Item => Integer'Value (+Field.Element (2) ) );
      end One_Line;
   end loop Read;

   Ada.Text_IO.Close (File => Input);
   Sorting.Sort (Container => Left);
   Sorting.Sort (Container => Right);

   Add : for I in 1 .. Left.Last_Index loop
      Sum := Sum + abs (Left.Element (I) - Right.Element (I) );
   end loop Add;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_01_1;
