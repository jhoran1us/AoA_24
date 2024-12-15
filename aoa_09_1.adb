with Ada.Text_IO;

procedure AOA_09_1 is
   Input : Ada.Text_IO.File_Type;
begin -- AOA_09_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_09");

   Get_Map : declare
      Raw : constant String := Ada.Text_IO.Get_Line (Input);

      function Value (C : in Character) return Natural with
         Pre  => C in '0' .. '9',
         Post => Value'Result in 0 .. 9;

      function Length return Positive;
      -- Returns the total # blocks represented by Raw

      function Value (C : in Character) return Natural is
         (Character'Pos (C) - Character'Pos ('0') );

      function Length return Positive is
         Result : Natural := 0;
      begin -- Length
         All_Records : for C of Raw loop
            Result := Result + Value (C);
         end loop All_Records;

         return Result;
      end Length;

      Expanded_Length : constant Positive := Length;

      type Full_Map is array (0 .. Expanded_Length - 1) of Integer;

      type U64 is mod 2 ** 64;

      Map      : Full_Map := (others => -1); -- < 0 indicates free block; -1: initially free; -2: freed by compacting
      Next_Pos : Natural  := 0; -- Next position to fill in Map
      Next_ID  : Natural  := 0; -- Next file ID to use
      Index    : Positive := 1;
      Size     : Natural;
      Free     : Natural;
      Sum      : U64 := 0;
   begin -- Get_Map
      Fill : loop
         exit Fill when Index not in Raw'Range;

         Size := Value (Raw (Index) );
         Map (Next_Pos .. Next_Pos + Size - 1) := (others => Next_ID);
         Next_ID := Next_ID + 1;
         Next_Pos := Next_Pos + Size + (if Index < Raw'Last then Value (Raw (Index + 1) ) else 0);
         Index := Index + 2;
      end loop Fill;

      Size := Map'Last;
      Free := 0;

      Compact : loop
         Find_Free : loop
            exit Compact when Free > Size;
            exit Find_Free when Map (Free) = -1;

            Free := Free + 1;
         end loop Find_Free;

         Map (Free) := Map (Size);
         Map (Size) := -2;
         Free := Free + 1;

         Find_Used : loop
            Size := Size - 1;

            exit Find_Used when Free > Size or Map (Size) >= 0;
         end loop Find_Used;
      end loop Compact;

      Checksum : for I in Map'Range loop
         if Map (I) >= 0 then
            Sum := Sum + U64 (I) * U64 (Map (I) );
         end if;
      end loop Checksum;

      Ada.Text_IO.Put_Line (Item => Sum'Image);
   end Get_Map;
end AOA_09_1;
