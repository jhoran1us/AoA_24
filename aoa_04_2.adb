with Ada.Text_IO;

procedure AOA_04_2 is
   Grid_Size : constant        := 140; -- Input grid is 140 x 140
   Xmas      : constant String := "XMAS"; -- Word to find
   Word_Size : constant        := Xmas'Length;

   subtype Grid_Line is String (1 .. Grid_Size);
   type Word_Grid is array (1 .. Grid_Size) of Grid_Line;

   Input : Ada.Text_IO.File_Type;
   Grid  : Word_Grid;
   Count : Natural := 0;
   Found : Boolean;
begin -- AOA_04_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_04");

   Read : for I in Positive loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      Grid (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   Search_Lines : for I in 2 .. Grid_Size - 1 loop
      Search_Columns : for J in 2 .. Grid_Size - 1 loop
         if Grid (I) (J) = 'A' and
            ( ( (Grid (I - 1) (J - 1) = 'M' and Grid (I + 1) (J + 1) = 'S') or
                (Grid (I - 1) (J - 1) = 'S' and Grid (I + 1) (J + 1) = 'M') ) and
              ( (Grid (I + 1) (J - 1) = 'M' and Grid (I - 1) (J + 1) = 'S') or
                (Grid (I + 1) (J - 1) = 'S' and Grid (I - 1) (J + 1) = 'M') ) )
         then
            Count := Count + 1;
         end if;
      end loop Search_Columns;
   end loop Search_Lines;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_04_2;
