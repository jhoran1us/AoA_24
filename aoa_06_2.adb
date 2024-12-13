with Ada.Containers.Ordered_Sets;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Wrapping;

procedure AOA_06_2 is
   Grid_Size : constant := 130; -- Map grid is 140 x 140

   subtype Grid_Line is String (1 .. Grid_Size);
   type Map_Grid is array (1 .. Grid_Size) of Grid_Line;

   function Loops (Map : in Map_Grid) return Boolean;
   -- Returns True if the guard enters a loop in Map; False if the guard exits the map

   function Loops (Map : in Map_Grid) return Boolean is
      type Direction_ID is (Up, Right, Down, Left);

      package Direction_Wrapping is new PragmARC.Wrapping (Item => Direction_ID);
      use Direction_Wrapping;

      type Guard_Info is record
         Dir : Direction_ID := Up;
         Row : Natural;
         Col : Natural;
      end record;

      function "<" (Left : in Guard_Info; Right : in Guard_Info) return Boolean is
         (if Left.Dir /= Right.Dir then
             Left.Dir < Right.Dir
          elsif Left.Row /= Right.Row then
             Left.Row < Right.Row
          else
             Left.Col < Right.Col);

      package Guard_Sets is new Ada.Containers.Ordered_Sets (Element_Type => Guard_Info);

      Guard : Guard_Info;
      Prior : Guard_Sets.Set;
   begin -- Loops
      Find_Guard : for I in Map'Range loop
         Guard.Col := Ada.Strings.Fixed.Index (Map (I), "^");

         if Guard.Col > 0 then
            Guard.Row := I;

            exit Find_Guard;
         end if;
      end loop Find_Guard;

      Prior.Include (New_Item => Guard);

      Walk : loop
         case Guard.Dir is
         when Up =>
            Guard.Row := Guard.Row - 1;

            if Guard.Row not in Map'Range then
               return False;
            end if;

            if Map (Guard.Row) (Guard.Col) = '#' then
               Guard.Row := Guard.Row + 1;
               Guard.Dir := Wrap_Succ (Guard.Dir);
            elsif Prior.Contains (Guard) then
               return True;
            else
               Prior.Include (New_Item => Guard);
            end if;
         when Right =>
            Guard.Col := Guard.Col + 1;

            if Guard.Col not in Map'Range then
               return False;
            end if;

            if Map (Guard.Row) (Guard.Col) = '#' then
               Guard.Col := Guard.Col - 1;
               Guard.Dir := Wrap_Succ (Guard.Dir);
            elsif Prior.Contains (Guard) then
               return True;
            else
               Prior.Include (New_Item => Guard);
            end if;
         when Down =>
            Guard.Row := Guard.Row + 1;

            if Guard.Row not in Map'Range then
               return False;
            end if;

            if Map (Guard.Row) (Guard.Col) = '#' then
               Guard.Row := Guard.Row - 1;
               Guard.Dir := Wrap_Succ (Guard.Dir);
            elsif Prior.Contains (Guard) then
               return True;
            else
               Prior.Include (New_Item => Guard);
            end if;
         when Left =>
            Guard.Col := Guard.Col - 1;

            if Guard.Col not in Map'Range then
               return False;
            end if;

            if Map (Guard.Row) (Guard.Col) = '#' then
               Guard.Col := Guard.Col + 1;
               Guard.Dir := Wrap_Succ (Guard.Dir);
            elsif Prior.Contains (Guard) then
               return True;
            else
               Prior.Include (New_Item => Guard);
            end if;
         end case;
      end loop Walk;

      --  raise Program_Error with "Loops: Can't happen";
   end Loops;

   Input : Ada.Text_IO.File_Type;
   Map   : Map_Grid;
   Count : Natural := 0;
begin -- AOA_06_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_06");

   Read : for I in Positive loop
      exit Read when Ada.Text_IO.End_Of_File (Input);

      Map (I) := Ada.Text_IO.Get_Line (Input);
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   All_Rows : for Row in Map'Range loop
      All_Cols : for Col in Map (Row)'Range loop
         if Map (Row) (Col) = '.' then
            Map (Row) (Col) := '#';

            if Loops (Map) then
               Count := Count + 1;
            end if;

            Map (Row) (Col) := '.';
         end if;
      end loop All_Cols;
   end loop All_Rows;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_06_2;
