with Ada.Text_IO;
with PragmARC.Data_Structures.Queues.Unbounded.Unprotected;

procedure AOA_17_2 is
   type U64 is mod 2 ** 64;
   type Word is mod 2 ** 3;

   type Program_List is array (U64 range <>) of Word;

   Program : constant Program_List := (2, 4, 1, 2, 7, 5, 4, 5, 0, 3, 1, 7, 5, 5, 3, 0);

   package Prefix_Queues is new PragmARC.Data_Structures.Queues.Unbounded.Unprotected (Element => U64);

   A      : U64 := 0;
   B      : U64 := 0;
   C      : U64 := 0;
   Q      : Prefix_Queues.Handle;
   Prefix : U64;
   Min    : U64 := U64'Last;
begin -- AOA_17_2
   Q.Put (Item => 0);

   All_Words : for I in reverse Program'Range loop
      All_Prefixes : for P in 1 .. Q.Length loop
         Q.Get (Item => Prefix);

         All_Bytes : for J in Word loop
            A := 8 * Prefix + U64 (J);
            B := U64 (J) xor 2; -- 2 4 (skipped); 1 2
            C := A / 2 ** Integer (B); -- 7 5
            B := (B xor C) xor 7; -- 4 5; 1 7
            --  A := A / 8; -- 0 3 (NOP)

            if B rem 8 = U64 (Program (I) ) then -- This should be true for some value of J (5 5)
               Q.Put (Item => 8 * Prefix + U64 (J) );
            end if;
         end loop All_Bytes;
      end loop All_Prefixes;
   end loop All_Words;

   Find_Min : loop
      exit Find_Min when Q.Is_Empty;

      Q.Get (Item => Prefix);
      Min := U64'Min (Min, Prefix);
   end loop Find_Min;

   Ada.Text_IO.Put_Line (Item => Min'Image);
end AOA_17_2;
