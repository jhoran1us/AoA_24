with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AOA_08_1 is
   Grid_Size : constant := 50; -- Map grid is this square

   subtype Grid_Line is String (1 .. Grid_Size);
   type Map_Grid is array (1 .. Grid_Size) of Grid_Line;

   type Node_Map is array (Map_Grid'Range, Map_Grid'Range) of Boolean;

   subtype Antenna_Symbol is Character with Dynamic_Predicate => Antenna_Symbol in 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9';

   Input : Ada.Text_IO.File_Type;
   Map   : Map_Grid;
   Node  : Node_Map := (others => (others => False) );
   Start : Natural;
   X     : Natural;
   X_Dif : Integer;
   Y_Dif : Integer;
   Count : Natural := 0;
begin -- AOA_08_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_08");

   Read : for I in Positive loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      Map (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read;

   All_Rows : for Row in Map'Range loop
      All_Cols : for Col in Map (Row)'range loop
         if Map (Row) (Col) in Antenna_Symbol then
            Start := Col + 1;

            All_Y : for Y in Row .. Grid_Size loop
               All_X : loop
                  X := Ada.Strings.Fixed.Index (Map (Y), Map (Row) (Col) & "", Start);

                  if X = 0 then
                     Start := 1;

                     exit All_X;
                  end if;

                  X_Dif := X - Col;
                  Y_Dif := Y - Row;

                  if Row - Y_Dif in Map'Range and Col - X_Dif in Map'Range then
                     Node (Row - Y_Dif, Col - X_Dif) := True;
                  end if;

                  if Y + Y_Dif in Map'Range and X + X_Dif in Map'Range then
                     Node (Y + Y_Dif, X + X_Dif) := True;
                  end if;

                  Start := X + 1;
               end loop All_X;
            end loop All_Y;
         end if;
      end loop All_Cols;
   end loop All_Rows;

   Count_Rows : for Row in Node'Range (1) loop
      Count_Cols : for Col in Node'Range (2) loop
         if Node (Row, Col) then
            Count := Count + 1;
         end if;
      end loop Count_Cols;
   end loop Count_Rows;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_08_1;
