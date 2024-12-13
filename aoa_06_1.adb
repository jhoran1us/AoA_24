with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Wrapping;

procedure AOA_06_1 is
   Grid_Size : constant := 130; -- Map grid is 140 x 140

   subtype Grid_Line is String (1 .. Grid_Size);
   type Map_Grid is array (1 .. Grid_Size) of Grid_Line;

   type Direction_ID is (Up, Right, Down, Left);

   package Direction_Wrapping is new PragmARC.Wrapping (Item => Direction_ID);
   use Direction_Wrapping;

   Input : Ada.Text_IO.File_Type;
   Map   : Map_Grid;
   G_Dir : Direction_ID := Up;
   G_Row : Natural;
   G_Col : Natural;
   Count : Natural := 0;
begin -- AOA_06_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_06");

   Read : for I in Positive loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      Map (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   Find_Guard : for I in Map'Range loop
      G_Col := Ada.Strings.Fixed.Index (Map (I), "^");

      if G_Col > 0 then
         G_Row := I;

         exit Find_Guard;
      end if;
   end loop Find_Guard;

   Map (G_Row) (G_Col) := 'X';

   Walk : loop
      case G_Dir is
      when Up =>
         G_Row := G_Row - 1;

         exit Walk when G_Row not in Map'Range;

         if Map (G_Row) (G_Col) = '#' then
            G_Row := G_Row + 1;
            G_Dir := Wrap_Succ (G_Dir);
         else
            Map (G_Row) (G_Col) := 'X';
         end if;
      when Right =>
         G_Col := G_Col + 1;

         exit Walk when G_Col not in Map'Range;

         if Map (G_Row) (G_Col) = '#' then
            G_Col := G_Col - 1;
            G_Dir := Wrap_Succ (G_Dir);
         else
            Map (G_Row) (G_Col) := 'X';
         end if;
      when Down =>
         G_Row := G_Row + 1;

         exit Walk when G_Row not in Map'Range;

         if Map (G_Row) (G_Col) = '#' then
            G_Row := G_Row - 1;
            G_Dir := Wrap_Succ (G_Dir);
         else
            Map (G_Row) (G_Col) := 'X';
         end if;
      when Left =>
         G_Col := G_Col - 1;

         exit Walk when G_Col not in Map'Range;

         if Map (G_Row) (G_Col) = '#' then
            G_Col := G_Col + 1;
            G_Dir := Wrap_Succ (G_Dir);
         else
            Map (G_Row) (G_Col) := 'X';
         end if;
      end case;
   end loop Walk;

   Count_Rows : for Row in Map'Range loop
      Count_Cols : for Col in Map (Row)'Range loop
         if Map (Row) (Col) = 'X' then
            Count := Count + 1;
         end if;
      end loop Count_Cols;
   end loop Count_Rows;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_06_1;
