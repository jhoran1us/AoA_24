with Ada.Text_IO;

procedure AOA_04_1 is
   Grid_Size : constant        := 140; -- Input grid is 140 x 140
   Xmas      : constant String := "XMAS"; -- Word to find
   Word_Size : constant        := Xmas'Length;

   subtype Grid_Line is String (1 .. Grid_Size);
   type Word_Grid is array (1 .. Grid_Size) of Grid_Line;

   Input : Ada.Text_IO.File_Type;
   Grid  : Word_Grid;
   Count : Natural := 0;
   Found : Boolean;
begin -- AOA_04_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_04");

   Read : for I in Positive loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      Grid (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   Search_Lines : for I in Grid'Range (1) loop
      Search_Columns : for J in Grid (I)'Range loop
         if Grid (I) (J) = Xmas (1) then
            if J <= Grid_Size - Word_Size + 1 and then Grid (I) (J .. J + Word_Size - 1) = Xmas then -- L-R
               Count := Count + 1;
            end if;

            if J >= Word_Size then -- RTL
               Found := True;

               RTL : for K in 1 .. Word_Size - 1 loop
                  if Grid (I) (J - K) /= Xmas (K + 1) then
                     Found := False;

                     exit RTL;
                  end if;
               end loop RTL;

               if Found then
                  Count := Count + 1;
               end if;
            end if;

            if I <= Grid_Size - Word_Size + 1 then -- T-B
               Found := True;

               TTB : for K in 1 .. Word_Size - 1 loop
                  if Grid (I + K) (J) /= Xmas (K + 1) then
                     Found := False;

                     exit TTB;
                  end if;
               end loop TTB;

               if Found then
                  Count := Count + 1;
               end if;
            end if;

            if I >= Word_Size then -- B-T
               Found := True;

               BTT : for K in 1 .. Word_Size - 1 loop
                  if Grid (I - K) (J) /= Xmas (K + 1) then
                     Found := False;

                     exit BTT;
                  end if;
               end loop BTT;

               if Found then
                  Count := Count + 1;
               end if;
            end if;

            if I <= Grid_Size - Word_Size + 1 and J <= Grid_Size - Word_Size + 1 then -- UL-LR
               Found := True;

               ULLR : for K in 1 .. Word_Size - 1 loop
                  if Grid (I + K) (J + K) /= Xmas (K + 1) then
                     Found := False;

                     exit ULLR;
                  end if;
               end loop ULLR;

               if Found then
                  Count := Count + 1;
               end if;
            end if;

            if I >= Word_Size and J >= Word_Size then -- LR-UL
               Found := True;

               LRUL : for K in 1 .. Word_Size - 1 loop
                  if Grid (I - K) (J - K) /= Xmas (K + 1) then
                     Found := False;

                     exit LRUL;
                  end if;
               end loop LRUL;

               if Found then
                  Count := Count + 1;
               end if;
            end if;

            if I >= Word_Size and J <= Grid_Size - Word_Size + 1 then -- LL-UR
               Found := True;

               LLUR : for K in 1 .. Word_Size - 1 loop
                  if Grid (I - K) (J + K) /= Xmas (K + 1) then
                     Found := False;

                     exit LLUR;
                  end if;
               end loop LLUR;

               if Found then
                  Count := Count + 1;
               end if;
            end if;

            if I <= Grid_Size - Word_Size + 1 and J >= Word_Size then -- UR-LL
               Found := True;

               URLL : for K in 1 .. Word_Size - 1 loop
                  if Grid (I + K) (J - K) /= Xmas (K + 1) then
                     Found := False;

                     exit URLL;
                  end if;
               end loop URLL;

               if Found then
                  Count := Count + 1;
               end if;
            end if;
         end if;
      end loop Search_Columns;
   end loop Search_Lines;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_04_1;
