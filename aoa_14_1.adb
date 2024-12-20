with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AOA_14_1 is
   Width    : constant := 101;
   Height   : constant := 103;
   Last_X   : constant := Width - 1;
   Last_Y   : constant := Height - 1;
   Mid_X    : constant := Last_X / 2;
   Mid_Y    : constant := Last_Y / 2;
   Num_Bots : constant := 500;

   type Count_Map is array (0 .. Last_X, 0 .. Last_Y) of Natural; -- Map (X, Y) => # of bots at that location

   type Bot_Info is record
      Px : Natural; -- Current position
      Py : Natural;
      Dx : Integer; -- Velocity tiles/s
      Dy : Integer;
   end record;

   type Bot_List is array (1 .. Num_Bots) of Bot_Info;

   Input : Ada.Text_IO.File_Type;
   Bot   : Bot_List;
   Map   : Count_Map := (others => (others => 0) );
   Q1    : Natural   := 0; -- Number of bots in each quadrant
   Q2    : Natural   := 0;
   Q3    : Natural   := 0;
   Q4    : Natural   := 0;
begin -- AOA_14_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_14");

   Read : for B in Bot'Range loop
      One_Bot  : declare
         Line  : constant String := Ada.Text_IO.Get_Line (Input);

         Space : Natural := Ada.Strings.Fixed.Index (Line, " ");
         Comma : Natural := Ada.Strings.Fixed.Index (Line, ",");
      begin -- One_Bot
         Bot (B).Px := Integer'Value (Line (3 .. Comma - 1) );
         Bot (B).Py := Integer'Value (Line (Comma + 1 .. Space - 1) );
         Comma := Ada.Strings.Fixed.Index (Line, ",", Space + 1);
         Bot (B).Dx := Integer'Value (Line (Space + 3 .. Comma - 1) );
         Bot (B).Dy := Integer'Value (Line (Comma + 1 .. Line'Last) );
         Map (Bot (B).Px, Bot (B).Py) := Map (Bot (B).Px, Bot (B).Py) + 1;
      end One_Bot;
   end loop Read;

   Ada.Text_IO.Close (File => Input);

   All_Moves : for S in 1 .. 100 loop
      All_Bots : for B in Bot'Range loop
         Map (Bot (B).Px, Bot (B).Py) := Map (Bot (B).Px, Bot (B).Py) - 1;
         Bot (B).Px := (Bot (B).Px + Bot (B).Dx) mod Width;
         Bot (B).Py := (Bot (B).Py + Bot (B).Dy) mod Height;
         Map (Bot (B).Px, Bot (B).Py) := Map (Bot (B).Px, Bot (B).Py) + 1;
      end loop All_Bots;
   end loop All_Moves;

   Count_X_1 : for X in 0 .. Mid_X - 1 loop
      Count_Y_1 : for Y in 0 .. Mid_Y - 1 loop
         Q1 := Q1 + Map (X, Y);
      end loop Count_Y_1;
   end loop Count_X_1;

   Count_X_2 : for X in Mid_X + 1 .. Last_X loop
      Count_Y_2 : for Y in 0 .. Mid_Y - 1 loop
         Q2 := Q2 + Map (X, Y);
      end loop Count_Y_2;
   end loop Count_X_2;

   Count_X_3 : for X in 0 .. Mid_X - 1 loop
      Count_Y_3 : for Y in Mid_Y + 1 .. Last_Y loop
         Q3 := Q3 + Map (X, Y);
      end loop Count_Y_3;
   end loop Count_X_3;

   Count_X_4 : for X in Mid_X + 1 .. Last_X loop
      Count_Y_4 : for Y in Mid_Y + 1 .. Last_Y loop
         Q4 := Q4 + Map (X, Y);
      end loop Count_Y_4;
   end loop Count_X_4;

   Ada.Text_IO.Put_Line (Item => Integer'Image (Q1 * Q2 * Q3 * Q4) );
end AOA_14_1;
