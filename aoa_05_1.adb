with Ada.Containers.Vectors;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AOA_05_1 is
   subtype Page_Number is Integer range 11 .. 99;
   package Page_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Page_Number);

   type Page_Info is record
      Before : Page_Lists.Vector; -- Pages that must come before this page
      After  : Page_Lists.Vector; --           "          after      "
   end record;

   type Info_Map is array (Page_Number) of Page_Info;

   type Page_List is array (Positive range <>) of Page_Number;

   Input : Ada.Text_IO.File_Type;
   Page  : Info_Map;
   Sum   : Natural := 0;

   use PragmARC.Conversions.Unbounded_Strings;
begin -- AOA_05_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_05");

   Read_Order : loop
      exit Read_Order when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Field : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input), '|');

         Left  : Page_Number;
         Right : Page_Number;
      begin -- One_Line
         exit Read_Order when Field.Last_Index = 0;

         Left  := Integer'Value (+Field.Element (1) );
         Right := Integer'Value (+Field.Element (2) );
         Page (Left).After.Append (New_Item => Right);
         Page (Right).Before.Append (New_Item => Left);
      end One_Line;
   end loop Read_Order;

   Read_Updates : loop
      exit Read_Updates when Ada.Text_IO.End_Of_File (Input);

      One_Update : declare
         Field : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input), ',');

         Update  : Page_List (1 .. Field.Last_Index);
         Correct : Boolean := True;
      begin -- One_Update
         Fill : for I in Update'Range loop
            Update (I) := Integer'Value (+Field.Element (I) );
         end loop Fill;

         Check : for I in Update'Range loop
            Following : for J in 1 .. I - 1 loop
               if not Page (Update (I) ).Before.Contains (Update (J) ) then
                  Correct := False;

                  exit Check;
               end if;
            end loop Following;

            Preceeding : for J in I + 1 .. Update'Last loop
               if not Page (Update (I) ).After.Contains (Update (J) ) then
                  Correct := False;

                  exit Check;
               end if;
            end loop Preceeding;
         end loop Check;

         if Correct then
            Sum := Sum + Update ( (1 + Update'Last) / 2);
         end if;
      end One_Update;
   end loop Read_Updates;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_05_1;
