with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AOA_12_1 is
   Grid_Size : constant := 140; -- Map grid is this square

   subtype Map_Row is String (1 .. Grid_Size);
   type Map_Grid is array (1 .. Grid_Size) of Map_Row;
   type Visit_Map is array (Map_Grid'Range, Map_Row'Range) of Boolean;

   function Num_Fences (Row : in Positive; Col : in Positive) return Natural;
   -- Counts the number of borders in Map for the region containing (Row, Col) that have not yet been visited
   -- If Area (Row, Col), returns 0
   -- Otherwise, sets Visit (Row, Col) and Area (Row, Col) to True

   Map   : Map_Grid; -- Constant after initialization
   Visit : Visit_Map := (others => (others => False) );
   Area  : Visit_Map;

   function Num_Fences (Row : in Positive; Col : in Positive) return Natural is
      type Direction_ID is (Up, Right, Down, Left);

      Y : Natural;
      X : Natural;
      Result : Natural := 0;
   begin -- Num_Fences
      if Area (Row, Col) then
         return 0;
      end if;

      Visit (Row, Col) := True;
      Area  (Row, Col) := True;

      All_Dirs : for Dir in Direction_ID loop
         case Dir is
         when Up =>
            Y := Row - 1;
            X := Col;
         when Right =>
            Y := Row;
            X := Col + 1;
         when Down =>
            Y := Row + 1;
            X := Col;
         when Left =>
            Y := Row;
            X := Col - 1;
         end case;

         if Y not in Map'Range or X not in Map'Range then -- On edge of Map
            Result := Result + 1;
         elsif Map (Y) (X) /= Map (Row) (Col) then -- On edge of region
            Result := Result + 1;
         elsif not Area (Y, X) then -- Unvisited part of region
            Result := Result + Num_Fences (Y, X);
         else -- Already treated
            null;
         end if;
      end loop All_Dirs;

      return Result;
   end Num_Fences;

   Input : Ada.Text_IO.File_Type;
   Fence : Natural;
   Count : Natural;
   Sum   : Natural := 0;
begin -- AOA_12_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_12");

   Read : for I in Map'Range (1) loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      Map (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   All_Rows : for Row in Map'Range loop
      All_Cols : for Col in Map (Row)'range loop
         if not Visit (Row, Col) then
            Area := (others => (others => False) );
            Fence := Num_Fences (Row, Col);
            Count := 0;

            Area_Y : for Y in Area'Range (1) loop
               Area_X : for X in Area'Range (2) loop
                  if Area (Y, X) then
                     Count := Count + 1;
                  end if;
               end loop Area_X;
            end loop Area_Y;

            Sum := Sum + Fence * Count;
         end if;
      end loop All_Cols;
   end loop All_Rows;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_12_1;
