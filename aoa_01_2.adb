with Ada.Containers.Vectors;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AOA_01_2 is
   package Natural_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Natural);

   function Count (Value : in Natural; List : in Natural_Lists.Vector) return Natural;
   -- Returns the number of occurrences of Value in List

   function Count (Value : in Natural; List : in Natural_Lists.Vector) return Natural is
      Result : Natural := 0;
   begin -- Count
      Check_One : for I in 1 .. List.Last_Index loop
         if Value = List.Element (I) then
            Result := Result + 1;
         end if;
      end loop Check_One;

      return Result;
   end Count;

   Input : Ada.Text_IO.File_Type;
   Left  : Natural_Lists.Vector;
   Right : Natural_Lists.Vector;
   Sum   : Natural := 0;

   use PragmARC.Conversions.Unbounded_Strings;
begin -- AOA_01_2
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

   Add : for I in 1 .. Left.Last_Index loop
      Sum := Sum + Left.Element (I) * Count (Left.Element (I), Right);
   end loop Add;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_01_2;
