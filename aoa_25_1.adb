with Ada.Containers.Vectors;
with Ada.Text_IO;

procedure AOA_25_1 is
   subtype Pin_ID is Integer range 1 .. 5;

   type Pattern_Grid is array (Pin_ID, 1 .. 7) of Character;
   type Height_List is array (Pin_ID) of Natural;

   package Height_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Height_List);

   Input   : Ada.Text_IO.File_Type;
   Pattern : Pattern_Grid;
   Height  : Height_List;
   Lock    : Height_Lists.Vector;
   Key     : Height_Lists.Vector;
   Sum     : Natural := 0;
begin -- AOA_25_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_25");

   All_Patterns : loop
      All_Heights : for Y in Pattern'Range (2) loop
         All_Pins : for P in Pattern'Range (1) loop
            Ada.Text_IO.Get (File => Input, Item => Pattern (P, Y) );
         end loop All_Pins;

         Ada.Text_IO.Skip_Line (File => Input);
      end loop All_Heights;

      if Pattern (1, 1) = '#' then -- It's a lock
         Lock_Heights : for P in Height'Range loop
            Lock_Search : for Y in 2 .. Pattern'Last (2) loop
               if Pattern (P, Y) = '.' then
                  Height (P) := Y - 2;

                  exit Lock_Search;
               end if;
            end loop Lock_Search;
         end loop Lock_Heights;

         Lock.Append (New_Item => Height);
      else -- A key
         Key_Heights : for P in Height'Range loop
            Key_Search : for Y in reverse 1 .. Pattern'Last (2) - 1 loop
               if Pattern (P, Y) = '.' then
                  Height (P) := 6 - Y;

                  exit Key_Search;
               end if;
            end loop Key_Search;
         end loop Key_Heights;

         Key.Append (New_Item => Height);
      end if;

      exit All_Patterns when Ada.Text_IO.End_Of_File (Input);

      Ada.Text_IO.Skip_Line (File => Input);
   end loop All_Patterns;

   Ada.Text_IO.Close (File => Input);

   All_Locks : for L in 1 .. Lock.Last_Index loop
      Get_Lock : declare
         Lock_Height : Height_List renames Lock.Element (L);
      begin -- Get_Lock
         All_Keys : for K in 1 .. Key.Last_Index loop
            Get_Key : declare
               Key_Height : Height_List renames Key.Element (K);
            begin -- Get_Key
               if (for all P in Lock_Height'Range => Lock_Height (P) + Key_Height (P) < 6) then
                  Sum := Sum + 1;
               end if;
            end Get_Key;
         end loop All_Keys;
      end Get_Lock;
   end loop All_Locks;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_25_1;
