with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AOA_15_1 is
   Grid_Size : constant := 50; -- Map grid is this square

   subtype Map_Row is String (1 .. Grid_Size);
   type Map_Grid is array (1 .. Grid_Size) of Map_Row;

   Box   : constant Character := 'O';
   Space : constant Character := '.';

   Input : Ada.Text_IO.File_Type;
   Map   : Map_Grid;
   Rx    : Natural; -- Robot's coordinates
   Ry    : Positive;
   Move  : Character;
   Sx    : Positive;
   Sy    : Positive;
   Sum   : Natural := 0;
begin -- AOA_15_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_15");

   Read_Map : for I in Map'Range (1) loop
      Map (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read_Map;

   Ada.Text_IO.Skip_Line (File => Input);

   Robot_Y : for Y in Map'Range loop
      Rx := Ada.Strings.Fixed.Index (Map (Y), "@");

      if Rx in Map_Row'Range then
         Ry := Y;

         exit Robot_Y;
      end if;
   end loop Robot_Y;

   Read_Moves : loop
      exit Read_Moves when Ada.Text_IO.End_Of_File (Input);

      Ada.Text_IO.Get (File => Input, Item => Move);

      case Move is
      when '<' =>
         Left_X : for X in reverse 1 .. Rx - 1 loop
            if Map (Ry) (X) /= Box then
               exit Left_X when Map (Ry) (X) /= Space;

               Map (Ry) (X .. Rx - 1) := Map (Ry) (X + 1 .. Rx);
               Map (Ry) (Rx) := Space;
               Rx := Rx - 1;

               exit Left_X;
            end if;
         end loop Left_X;
      when '>' =>
         Right_X : for X in Rx + 1 .. Grid_Size loop
            if Map (Ry) (X) /= Box then
               exit Right_X when Map (Ry) (X) /= Space;

               Map (Ry) (Rx + 1 .. X) := Map (Ry) (Rx .. X - 1);
               Map (Ry) (Rx) := Space;
               Rx := Rx + 1;

               exit Right_X;
            end if;
         end loop Right_X;
      when '^' =>
         Up_Y : for Y in reverse 1 .. Ry - 1 loop
            if Map (Y) (Rx) /= Box then
               exit Up_Y when Map (Y) (Rx) /= Space;

               Shift_Up : for I in Y .. Ry - 1 loop
                  Map (I) (Rx) := Map (I + 1) (Rx);
               end loop Shift_Up;

               Map (Ry) (Rx) := Space;
               Ry := Ry - 1;

               exit Up_Y;
            end if;
         end loop Up_Y;
      when 'v'=>
         Down_Y : for Y in Ry + 1 .. Grid_Size loop
            if Map (Y) (Rx) /= Box then
               exit Down_Y when Map (Y) (Rx) /= Space;

               Shift_Down : for I in reverse Ry + 1 .. Y loop
                  Map (I) (Rx) := Map (I - 1) (Rx);
               end loop Shift_Down;

               Map (Ry) (Rx) := Space;
               Ry := Ry + 1;

               exit Down_Y;
            end if;
         end loop Down_Y;
      when others =>
         raise Program_Error with "Invalid move " & Move;
      end case;
   end loop Read_Moves;

   Ada.Text_IO.Close (File => Input);

   Sum_Y : for Y in Map'Range loop
      Sum_X : for X in Map (Y)'Range loop
         if Map (Y) (X) = Box then
            Sum := Sum + 100 * (Y - 1) + X - 1;
         end if;
      end loop Sum_X;
   end loop Sum_Y;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_15_1;
