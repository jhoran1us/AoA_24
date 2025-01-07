with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;
with PragmARC.Images;

procedure AOA_19_1 is
   Input : Ada.Text_IO.File_Type;
   Count : Natural := 0;
begin -- AOA_19_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_19");

   Read_List : declare
      function Possible (Design : in String) return Boolean;
      -- Returns True if Design is possible using Pattern; False otherwise

      Pattern : PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input), ',');
      -- Constant after adjustment

      use PragmARC.Conversions.Unbounded_Strings;

      function Possible (Design : in String) return Boolean is
         -- Empty
      begin -- Possible
         if Design = "" then
            return True;
         end if;

         Check : for I in 1 .. Pattern.Last_Index loop
            One_Pattern : declare
               Pat : constant String := +Pattern.Element (I);
            begin -- One_Pattern
               if (Pat'Length > 0 and Design'Length >= Pat'Length) and then
                  Design (Design'First .. Design'First + Pat'Length - 1) = Pat and then
                  Possible (Design (Design'First + Pat'Length .. Design'Last) )
               then
                  return True;
               end if;
            end One_Pattern;
         end loop Check;

         return False;
      end Possible;

      use Ada.Strings.Fixed;
   begin -- Read_List
      Ada.Text_IO.Skip_Line (File => Input);

      Trim : for I in 2 .. Pattern.Last_Index loop
         One_Code : declare
            Code : constant String := +Pattern.Element (I);
         begin -- One_Code
            if Code'Length > 0 and then Code (1) = ' ' then
               Pattern.Replace_Element (Index => I, New_Item => +Code (2 .. Code'Last) );
            end if;
         end One_Code;
      end loop Trim; -- Pattern is now a constant

      All_Designs : loop
         exit All_Designs when Ada.Text_IO.End_Of_File (Input);

         if Possible (Ada.Text_IO.Get_Line (Input) ) then
            Count := Count + 1;
         end if;
      end loop All_Designs;
   end Read_List;

   Ada.Text_IO.Close (File => Input);

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_19_1;
