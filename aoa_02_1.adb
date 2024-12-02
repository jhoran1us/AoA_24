with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AOA_02_1 is
   Input : Ada.Text_IO.File_Type;
   Safe  : Natural := 0;

   use PragmARC.Conversions.Unbounded_Strings;
begin -- AOA_02_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_02");

   Read : loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Field : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );
      begin -- One_Line
         if ( (for all I in 2 .. Field.Last_Index =>
                  Integer'Value (+Field.Element (I) ) < Integer'Value (+Field.Element (I - 1) ) ) or
              (for all I in 2 .. Field.Last_Index =>
                  Integer'Value (+Field.Element (I) ) > Integer'Value (+Field.Element (I - 1) ) ) ) and
            (for all I in 2 .. Field.Last_Index =>
                abs (Integer'Value (+Field.Element (I) ) - Integer'Value (+Field.Element (I - 1) ) ) in 1 .. 3)
         then
            Safe := Safe + 1;
         end if;
      end One_Line;
   end loop Read;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Safe'Image);
end AOA_02_1;
