with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AOA_10_1 is
   Grid_Size : constant := 57; -- Map grid is this square

   type Map_Grid is array (1 .. Grid_Size, 1 .. Grid_Size) of Natural;

   function Num_Trails (Row : in Positive; Col : in Positive) return Natural;
   -- Returns the number of summits reachable from Map (Row, Col)

   type Visit_Map is array (Map_Grid'Range (1), Map_Grid'Range (2) ) of Boolean;

   Map   : Map_Grid; -- Constant after initialization
   Visit : Visit_Map;

   function Num_Trails (Row : in Positive; Col : in Positive) return Natural is
      type Direction_ID is (Up, Right, Down, Left);

      Visited : constant Boolean := Visit (Row, Col);

      Y      : Natural;
      X      : Natural;
      Result : Natural := 0;
   begin -- Num_Trails
      if Map (Row, Col) = 9 then -- Reached a summit
         if Visited then -- There's another trail to this summit
            return 0;
         end if;

         Visit (Row, Col) := True;

         return 1;
      end if;

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

         if (Y in Map'Range (1) and X in Map'Range (2) ) and then Map (Y, X) = Map (Row, Col) + 1 then
            Result := Result + Num_Trails (Y, X);
         end if;
      end loop All_Dirs;

      return Result;
   end Num_Trails;

   Input : Ada.Text_IO.File_Type;
   Sum   : Natural := 0;
begin -- AOA_10_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_10");

   Read : for I in Map'Range (1) loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Line : constant String := Ada.Text_IO.Get_Line (Input);
      begin -- One_Line
         Copy : for J in Map'Range (2) loop
            Map (I, J) := Integer'Value (Line (J) & "");
         end loop Copy;
      end One_Line;
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   All_Rows : for Row in Map'Range (1) loop
      All_Cols : for Col in Map'Range (2) loop
         if Map (Row, Col) = 0 then
            Visit := (others => (others => False) );
            Sum := Sum + Num_Trails (Row, Col);
         end if;
      end loop All_Cols;
   end loop All_Rows;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_10_1;
