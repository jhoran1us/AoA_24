with Ada.Containers.Vectors;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AOA_02_2 is
   package Natural_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Natural);

   function To_List (Field : in PragmARC.Line_Fields.Field_List) return Natural_Lists.Vector;
   -- Converts each element of Field to Natural and collects them as the result

   function Is_Safe (List : in Natural_Lists.Vector) return Boolean is
      ( ( (for all I in 2 .. List.Last_Index => List.Element (I) < List.Element (I - 1) ) or
          (for all I in 2 .. List.Last_Index => List.Element (I) > List.Element (I - 1) ) ) and
        (for all I in 2 .. List.Last_Index => abs (List.Element (I) - List.Element (I - 1) ) in 1 .. 3) );

   use PragmARC.Conversions.Unbounded_Strings;

   function To_List (Field : in PragmARC.Line_Fields.Field_List) return Natural_Lists.Vector is
      Result : Natural_Lists.Vector;
   begin -- To_List
      Convert : for I in 1 .. Field.Last_Index loop
         Result.Append (New_Item => Integer'Value (+Field.Element (I) ) );
      end loop Convert;

      return Result;
   end To_List;

   Input : Ada.Text_IO.File_Type;
   Safe  : Natural := 0;
begin -- AOA_02_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_02");

   Read : loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         List : constant Natural_Lists.Vector := To_List (PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) ) );

         Copy : Natural_Lists.Vector;
      begin -- One_Line
         if Is_Safe (List) then
            Safe := Safe + 1;
         else
            Reduce : for I in 1 .. List.Last_Index loop
               Copy := List;
               Copy.Delete (Index => I);

               if Is_Safe (Copy) then
                  Safe := Safe + 1;

                  exit Reduce;
               end if;
            end loop Reduce;
         end if;
      end One_Line;
   end loop Read;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Safe'Image);
end AOA_02_2;
