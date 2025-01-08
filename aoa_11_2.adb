with Ada.Containers.Hashed_Maps;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;
with PragmARC.Images;

procedure AOA_11_2 is
   type U64 is mod 2 ** 64;

   function Image is new PragmARC.Images.Modular_Image (Number => U64);

   function Hash (Key : in U64) return Ada.Containers.Hash_Type is
      (if Ada.Containers.Hash_Type'Size >= U64'Size then Ada.Containers.Hash_Type (Key)
       else Ada.Containers.Hash_Type (Key rem Ada.Containers.Hash_Type'Modulus xor Key / Ada.Containers.Hash_Type'Modulus) );

   type Solution_Info is record
      Num : U64;
      Two : Boolean;
      S_1 : U64;
      S_2 : U64;
   end record;

   package Solution_Maps is new
      Ada.Containers.Hashed_Maps (Key_Type => U64, Element_Type => Solution_Info, Hash => Hash, Equivalent_Keys => "=");

   procedure Update (Value : in U64; Num : in U64; Map : in out Solution_Maps.Map);
   -- Updates Map to indicate that an additional Num instances of Value are present

   procedure Update (Value : in U64; Num : in U64; Map : in out Solution_Maps.Map) is
      Effect  : Solution_Info;
   begin -- Update
      if Map.Contains (Value) then
         Effect := Map.Element (Value);
         Effect.Num := Effect.Num + Num;
      else
         Get_Image : declare
            Img : constant String  := Image (Value);
            Mid : constant Natural := Img'First + (Img'Last - Img'First + 1) / 2 - 1;
         begin -- Get_Image
            if Value = 0 then
               Effect := (Num => Num, Two => False, S_1 => 1, S_2 => 0);
            elsif Img'Length rem 2 = 0 then
               Effect := (Num => Num,
                          Two => True,
                          S_1 => U64'Value (Img (Img'First .. Mid) ),
                          S_2 => U64'Value (Img (Mid + 1 .. Img'Last) ) );
            else
               Effect := (Num => Num, Two => False, S_1 => 2024 * Value, S_2 => 0);
            end if;
         end Get_Image;
      end if;

      Map.Include (Key => Value, New_Item => Effect);
   end Update;

   Input   : Ada.Text_IO.File_Type;
   New_Map : Solution_Maps.Map;
   Cur_Map : Solution_Maps.Map;
   Effect  : Solution_Info;
   Pos     : Solution_Maps.Cursor;
   Count   : U64 := 0;

   use type Solution_Maps.Cursor;
begin -- AOA_11_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_11");

   Read_List : declare
      Field  : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );

      use PragmARC.Conversions.Unbounded_Strings;
   begin -- Read_List
      Init : for I in 1 .. Field.Last_Index loop
         Update (Value => U64'Value (+Field.Element (I) ), Num => 1, Map => New_Map);
      end loop Init;
   end Read_List;
   -- New_Map now contains result of 1st blink

   Ada.Text_IO.Close (File => Input);

   All_Blinks : for Blink in 2 .. 75 loop
      Cur_Map := New_Map;
      New_Map.Clear;
      Pos := Cur_Map.First;

      All_Stones : loop
         exit All_Stones when Pos = Solution_Maps.No_Element;

         Effect := Solution_Maps.Element (Pos);
         Update (Value => Effect.S_1, Num => Effect.Num, Map => New_Map);

         if Effect.Two then
            Update (Value => Effect.S_2, Num => Effect.Num, Map => New_Map);
         end if;

         Solution_Maps.Next (Position => Pos);
      end loop All_Stones;
   end loop All_Blinks;

   Pos := New_Map.First;

   Count_Stones : loop
      exit Count_Stones when Pos = Solution_Maps.No_Element;

      Effect := Solution_Maps.Element (Pos);
      Count := Count + (if Effect.Two then 2 else 1) * Effect.Num;
      Solution_Maps.Next (Position => Pos);
   end loop Count_Stones;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AOA_11_2;
