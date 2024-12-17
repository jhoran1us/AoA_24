with Ada.Containers.Vectors;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;
with PragmARC.Images;

procedure AOA_11_1 is
   type U64 is mod 2 ** 64;

   package U64_Vectors is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => U64);

   function Image is new PragmARC.Images.Modular_Image (Number => U64);

   Input : Ada.Text_IO.File_Type;
   List  : U64_Vectors.Vector;
   Index : Positive;
begin -- AOA_11_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_11");

   Read_List : declare
      Field  : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );

      use PragmARC.Conversions.Unbounded_Strings;
   begin -- Read_List
      Convert : for I in 1 .. Field.Last_Index loop
         List.Append (New_Item => U64'Value (+Field.Element (I) ) );
      end loop Convert;
   end Read_List;

   Ada.Text_IO.Close (File => Input);

   All_Blinks : for Blink in 1 .. 25 loop
      Index := 1;

      All_Stones : loop
         exit All_Stones when Index > List.Last_Index;

         Get_Image : declare
            Element : constant U64     := List.Element (Index);
            Img     : constant String  := Image (Element);
            Mid     : constant Natural := Img'First + (Img'Last - Img'First + 1) / 2 - 1;
         begin -- Get_Image
            if Element = 0 then
               List.Replace_Element (Index => Index, New_Item => 1);
               Index := Index + 1;
            elsif Img'Length rem 2 = 0 then
               List.Replace_Element (Index => Index, New_Item => U64'Value (Img (Img'First .. Mid) ) );
               List.Insert (Before => Index + 1, New_Item => U64'Value (Img (Mid + 1 .. Img'Last) ) );
               Index := Index + 2;
            else
               List.Replace_Element (Index => Index, New_Item => 2024 * Element);
               Index := Index + 1;
            end if;
         end Get_Image;
      end loop All_Stones;
   end loop All_Blinks;

   Ada.Text_IO.Put_Line (Item => List.Last_Index'Image);
end AOA_11_1;
