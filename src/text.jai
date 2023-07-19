#import "Simp";

DEFAULT_COLOR := Vector4.{1, 0, 0, 1};

draw_text :: (font: *Dynamic_Font, text_color: Vector4, text: string, text_x: int, text_y: int) -> int {
  // @TIP: There is a character height hidden in font
  text_width := Simp.prepare_text(font, text);
  Simp.draw_prepared_text(font, text_x, text_y, text_color);

  return text_width;
}

draw_text :: (text: string, text_x: int, text_y: int) -> int {
  font := MEDIUM_FONT;
  text_color := DEFAULT_COLOR;
  text_width := Simp.prepare_text(font, text);

  Simp.draw_prepared_text(font, text_x, text_y, text_color);

  return text_width;
}

