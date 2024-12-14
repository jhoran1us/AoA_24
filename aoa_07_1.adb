with Ada.Containers.Vectors;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;
with PragmARC.Permutations;

procedure AOA_07_1 is
   type U64 is mod 2 ** 64;

   function To_64 (Image : in String) return U64 with
      Pre => Image'Length > 1 and then Image (Image'Last) = ':';
   -- Strips off trailing ':' from Image and passes the rest to U64'Value

   function Valid (List : in PragmARC.Line_Fields.Field_List) return Boolean;
   -- List (1) is the desired result
   -- Returns True if some combination of "+" and "*" operators, applied to List (2 .. List'Last) yields the desired result
   -- False otherwise

   function To_64 (Image : in String) return U64 is
      (U64'Value (Image (Image'First .. Image'Last - 1) ) );

   use PragmARC.Conversions.Unbounded_Strings;

   function Valid (List : in PragmARC.Line_Fields.Field_List) return Boolean is
      package Permutations is new PragmARC.Permutations (Element => Character);

      type Operand_List is array (1 .. List.Last_Index - 1) of U64;
      subtype Operator_List is Permutations.Sequence (1 .. Operand_List'Last - 1); -- Operator I is applied to operands I and I+1

      function Eval (Operand : in Operand_List; Operator : in Operator_List) return U64;
      -- Applies Operator to Operator to obtain the result

      procedure Check (Operator : in Permutations.Sequence; Stop : in out Boolean);
      -- If Eval (Operand, Operator) then sets Found and Stop to True; no effect otherwise

      function Eval (Operand : in Operand_List; Operator : in Operator_List) return U64 is
         Result : U64 := Operand (1);
      begin -- Eval
         Apply : for I in Operator'Range loop
            Result := (if Operator (I) = '+' then Result + Operand (I + 1)
                       elsif Operator (I) = '*' then Result * Operand (I + 1)
                       else raise Program_Error with "Eval: invalid operator " & Operator (I) );
         end loop Apply;

         return Result;
      end Eval;

      Desired : constant U64 := To_64 (+List.Element (1) );

      Operand : Operand_List; -- Constant after initialization
      Found   : Boolean;

      procedure Check (Operator : in Permutations.Sequence; Stop : in out Boolean) is
         -- Empty
      begin -- Check
         if Desired = Eval (Operand, Operator) then
            Found := True;
            Stop  := True;
         end if;
      end Check;

      Operator : Operator_List := (others => '+');
      Prod     : U64;
      Sum      : U64;
   begin -- Valid
      Fill : for I in Operand'Range loop
         Operand (I) := U64'Value (+List.Element (I + 1) );
      end loop Fill;

      Sum := Eval (Operand, Operator);
      Prod := Eval (Operand, (others => '*') );

      if Desired not in Sum .. Prod then
         return False;
      end if;

      if Desired in Sum | Prod then
         return True;
      end if;

      All_Stars : for I in 1 .. Operator'Last - 1 loop -- Check all mixtures of '+' and '*'
         Found := False;
         Operator (I) := '*';
         Permutations.Generate (Initial => Operator, Process => Check'Access);

         if Found then
            return True;
         end if;
      end loop All_Stars;

      return False;
   end Valid;

   Input : Ada.Text_IO.File_Type;
   Sum   : U64 := 0;
begin -- AOA_07_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_07");

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Field  : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );
         Result : constant U64                             := To_64 (+Field.Element (1) );
      begin -- One_Line
         if Valid (Field) then
            Sum := Sum + Result;
         end if;
      end One_Line;
   end loop All_Lines;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AOA_07_1;
